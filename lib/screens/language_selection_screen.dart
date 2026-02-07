import 'package:flutter/material.dart';
import '../components/colors.dart';
import 'dashboard_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLang = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Brand Icon
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: ZahraColors.mintGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: ZahraColors.mintGreen.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: ZahraColors.mintGreen.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: const Icon(
                Icons.psychology_outlined,
                color: ZahraColors.mintGreen,
                size: 80,
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              "Zahra MedSense",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "ZENITH AI FOR HEALTH & RECOVERY\nANALYSIS",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZahraColors.mintGreen,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "AI-powered Neuro-Sync screening for\nParkinson's and Stroke detection.",
              textAlign: TextAlign.center,
              style: TextStyle(color: ZahraColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_outlined, size: 14, color: Colors.white24),
                const SizedBox(width: 4),
                const Text("Powered by Gemini 3 Analysis", style: TextStyle(color: Colors.white24, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Text(
              "SELECT LANGUAGE",
              style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 16),
            // Language Buttons
            Row(
              children: [
                Expanded(
                  child: _buildLangOption("English", "en", Icons.language),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLangOption("Indonesian", "id", null),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Start Button
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen(locale: _selectedLang)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ZahraColors.mintGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Get Started", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "V 2.0.4 • CLINICAL GRADE AI",
              style: TextStyle(color: Colors.white12, fontSize: 10),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(String label, String code, IconData? icon) {
    bool isSelected = _selectedLang == code;
    return GestureDetector(
      onTap: () => setState(() => _selectedLang = code),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? ZahraColors.mintGreen : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.white12),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: isSelected ? Colors.black : Colors.white70, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
