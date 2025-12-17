import 'package:flutter/material.dart';

class RobotMascot extends StatelessWidget {
  final String imagePath;
  final double height;
  final double opacity;
  final Alignment alignment;

  const RobotMascot({
    Key? key,
    this.imagePath = "assets/images/robot.png",
    this.height = 300,
    this.opacity = 0.8,
    this.alignment = Alignment.bottomLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          imagePath,
          height: height,
        ),
      ),
    );
  }
}
