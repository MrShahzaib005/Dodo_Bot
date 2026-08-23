import 'dart:async'; // REQUIRED for the Timer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ros_view_model.dart';

class CruiseModeScreen extends StatefulWidget {
  const CruiseModeScreen({super.key});

  @override
  State<CruiseModeScreen> createState() => _CruiseModeScreenState();
}

class _CruiseModeScreenState extends State<CruiseModeScreen> {
  Timer? _commandTimer; // The heartbeat timer

  @override
  void dispose() {
    _commandTimer?.cancel(); // Safety: Kill timer if we leave the screen
    super.dispose();
  }

  // Helper to start sending commands repeatedly
  void _startMoving(RosViewModel ros, double linear, double angular) {
    // 1. Send the first command immediately
    ros.move(linear, angular);
    
    // 2. Cancel any existing timer just in case
    _commandTimer?.cancel();

    // 3. Start a timer that sends the command every 100ms (10Hz)
    _commandTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      ros.move(linear, angular);
    });
  }

  // Helper to stop everything
  void _stopMoving(RosViewModel ros) {
    _commandTimer?.cancel();
    ros.stop();
  }

  @override
  Widget build(BuildContext context) {
    final ros = Provider.of<RosViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Manual Control")),
      // SingleChildScrollView fixes the "Yellow Bar" overflow error
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ros.isConnected ? "CONNECTED TO ROBOT" : "DISCONNECTED",
                  style: TextStyle(
                    color: ros.isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),

                // FORWARD (Speed 0.4 m/s)
                _buildArrowBtn(Icons.arrow_upward, "FORWARD", 
                  () => _startMoving(ros, 0.4, 0.0), // On Press
                  () => _stopMoving(ros)             // On Release
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LEFT (Rotate 0.8 rad/s)
                    _buildArrowBtn(Icons.arrow_back, "LEFT", 
                      () => _startMoving(ros, 0.0, 0.8), 
                      () => _stopMoving(ros)
                    ),
                    
                    const SizedBox(width: 30),
                    
                    // EMERGENCY STOP (Big Red Button)
                    GestureDetector(
                      onTap: () => _stopMoving(ros),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)]
                        ),
                        child: const Icon(Icons.stop, color: Colors.white, size: 40),
                      ),
                    ),
                    
                    const SizedBox(width: 30),
                    
                    // RIGHT (Rotate -0.8 rad/s)
                    _buildArrowBtn(Icons.arrow_forward, "RIGHT", 
                      () => _startMoving(ros, 0.0, -0.8), 
                      () => _stopMoving(ros)
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // BACKWARD (Speed -0.4 m/s)
                _buildArrowBtn(Icons.arrow_downward, "BACK", 
                  () => _startMoving(ros, -0.4, 0.0), 
                  () => _stopMoving(ros)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArrowBtn(IconData icon, String label, VoidCallback onDown, VoidCallback onUp) {
    return GestureDetector(
      // The Critical Logic:
      onTapDown: (_) => onDown(),      // Start the timer when finger touches
      onTapUp: (_) => onUp(),          // Stop timer when finger lifts
      onTapCancel: () => onUp(),       // Stop timer if finger slides off
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Icon(icon, size: 40, color: Colors.blue[800]),
      ),
    );
  }
}