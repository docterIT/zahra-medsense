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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: ZahraColors.deepSpace,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings['app_name']!,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  strings['tagline']!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ZahraColors.electricBlue,
                      ),
                ),
                const SizedBox(height: 48),
                Text(
                  strings['dashboard_title']!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ZahraColors.textSecondary,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CameraScreen()),
                    );
                  },
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              strings['parkinson_test']!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Icon(Icons.show_chart, color: ZahraColors.electricBlue),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${strings['last_analysis']} 2 days ago",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ZahraColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            strings['stroke_test']!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Icon(Icons.mic, color: ZahraColors.healingTeal),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings['start_recording']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ZahraColors.healingTeal,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
