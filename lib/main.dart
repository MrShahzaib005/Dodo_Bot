import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'viewmodels/ros_view_model.dart';
import 'views/home_screen.dart';
import 'widgets/session_guard.dart'; // Import the guard

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RosViewModel()),
      ],
      child: const DodoBotApp(),
    ),
  );
}

class DodoBotApp extends StatelessWidget {
  const DodoBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DODO Bot Controller',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        primaryColor: const Color(0xFF007AFF),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // WRAP THE HOME SCREEN IN THE SESSION GUARD
      home: const SessionGuard(
        timeout: Duration(seconds: 10000), // Set idle time (e.g., 30 seconds for testing)
        child: HomeScreen(),
      ),
      // Define routes if needed for deep linking
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}