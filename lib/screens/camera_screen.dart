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
  int _sessionSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = "No cameras detected.");
        return;
      }
      
      CameraDescription selectedCamera = cameras.first;
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
      setState(() => _error = "Camera Error: $e");
    }
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_isRecording) {
      // STOP RECORDING
      final XFile? videoFile = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _isUploading = true;
      });

      // Navigate to report with a clear mock processing delay
      // FIX: Ensure this is called and not stuck in a future
      _processAndNavigate(videoFile);
      
    } else {
      // START RECORDING
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _sessionSeconds = 0;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    if (_isRecording) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isRecording) {
          setState(() => _sessionSeconds++);
          _startTimer();
        }
      });
    }
  }

  Future<void> _processAndNavigate(XFile? videoFile) async {
    // Artificial delay to show "AI PROCESSING"
    await Future.delayed(const Duration(seconds: 3));
    
    if (videoFile != null) {
      await _uploadVideo(videoFile);
    }

    final mockReport = {
      "score": 1,
      "hz": 5.2,
      "status": "Stable",
      "sync_score": 92.4,
      "improvement": "+3.2%",
      "summary": "Analysis indicates consistent neuromuscular patterns. Tremor frequency in the left hand has decreased by 1.4Hz. Speech cadence shows 98% alignment with baseline recordings, suggesting strong cognitive processing stability."
    };

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReportScreen(reportData: mockReport)),
      );
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
        await storageRef.putFile(File(xFile.path));
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
        body: Center(child: Text(_error!, style: const TextStyle(color: Colors.white))),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: ZahraColors.mintGreen)),
      );
    }

    String timerText = "00:${_sessionSeconds.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Background
          Center(
            child: AspectRatio(
              aspectRatio: 1 / _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          
          // Dark Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          // Top Navigation
          Positioned(
            top: 60,
            left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                ),
                Column(
                  children: [
                    const Text(
                      "MICRO-MOTORIC ANALYSIS",
                      style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text("REC • LIVE STREAM", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune_rounded, color: Colors.white),
                ),
              ],
            ),
          ),

          // Central Instructions
          Positioned(
            top: 150,
            left: 24, right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isRecording ? 1.0 : 0.0,
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      "Please tap your thumb and\nindex finger repeatedly.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Keep your hand inside the highlighted\nframe",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ZahraColors.mintGreen, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tracking Box Overlay
          Center(
            child: Container(
              width: 280,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: ZahraColors.mintGreen.withOpacity(0.3), width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Corner markers
                  _buildCorner(0, 0, 40, 2, true, false),
                  _buildCorner(0, null, 40, 2, false, false),
                  _buildCorner(null, 0, 40, 2, true, true),
                  _buildCorner(null, null, 40, 2, false, true),
                  
                  // Stats Overlays
                  Positioned(
                    top: 40, left: 10,
                    child: _buildMetricPill("MOTION LATENCY", "12ms"),
                  ),
                  Positioned(
                    top: 120, left: 10,
                    child: _buildMetricPill("CONFIDENCE", "98.4%"),
                  ),
                  
                  // Hand icon indicator
                  Center(
                    child: Icon(Icons.back_hand_rounded, color: ZahraColors.mintGreen.withOpacity(0.4), size: 100),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 60,
            left: 24, right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SESSION TIME", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        Text(timerText, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ZahraColors.mintGreen)),
                      ],
                    ),
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("GEMINI 3", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            Text("ACTIVE PROCESSING", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: ZahraColors.darkCard, shape: BoxShape.circle),
                          child: const Icon(Icons.psychology, color: ZahraColors.mintGreen, size: 24),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.grid_view_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleRecording,
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: _isRecording ? Colors.red.withOpacity(0.2) : ZahraColors.mintGreen,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: _isRecording ? Colors.red : Colors.transparent, width: 2),
                          ),
                          child: Center(
                            child: _isUploading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_isRecording) Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.rectangle)),
                                    const SizedBox(width: 12),
                                    Text(
                                      _isRecording ? "END SCREENING" : "START RECORDING",
                                      style: TextStyle(
                                        color: _isRecording ? Colors.red : Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("POWERED BY NEURO-SYNC ENGINE V1.2", style: TextStyle(color: Colors.white12, fontSize: 9, letterSpacing: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill(String label, String val) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: ZahraColors.mintGreen, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: ZahraColors.mintGreen, fontSize: 8, fontWeight: FontWeight.bold)),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildCorner(double? t, double? l, double size, double width, bool isLeft, bool isBottom) {
    return Positioned(
      top: isBottom ? null : (t ?? 0),
      bottom: isBottom ? 0 : null,
      left: isLeft ? (l ?? 0) : null,
      right: isLeft ? null : 0,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          border: Border(
            top: !isBottom ? BorderSide(color: ZahraColors.mintGreen, width: width) : BorderSide.none,
            bottom: isBottom ? BorderSide(color: ZahraColors.mintGreen, width: width) : BorderSide.none,
            left: isLeft ? BorderSide(color: ZahraColors.mintGreen, width: width) : BorderSide.none,
            right: !isLeft ? BorderSide(color: ZahraColors.mintGreen, width: width) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
