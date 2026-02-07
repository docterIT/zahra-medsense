import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/glass_card.dart';
import '../l10n/locales.dart';
import 'camera_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String locale;

  const DashboardScreen({super.key, this.locale = 'en'});

  @override
  Widget build(BuildContext context) {
    final strings = zahraLocales[locale]!;

    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      body: Stack(
        children: [
          // Background Aesthetic Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ZahraColors.electricBlue.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ZahraColors.healingTeal.withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings['app_name']!,
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                  ),
                                ),
                                Text(
                                  strings['tagline']!,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ZahraColors.electricBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person_outline, color: Colors.white70),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        _buildSectionHeader(context, strings['dashboard_title']!),
                        const SizedBox(height: 16),
                        
                        // Parkinson's Card
                        _buildMenuCard(
                          context,
                          title: strings['parkinson_test']!,
                          subtitle: "Video Movement Analysis",
                          icon: Icons.motion_photos_on_rounded,
                          color: ZahraColors.electricBlue,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CameraScreen()),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Stroke Card
                        _buildMenuCard(
                          context,
                          title: strings['stroke_test']!,
                          subtitle: "Acoustic Biomarker Test",
                          icon: Icons.graphic_eq_rounded,
                          color: ZahraColors.healingTeal,
                          onTap: () {
                            // Stroke logic placeholder
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        _buildSectionHeader(context, "RECENT ACTIVITY"),
                        const SizedBox(height: 16),
                        
                        GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Last Checkup Complete", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Risk Level: Minimal", style: TextStyle(color: ZahraColors.textSecondary, fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Text("2d ago", style: TextStyle(color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ZahraColors.textSecondary,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: ZahraColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }
}
