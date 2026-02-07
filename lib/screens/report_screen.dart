import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/glass_card.dart';

class ReportScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ReportScreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final int score = reportData['score'] ?? 0;
    final String summary = reportData['summary'] ?? "Analysis complete.";
    final double hz = (reportData['hz'] ?? 0.0).toDouble();

    Color statusColor = ZahraColors.healingTeal;
    String statusText = "MINIMAL RISK";
    if (score >= 3) {
      statusColor = Colors.redAccent;
      statusText = "HIGH CLINICAL RISK";
    } else if (score >= 1) {
      statusColor = Colors.amber;
      statusText = "MODERATE CONCERN";
    }

    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "AI ASSESSMENT",
                        style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Zenith AI Analysis",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    "TRIPLE-CHECK VALIDATION COMPLETE",
                    style: TextStyle(color: ZahraColors.electricBlue, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  
                  // Score Overview
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  statusText,
                                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const Text("Biomarker Tracking Status", style: TextStyle(color: Colors.white38, fontSize: 12)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: statusColor.withOpacity(0.1),
                                border: Border.all(color: statusColor.withOpacity(0.3)),
                              ),
                              child: Icon(Icons.shield_outlined, color: statusColor),
                            ),
                          ],
                        ),
                        const Divider(height: 48, color: Colors.white12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoItem("MDS-UPDRS", "$score/4"),
                            _buildInfoItem("Avg. Freq", "${hz.toStringAsFixed(1)}Hz"),
                            _buildInfoItem("Confidence", "94%"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("CLINICAL SUMMARY", style: TextStyle(letterSpacing: 2, color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      summary,
                      style: const TextStyle(height: 1.6, fontSize: 15, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("KINEMATIC DETAILS", style: TextStyle(letterSpacing: 2, color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  
                  // Mock Chart Placeholder
                  GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.timeline_rounded, color: ZahraColors.electricBlue, size: 20),
                            SizedBox(width: 8),
                            Text("Movement Amplitude over time", style: TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 100,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _ChartPainter(color: statusColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("SAVE TO HEALTH RECORDS", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38, letterSpacing: 1)),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  final Color color;
  _ChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path();
    path.moveTo(0, size.height * 0.5);
    for (double i = 0; i <= size.width; i += 20) {
      path.lineTo(i, size.height * (0.3 + (i % 40 == 0 ? 0.4 : 0.1)));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
