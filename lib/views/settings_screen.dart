import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  int _selectedIndex = 0;
  
  double _musicVolume = 0.5;
  double _voiceVolume = 0.7;
  double _interactionVolume = 0.3;
  String _selectedLanguage = "English";

  final List<String> _menuItems = [
    "Basic Settings", "WLAN", "Map Settings", "Volume Settings",
    "Voice Settings", "Speed Settings", "Tray Settings",
  ];

  final List<IconData> _menuIcons = [
    FontAwesomeIcons.gear, FontAwesomeIcons.wifi, FontAwesomeIcons.map,
    FontAwesomeIcons.volumeHigh, FontAwesomeIcons.microphone, 
    FontAwesomeIcons.gaugeHigh, FontAwesomeIcons.layerGroup,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F4F8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------
          // LEFT SIDEBAR (Compact)
          // --------------------------
          SizedBox( // Fixed width is safer for compact layouts than Flex
            width: 200, 
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                // MINIMUM PADDING: Just enough to clear the 50px button + 16px margin
                padding: const EdgeInsets.only(top: 5, bottom: 5), 
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      // Very tight margins
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0), 
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8), 
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(5), // Left Menu blue border
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _menuIcons[index],
                            color: isSelected ? Colors.white : Colors.grey[600],
                            size: 14, // Tiny Icon
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _menuItems[index],
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.grey[800],
                                fontSize: 13, // Tiny Text
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // --------------------------
          // RIGHT CONTENT (Expanded)
          // --------------------------
          Expanded(
            child: Container(
              // No top padding needed because the Title Label is gone!
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title (Smaller)
                  Text(
                    _menuItems[_selectedIndex],
                    style: GoogleFonts.poppins(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(height: 10),
                  
                  // Content Scrollable to avoid Overflow
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildRightContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPACT BUILDERS ---

  Widget _buildRightContent() {
    switch (_selectedIndex) {
      case 0: return _buildBasicSettings();
      case 3: return _buildVolumeSettings();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_menuIcons[_selectedIndex], size: 40, color: Colors.grey[300]),
              const SizedBox(height: 10),
              Text(_menuItems[_selectedIndex], style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            ],
          ),
        );
    }
  }

  Widget _buildVolumeSettings() {
    return Column(
      children: [
        _buildSliderTile("Music volume", FontAwesomeIcons.music, _musicVolume, (v) => setState(() => _musicVolume = v)),
        const SizedBox(height: 10),
        _buildSliderTile("Language volume", FontAwesomeIcons.microphoneLines, _voiceVolume, (v) => setState(() => _voiceVolume = v)),
        const SizedBox(height: 10),
        _buildSliderTile("Button volume", FontAwesomeIcons.handPointer, _interactionVolume, (v) => setState(() => _interactionVolume = v)),
      ],
    );
  }

  Widget _buildBasicSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Multilingual settings", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              _buildLanguageItem("English"),
              const Divider(height: 1, indent: 10, endIndent: 10),
              _buildLanguageItem("中文"),
              const Divider(height: 1, indent: 10, endIndent: 10),
              _buildLanguageItem("한국어"),
            ],
          ),
        )
      ],
    );
  }

  // --- COMPACT WIDGETS ---

  Widget _buildSliderTile(String title, IconData icon, double value, Function(double) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Reduced height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 4), // Tighter
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF007AFF),
                    inactiveTrackColor: Colors.grey[200],
                    thumbColor: Colors.white,
                    trackHeight: 3.0, // Thinner
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0, elevation: 1), // Smaller thumb
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0), // Smaller touch area
                  ),
                  child: Slider(value: value, onChanged: onChanged),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String lang) {
    return ListTile(
      dense: true, // Forces compact height
      visualDensity: VisualDensity.compact, // Removes extra vertical padding
      title: Text(lang, style: const TextStyle(fontSize: 14)),
      trailing: _selectedLanguage == lang ? const Icon(Icons.check, color: Colors.blue, size: 18) : null,
      onTap: () => setState(() => _selectedLanguage = lang),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }
}