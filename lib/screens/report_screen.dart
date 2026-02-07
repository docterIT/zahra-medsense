import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/glass_card.dart';

class ReportScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ReportScreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final int score = reportData['score'] ?? 0;
    final String summary = reportData['summary'] ?? "No data available.";
    final double hz = (reportData['hz'] ?? 0.0).toDouble();

    // Determine status color based on clinical score
    Color statusColor = ZahraColors.healingTeal;
    String statusText = "NORMAL / LOW RISK";
    if (score >= 3) {
      statusColor = Colors.red;
      statusText = "HIGH RISK / URGENT";
    } else if (score >= 1) {
      statusColor = Colors.orange;
      statusText = "MODERATE RISK";
    }

    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Analysis Report"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Clinical Results",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Z.A.H.R.A Multimodal Analysis",
              style: TextStyle(color: ZahraColors.electricBlue, letterSpacing: 1.2),
            ),
            const SizedBox(height: 32),
            
            // Status Card
            GlassCard(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric("UPDRS Score", "$score/4"),
                      _buildMetric("Frequency", "${hz.toStringAsFixed(1)} Hz"),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              "AI Clinical Summary",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            GlassCard(
              child: Text(
                summary,
                style: const TextStyle(height: 1.6, color: Colors.white70),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ZahraColors.electricBlue,
                  shape: RoundedCornerShape(16),
                ),
                child: const Text(
                  "BACK TO DASHBOARD",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "Disclaimer: This is as screening tool. Consult a doctor for diagnosis.",
                style: TextStyle(color: Colors.white38, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: ZahraColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}

class RoundedCornerShape extends RoundedRectangleBorder {
  RoundedCornerShape(double radius) : super(borderRadius: BorderRadius.circular(radius));
}
