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
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = "No cameras found.");
        return;
      }
      
      // On Web, sometimes the first camera isn't the user-facing one
      // We'll try to find a front camera or just take the first one
      CameraDescription selectedCamera = cameras.first;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        }
      }

      _controller = CameraController(
        selectedCamera, 
        ResolutionPreset.max, // Higher resolution for better AI analysis
        enableAudio: true,
        imageFormatGroup: kIsWeb ? null : ImageFormatGroup.jpeg,
      );
      
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => _error = "Camera Error: $e");
      debugPrint("Camera Error: $e");
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
          "summary": "AI detected slight tremor decrement typical of early-stage Parkinson's. Higher precision analysis complete."
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
        // Web requires bytes for upload
        final bytes = await xFile.readAsBytes();
        await storageRef.putData(bytes, SettableMetadata(contentType: 'video/mp4'));
      } else {
        final file = File(xFile.path);
        await storageRef.putFile(file);
      }
      debugPrint("Upload complete: $fileName");
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
        backgroundColor: ZahraColors.deepSpace,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go Back"),
              )
            ],
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: ZahraColors.deepSpace,
        body: Center(child: CircularProgressIndicator(color: ZahraColors.electricBlue)),
      );
    }

    // Calculate scaling to fill the screen
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      body: Stack(
        children: [
          // Full Screen Camera Preview
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(_controller!),
            ),
          ),
          
          // Guidance Overlay
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.info_outline, color: ZahraColors.electricBlue),
                  const SizedBox(height: 8),
                  Text(
                    _isUploading ? "UPLOADING TO AI ENGINE..." : "Position your hand clearly in the frame.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!_isUploading)
                    const Text(
                      "Perform 10 rapid finger taps (thumb to index).",
                      style: TextStyle(color: ZahraColors.textSecondary, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
          
          if (_isRecording || _isUploading)
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isUploading ? ZahraColors.healingTeal : ZahraColors.electricBlue.withOpacity(0.5), 
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isUploading ? const Center(child: CircularProgressIndicator()) : null,
              ),
            ),
          
          if (!_isUploading)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  if (_isRecording)
                    const Text(
                      "AI ANALYZING MOTION...",
                      style: TextStyle(color: ZahraColors.healingTeal, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
                          borderRadius: _isRecording ? BorderRadius.circular(12) : null,
                          color: _isRecording ? Colors.red : ZahraColors.electricBlue,
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.videocam,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
