import 'package:deligo_app/ui/dashboard.dart';
import 'package:deligo_app/ui/landing.dart';
import 'package:deligo_app/ui/settings.dart';
import 'package:flutter/material.dart';
import './ui/components/splash_screen.dart';

// import 'landing.dart';
// import 'dashboard.dart';

void main() {
  runApp(const DeligoApp());
}

class DeligoApp extends StatelessWidget {
  const DeligoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deligo Robot',
      debugShowCheckedModeBanner: false,//removes the top banner
      theme: ThemeData(
        useMaterial3: true, // ✅ Enables Material 3 styling
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 7, 165, 189)),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),

      // initial page
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _buildPageRoute(const LandingPage());
          case '/dashboard':
            return _buildPageRoute(const DashboardPage());
          default:
            return _buildPageRoute(const LandingPage());
        }
      },
      routes: {
        '/': (context) => const SplashScreen(),
        '/landing': (context) => const LandingPage(),
        '/screensaver': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardPage(),
        '/settings': (context) => const SettingsPage(),
        '/mapping': (context) => const MappingPage(),
        '/music': (context) => const MusicPage(),
        '/status': (context) => const StatusPage(),
      },
    );
  }

  /// Custom fade + slide transition
  PageRouteBuilder _buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween(begin: const Offset(0.1, 0), end: Offset.zero)
            .animate(animation);
        final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: child),
        );
      },
    );
  }
}




