import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width > 600 ? 2.8 : 2.2; // responsive

    return Scaffold(
      body: Row(
        children: [
          // Left Robot (same everywhere for now)
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/robot.png",
                height: size.height * 0.35,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Right Content (Dashboard Grid)
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5)),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Dashboard",
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 20),
                      Text(
                        "Choose an option below to control your robot:",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Button Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: aspectRatio,
                        children: [
                          _dashboardButton(context, "Modes", Icons.settings,
                              page: const ModesPage()),
                          _dashboardButton(context, "Mapping", Icons.map,
                              page: const MappingPage()),
                          _dashboardButton(context, "Music", Icons.music_note,
                              page: const MusicPage()),
                          _dashboardButton(context, "Settings", Icons.tune,
                              page: const PlaceholderSettingsPage()),
                          _dashboardButton(context, "Logs", Icons.list_alt,
                              page: const LogsPage()),
                          _dashboardButton(context, "Back", Icons.arrow_back,
                              page: const PlaceholderLanding()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardButton(BuildContext context, String label, IconData icon,
      {Widget? page}) {
    return ElevatedButton.icon(
      onPressed: () {
        if (page != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        }
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA0BFC4), // Misty Aqua
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

/// --- Placeholder pages ---
class ModesPage extends StatelessWidget {
  const ModesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _placeholder(context, "Modes Page");
  }
}

class MappingPage extends StatelessWidget {
  const MappingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _placeholder(context, "Mapping Page");
  }
}

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _placeholder(context, "Music Page");
  }
}

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _placeholder(context, "Music Page");
  }
}

class PlaceholderSettingsPage extends StatelessWidget {
  const PlaceholderSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _placeholder(context, "Settings Placeholder (remove later)");
  }
}

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _placeholder(context, "Logs Page");
  }
}

class PlaceholderLanding extends StatelessWidget {
  const PlaceholderLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return _placeholder(context, "Landing Page Placeholder (replace later)");
  }
}

/// --- Helper function for placeholder screens ---
Widget _placeholder(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
