import 'dart:async';
import 'package:flutter/material.dart';
import '../views/splash_screen.dart'; // Make sure this import points to your file

class SessionGuard extends StatefulWidget {
  final Widget child;
  final Duration timeout;

  const SessionGuard({
    super.key,
    required this.child,
    this.timeout = const Duration(seconds: 10000), // Default 1 minute
  });

  @override
  State<SessionGuard> createState() => _SessionGuardState();
}

class _SessionGuardState extends State<SessionGuard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.timeout, _navigateToScreensaver);
  }

  void _resetTimer() {
    _startTimer();
  }

  void _navigateToScreensaver() {
    // Only navigate if we aren't ALREADY there
    // We check if the top route is the SplashScreen to avoid stacking
    // Note: This is a simple check. For production, use a named route check.
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    ).then((_) {
      // When the screensaver pops (user taps it), restart the timer
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the entire app in a Listener to catch touches anywhere
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      onPointerUp: (_) => _resetTimer(),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}