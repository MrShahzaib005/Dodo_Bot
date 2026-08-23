import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryModeContent extends StatefulWidget {
  const DeliveryModeContent({super.key});

  @override
  State<DeliveryModeContent> createState() => _DeliveryModeContentState();
}

class _DeliveryModeContentState extends State<DeliveryModeContent> {
  // --- STATE VARIABLES ---
  // Stores the table number assigned to each tray (null = empty)
  String? _tray1Table;
  String? _tray2Table;
  String? _tray3Table;

  // Tracks which tray is currently selected (1, 2, or 3)
  int? _selectedTrayIndex;

  // --- LOGIC: SELECT TRAY ---
  void _selectTray(int index) {
    setState(() {
      // Toggle selection: If clicking the same one, deselect it.
      _selectedTrayIndex = (_selectedTrayIndex == index) ? null : index;
    });
  }

  void _assignTable(String number) {
    if (_selectedTrayIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a tray first!"), 
          duration: Duration(milliseconds: 500)
        ),
      );
      return;
    }
    
    setState(() {
      if (_selectedTrayIndex == 1) _tray1Table = number;
      if (_selectedTrayIndex == 2) _tray2Table = number;
      if (_selectedTrayIndex == 3) _tray3Table = number;
    });
  }

  // --- LOGIC: CLEAR TRAY ---
  void _clearTray(int index) {
    setState(() {
      if (index == 1) _tray1Table = null;
      if (index == 2) _tray2Table = null;
      if (index == 3) _tray3Table = null;
    });
  }

  // (Table assignment logic will go here later when we build the right side)

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ====================================================
        // LEFT SIDE: THE ROBOT (30% Width)
        // ====================================================
        Expanded(
          flex: 3, // Takes 30% of the screen width
          child: Container(
            // Padding: Left 80px ensures the Robot doesn't hide behind the floating Menu Button
            padding: const EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 20),
            
            child: FittedBox(
              fit: BoxFit.contain, // Forces the robot to scale perfectly without overflowing
              alignment: Alignment.center,
              child: SizedBox(
                width: 260, // Fixed design width
                height: 580, // Fixed design height
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. ROBOT BODY SHELL
                    Container(
                      width: 259,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 230, 223, 223), // Dark Grey Body
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: const Color.fromARGB(255, 34, 33, 33), width: 4),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(5, 5))
                        ],
                      ),
                      child: Column(
                        children: [
                          // 2. ROBOT HEAD (Sensors)
                          Container(
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Left Sensor LED
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                                const SizedBox(width: 15),
                                // Center Sensor Strip
                                Container(width: 50, height: 6, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(3))),
                                const SizedBox(width: 15),
                                // Right Sensor LED
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                              ],
                            ),
                          ),
                          
                          const Spacer(), // Pushes trays to the middle
                          
                          // 3. TRAY SLOTS
                          _buildTraySlot(1, _tray1Table),
                          const SizedBox(height: 20),
                          _buildTraySlot(2, _tray2Table),
                          const SizedBox(height: 20),
                          _buildTraySlot(3, _tray3Table),
                          
                          const Spacer(flex: 2), // Pushes base to the bottom
                          
                          // 4. ROBOT BASE
                          Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.emergency_share, color: Colors.blue[900], size: 24),
                          ),
                        ],
                      ),
                    ),
                    
                    // 5. CLEAR BUTTONS (Floating X circles)
                    // These only appear if a table is assigned to that tray
                    if (_tray1Table != null) Positioned(right: 0, top: 175, child: _buildClearButton(1)),
                    if (_tray2Table != null) Positioned(right: 0, top: 275, child: _buildClearButton(2)),
                    if (_tray3Table != null) Positioned(right: 0, top: 375, child: _buildClearButton(3)),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ====================================================
        // RIGHT SIDE: PLACEHOLDER (70% Width)
        // ====================================================
        // ====================================================
        // RIGHT SIDE: CONTROL PANEL (70% Width)
        // ====================================================
        Expanded(
          flex: 7, // <--- KNOB: SCREEN WIDTH RATIO (7 = 70%)
          child: Container(
            // <--- KNOB: MARGINS AROUND THE GLASS CARD
            // Increase 'left' to push it away from robot. Increase 'right' to pull from edge.
            margin: const EdgeInsets.fromLTRB(10, 20, 20, 20), 
            
            // <--- KNOB: INTERNAL PADDING
            padding: const EdgeInsets.all(15), 
            
            decoration: BoxDecoration(
              // <--- KNOB: CARD COLOR & OPACITY (Glass Effect)
              color: const Color.fromARGB(255, 217, 214, 214).withOpacity(0.90), 
              borderRadius: BorderRadius.circular(20), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Subtle shadow
                  blurRadius: 15, 
                  offset: const Offset(0, 5)
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. HEADER TEXT
                Text(
                  _selectedTrayIndex == null 
                      ? "Select a tray" 
                      : "Assigning Table for Tray $_selectedTrayIndex...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18, // <--- KNOB: TEXT SIZE
                    fontWeight: FontWeight.w600, 
                    color: const Color.fromARGB(255, 50, 49, 49)
                  ),
                ),
                
                const SizedBox(height: 15), // Spacer

                // 2. TABLE SELECTION GRID
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // <--- KNOB: COLUMNS (Change to 5 for smaller buttons)
                      childAspectRatio: 2, // <--- KNOB: BUTTON SHAPE (Higher = Flatter/Wider)
                      crossAxisSpacing: 15, // <--- KNOB: GAP BETWEEN BUTTONS (Horizontal)
                      mainAxisSpacing: 15,  // <--- KNOB: GAP BETWEEN BUTTONS (Vertical)
                    ),
                    itemCount: 8, // <--- KNOB: TOTAL TABLES (Change to 20 if needed)
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100], // Button BG
                          foregroundColor: Colors.black87, // Text Color
                          elevation: 0, // Flat look
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _assignTable("${index + 1}"),
                        child: Text(
                          "${index + 1}", 
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10), // Spacer before Start button

                // 3. START BUTTON
                SizedBox(
                  height: 50, // <--- KNOB: START BUTTON HEIGHT
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF), // Pudu Blue
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4, // Slight pop
                      shadowColor: Colors.blue.withOpacity(0.4),
                    ),
                    onPressed: () {
                      // START ACTION
                      print("Starting Delivery: $_tray1Table, $_tray2Table, $_tray3Table");
                    },
                    child: Text(
                      "Start!", 
                      style: GoogleFonts.poppins(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- HELPER: TRAY SLOT STYLING ---
  Widget _buildTraySlot(int index, String? assignedTable) {
    bool isSelected = _selectedTrayIndex == index;
    bool hasValue = assignedTable != null;

    return GestureDetector(
      onTap: () => _selectTray(index),
      child: Container(
        width: 220, 
        height: 70, 
        decoration: BoxDecoration(
          // LOGIC FROM REFERENCE IMAGE:
          // 1. Selected? -> Bright Blue (#007AFF)
          // 2. Has Table? -> White
          // 3. Empty? -> Dark Grey (#4A4A4A) to blend with body
          color: isSelected 
              ? const Color(0xFF007AFF) 
              : (hasValue ? Colors.white : const Color(0xFF4A4A4A)),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          assignedTable ?? "", // Show table number or empty string
          style: GoogleFonts.poppins(
            fontSize: 32, 
            fontWeight: FontWeight.bold,
            // Text Color: White on Blue, Black on White
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // --- HELPER: CLEAR BUTTON ---
  Widget _buildClearButton(int index) {
    return GestureDetector(
      onTap: () => _clearTray(index),
      child: Container(
        width: 36, 
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[800], // Dark circle
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2), // White ring
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)]
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}