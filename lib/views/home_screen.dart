import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_menu.dart';
import 'delivery_mode.dart';
import 'cruise_mode.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Default view is Delivery Mode
  Widget _currentView = const DeliveryModeContent();
  String _currentTitle = "Delivery mode";

  void _handleMenuSelection(String mode) {
    setState(() {
      _currentTitle = mode;
      switch (mode) {
        case "Delivery mode":
          _currentView = const DeliveryModeContent();
          break;

        case "Cruise mode":
          // For Cruise mode, we still generally want the full controller logic,
          // but you CAN embed it if you refactor CruiseModeScreen similarly.
          // For now, let's keep it consistent:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CruiseModeScreen()));
          _currentTitle = "Cruise mode"; // Reset when coming back
          break;

        case "Setting":
          // CHANGED: No more Navigator.push!
          // We now swap the view IN PLACE.
          _currentView = const SettingsContent();
          // _currentTitle = "Settings mode";
          break;

        // case "Map Setup":
        //    // If you want Map Setup to be persistent too:
        //    _currentView = const MapSetupScreen(); // (You'd need to refactor MapSetupScreen to remove Scaffold too)
        //    break;

        default:
          _currentView = Center(child: Text("$mode coming soon"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Stack(
        children: [
          // 1. THE MAIN CONTENT (Background)
          // We wrap it in a SafeArea to respect notches
          SafeArea(
            child: Column(
              children: [
                // Top Header Area (Invisible but takes space)
                const SizedBox(height: 65),
                Expanded(child: _currentView),
              ],
            ),
          ),

          // 2. THE FLOATING HEADER (Menu Button + Title)
  

          Positioned(
            top: 25, // Distance from top of screen (adjust for status bar)
            left: 0, // Distance from left (0 means sticking to the edge)
            child: Row(
              children: [
                // 1. THE MENU BUTTON
                GestureDetector(
                  onTap: () {

                    showDialog(
                      context: context,
                      builder: (ctx) => GlassMenu(onModeSelected: _handleMenuSelection),
                    );
                  },
                  child: Container(
                    width: 60, // Width of the blue tab
                    height: 50, // Height of the blue tab
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF), // Pudu Blue
                      // This creates the "Tab" shape (Flat left, Rounded right)
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(12),
                      ),
                      // Subtle shadow to make it pop
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(4, 4),
                        )
                      ],
                    ),
                    child:
                        const Icon(Icons.menu, color: Colors.white, size: 28),
                  ),
                ),

                const SizedBox(width: 10), // Gap between button and text

                // 2. THE STATUS LABEL (Optional)
        
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 92, 90, 90), // or Colors.grey[800] for dark mode
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Text(
                    _currentTitle, // Replace with your variable
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(221, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
