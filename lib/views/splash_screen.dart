import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/robot_intro.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  void _wakeUp() {
    _controller.pause();
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Go back to the app
    } else {
      // Fallback if it was the first screen
      Navigator.pushReplacementNamed(context, '/home'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _wakeUp, // Tap anywhere to wake up
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover, // Make video fill the screen
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : const CircularProgressIndicator(color: Colors.blue),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}