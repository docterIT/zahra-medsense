import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/glass_card.dart';
import 'camera_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String locale;

  const DashboardScreen({super.key, this.locale = 'en'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZahraColors.deepSpace,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Zahra'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Welcome back,", style: TextStyle(color: ZahraColors.textSecondary, fontSize: 12)),
                          const Text("Zahra MedSense", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.white70)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white70)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),
              
              // Status Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ZahraColors.darkCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Stable Status", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text("Neuro-Sync analysis complete", style: TextStyle(color: ZahraColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: ZahraColors.mintGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("OPTIMAL", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("88", style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, height: 1)),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text("/100", style: TextStyle(color: ZahraColors.textSecondary, fontSize: 18)),
                        ),
                        const Spacer(),
                        _buildMiniGraph(),
                      ],
                    ),
                    const Text("Neuro-Health Score", style: TextStyle(color: ZahraColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Upcoming Appointment
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ZahraColors.darkCard.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.calendar_today_rounded, color: Colors.blueAccent, size: 20),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upcoming Appointment", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Dr. Aris (Neurology) • Tomorrow, 10:00 AM", style: TextStyle(color: ZahraColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white24),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              const Text("Daily Routine", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // New Screening Card
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen()));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ZahraColors.mintGreen, ZahraColors.mintGreen.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10, bottom: -10,
                        child: Icon(Icons.biotech, color: Colors.black.withOpacity(0.05), size: 100),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Start New Screening", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          const SizedBox(
                            width: 200,
                            child: Text("Quick 2-minute AI assessment with Gemini 3 analysis.", style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Start Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildInfoCard("Latest Report", "View detailed metrics\nfrom Feb 12", Icons.description_outlined, Colors.orangeAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInfoCard("Exercises", "Hand-eye\ncoordination tasks", Icons.fitness_center_rounded, Colors.purpleAccent)),
                ],
              ),
              const SizedBox(height: 40),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Vital Markers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text("VIEW HISTORY", style: TextStyle(color: ZahraColors.mintGreen, fontSize: 12, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 16),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.6,
                children: [
                  _buildVitalBox("TREMORS", "Low Impact", Icons.vibration_rounded),
                  _buildVitalBox("COGNITIVE", "94% Response", Icons.psychology_outlined),
                  _buildVitalBox("SLEEP", "7h 20m", Icons.nights_stay_outlined),
                  _buildVitalBox("GAIT SPEED", "1.2 m/s", Icons.directions_walk_rounded),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniGraph() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        double height = [15, 25, 30, 40, 25][index].toDouble();
        return Container(
          margin: const EdgeInsets.only(left: 4),
          width: 8,
          height: height,
          decoration: BoxDecoration(
            color: index == 3 ? ZahraColors.mintGreen : ZahraColors.mintGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(String title, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: ZahraColors.darkCard, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(color: ZahraColors.textSecondary, fontSize: 12, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildVitalBox(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZahraColors.darkCard.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ZahraColors.mintGreen, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: ZahraColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ],
          ),
          const Spacer(),
          Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: ZahraColors.deepSpace,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, "Home", true),
          _navItem(Icons.bar_chart_rounded, "Trends", false),
          _navItem(Icons.waves_rounded, "Insights", false),
          _navItem(Icons.person_rounded, "Profile", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? ZahraColors.mintGreen : ZahraColors.textSecondary),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? ZahraColors.mintGreen : ZahraColors.textSecondary, fontSize: 11, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
