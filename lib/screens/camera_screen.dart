import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _controller = CameraController(
        cameras[0], 
        ResolutionPreset.high,
        enableAudio: true,
      );
      
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Camera Error: $e");
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

      if (videoFile != null) {
        await _uploadVideo(videoFile.path);
        
        // MOCK DATA for Hackathon Demo
        // In production, this would wait for a Firestore update from the AI Backend
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
      // START RECORDING
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _uploadVideo(String path) async {
    try {
      final file = File(path);
      final fileName = "screenings/${DateTime.now().millisecondsSinceEpoch}.mp4";
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      
      await storageRef.putFile(file);
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
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: ZahraColors.deepSpace,
        body: Center(child: CircularProgressIndicator(color: ZahraColors.electricBlue)),
      );
    }

    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      body: Stack(
        children: [
          Center(
            child: CameraPreview(_controller!),
          ),
          
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
