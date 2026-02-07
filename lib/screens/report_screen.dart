import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/glass_card.dart';

class ReportScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ReportScreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text("Clinical Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Patient: Zahra M. • Oct 24, 2023", style: TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    "Status",
                    "Stable",
                    "NO SIGNIFICANT\nCHANGE",
                    Icons.circle,
                    Colors.greenAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    "Sync Score",
                    "${reportData['sync_score']}%",
                    "+3.2% vs Sept",
                    Icons.sync_alt_rounded,
                    ZahraColors.mintGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Gemini Reasoning Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ZahraColors.mintGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ZahraColors.mintGreen.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_rounded, color: ZahraColors.mintGreen, size: 20),
                      const SizedBox(width: 8),
                      Text("GEMINI 3 REASONING", style: TextStyle(color: ZahraColors.mintGreen, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    reportData['summary'],
                    style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Motor Trends", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                  child: const Text("Last 6 Months", style: TextStyle(color: Colors.white54, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Large Trend Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ZahraColors.darkCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: "86.2", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                        TextSpan(text: " Avg Score", style: TextStyle(color: ZahraColors.textSecondary, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 120,
                    width: double.infinity,
                    child: CustomPaint(painter: _TrendLinePainter()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_rounded),
                      label: const Text("Share with Doctor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZahraColors.mintGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: ZahraColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Icon(Icons.download_rounded, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            const Text("Speech Analysis", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildSpeechTile("Vocal Jitter", "Micro-tremor frequency", "0.42%", "OPTIMAL", Colors.blueAccent),
            const SizedBox(height: 12),
            _buildSpeechTile("Speech Pace", "142 words/min", "-2.1%", "SLIGHT DELAY", Colors.orangeAccent),
            const SizedBox(height: 12),
            _buildSpeechTile("Articulation", "Phonetic precision", "96%", "HIGH", Colors.purpleAccent),
            
            const SizedBox(height: 48),
            const Center(
              child: Text(
                "POWERED BY GEMINI 3 NEURO-SYNC CORE",
                style: TextStyle(color: Colors.white12, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ZahraColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 14),
              Text(label, style: const TextStyle(color: ZahraColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechTile(String title, String sub, String val, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZahraColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.waves_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub, style: const TextStyle(color: ZahraColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              Text(status, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ZahraColors.mintGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.7, size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.9, size.height * 0.2);

    // Draw shadow
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ZahraColors.mintGreen.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final shadowPath = Path.from(path);
    shadowPath.lineTo(size.width * 0.9, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);

    canvas.drawPath(path, paint);
    
    // Last point
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.2), 6, Paint()..color = ZahraColors.mintGreen);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.2), 12, Paint()..color = ZahraColors.mintGreen.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
