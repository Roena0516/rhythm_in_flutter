import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../page/InGame.dart';

class Lane extends PositionComponent with HasGameReference<InGame>, TapCallbacks, DragCallbacks {
  int laneNum = 1;
  Vector2? startPosition;
  dynamic noteGenerator;
  dynamic judgementManager;

  Color color = Color(0x40FFFFFF);

  Lane() : super(priority: 100);

  @override
  Future<void> onLoad() async {
    size = Vector2(125, 1000);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawRect(size.toRect(), paint);
  }

  void setColor(Color newColor) {
    color = newColor;
  }
}