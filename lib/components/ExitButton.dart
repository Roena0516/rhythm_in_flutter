import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ExitButton extends TextComponent with TapCallbacks {
  final VoidCallback onExit;

  ExitButton({required this.onExit})
      : super(
    text: 'Exit',
    position: Vector2(100, 100),
  );

  @override
  void onTapDown(TapDownEvent event) {
    onExit();
  }
}