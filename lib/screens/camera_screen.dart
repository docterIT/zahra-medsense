import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/glass_card.dart';
import 'report_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isRecording = false;
  bool _isUploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    setState(() => _error = null);
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = "No cameras detected. Please ensure your camera is connected and permissions are granted.");
        return;
      }
      
      CameraDescription selectedCamera = cameras.first;
      // Preference: Front camera for selfies/screening
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        }
      }

      _controller = CameraController(
        selectedCamera, 
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: kIsWeb ? null : ImageFormatGroup.jpeg,
      );
      
      if (kIsWeb) await Future.delayed(const Duration(milliseconds: 300));
      
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      String errorMessage = "Camera Error: $e";
      if (e.toString().contains("cameraNotReadable")) {
        errorMessage = "Camera is busy or not responding. Please close other apps using the camera (Zoom, Teams, Chrome Tab) and click Refresh.";
      }
      setState(() => _error = errorMessage);
    }
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_isRecording) {
      final XFile? videoFile = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _isUploading = true;
      });

      if (videoFile != null) {
        await _uploadVideo(videoFile);
        
        final mockReport = {
          "score": 1,
          "hz": 4.8,
          "summary": "AI detected slight tremor decrement typical of early-stage Parkinson's. Amplitude reduction identified in cycles 7-9."
        };

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReportScreen(reportData: mockReport)),
          );
        }
      }
    } else {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _uploadVideo(XFile xFile) async {
    try {
      final fileName = "screenings/${DateTime.now().millisecondsSinceEpoch}.mp4";
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      
      if (kIsWeb) {
        final bytes = await xFile.readAsBytes();
        await storageRef.putData(bytes, SettableMetadata(contentType: 'video/mp4'));
      } else {
        final file = File(xFile.path);
        await storageRef.putFile(file);
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam_off_rounded, color: Colors.redAccent, size: 80),
                const SizedBox(height: 24),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _initCamera,
                  icon: const Icon(Icons.refresh),
                  label: const Text("REFRESH CAMERA"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZahraColors.electricBlue,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Go Back", style: TextStyle(color: Colors.white54)),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: ZahraColors.electricBlue)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // TRULY FULL SCREEN CAMERA
          Center(
            child: AspectRatio(
              aspectRatio: 1 / _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          
          // Gradient Overlays for premium look
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Instruction Overlay
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isRecording ? 0.2 : 1.0,
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.sensors_rounded, color: ZahraColors.electricBlue, size: 28),
                    const SizedBox(height: 12),
                    Text(
                      _isUploading ? "AI PROCESSING..." : "Position Hand",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isUploading 
                          ? "Analyzing kinematic biomarkers" 
                          : "Perform rapid finger taps (10x)",
                      style: const TextStyle(color: ZahraColors.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          if (_isRecording || _isUploading)
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isUploading ? ZahraColors.healingTeal : Colors.white24, 
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: _isUploading 
                  ? const Center(child: CircularProgressIndicator(color: ZahraColors.healingTeal)) 
                  : Stack(
                    children: [
                      Positioned(
                        top: 10, right: 10,
                        child: Container(
                          width: 12, height: 12,
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          
          if (!_isUploading)
            Positioned(
              bottom: 60,
              left: 40,
              right: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isRecording ? Colors.red : Colors.white,
                          borderRadius: BorderRadius.circular(_isRecording ? 12 : 40),
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop_rounded : Icons.videocam_rounded,
                          color: _isRecording ? Colors.white : Colors.black,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
