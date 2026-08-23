import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassMenu extends StatelessWidget {
  final Function(String) onModeSelected;

  const GlassMenu({super.key, required this.onModeSelected});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur background
      child: Dialog(
        backgroundColor: Colors.white.withOpacity(0.9), // Translucent white
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.2,
                  children: [
                    _buildMenuItem(context, "Delivery mode", FontAwesomeIcons.bellConcierge, Colors.blue),
                    _buildMenuItem(context, "Cruise mode", FontAwesomeIcons.arrowsSpin, Colors.blue),
                    _buildMenuItem(context, "Direct delivery", FontAwesomeIcons.locationArrow, Colors.blue),
                    _buildMenuItem(context, "Special mode", FontAwesomeIcons.star, Colors.blue),
                    _buildMenuItem(context, "Return", FontAwesomeIcons.locationCrosshairs, Colors.blue),
                    _buildMenuItem(context, "Birthday mode", FontAwesomeIcons.cakeCandles, Colors.blue),
                    _buildMenuItem(context, "Music", FontAwesomeIcons.music, Colors.blue),
                    _buildMenuItem(context, "Setting", FontAwesomeIcons.gear, Colors.grey[700]!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close the popup
        onModeSelected(title); // Tell parent what was picked
      },
      borderRadius: BorderRadius.circular(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}