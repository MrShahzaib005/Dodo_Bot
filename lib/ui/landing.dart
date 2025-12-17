import 'package:flutter/material.dart';
import '../../utils/idle_detector.dart'; // 👈 import the helper

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  void _goToScreensaver(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/screensaver');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IdleDetector(
      idleDuration: const Duration(seconds: 45),
      onIdle: () => _goToScreensaver(context),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Robot mascot image
                Image.asset(
                  "assets/images/robot.png",
                  height: size.height * 0.35,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                // Title
                Text(
                  "Welcome to Deligo",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 40),

                // Navigation buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildNavButton(context, "Dashboard", "/dashboard"),
                    _buildNavButton(context, "Mapping", "/mapping"),
                    _buildNavButton(context, "Music", "/music"),
                    _buildNavButton(context, "Status", "/status"),
                    _buildNavButton(context, "Settings", "/settings"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
