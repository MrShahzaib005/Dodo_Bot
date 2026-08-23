import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MapPainter extends CustomPainter {
  final ui.Image? mapImage;

  MapPainter({required this.mapImage});

  @override
  void paint(Canvas canvas, Size size) {
    if (mapImage == null) return;

    final paint = Paint();
    
    // Draw the image scaled to fit the screen
    // For now, we just stretch to fill or fitWidth. 
    // In a real app, you want an InteractiveViewer (Pan/Zoom).
    
    final src = Rect.fromLTWH(0, 0, mapImage!.width.toDouble(), mapImage!.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Use fitWidth logic to keep aspect ratio
    // (This is a naive implementation, better to use InteractiveViewer parent)
    canvas.drawImageRect(mapImage!, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.mapImage != mapImage;
  }
}