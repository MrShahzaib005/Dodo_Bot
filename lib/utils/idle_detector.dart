import 'dart:async';
import 'package:flutter/material.dart';

class IdleDetector extends StatefulWidget {
  final Widget child;
  final Duration idleDuration;
  final VoidCallback onIdle;

  const IdleDetector({
    super.key,
    required this.child,
    required this.onIdle,
    this.idleDuration = const Duration(seconds: 15),
  });

  @override
  State<IdleDetector> createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector> {
  Timer? _timer;

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(widget.idleDuration, widget.onIdle);
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
