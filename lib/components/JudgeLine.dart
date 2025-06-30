import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../page/InGame.dart';

class JudgeLine extends PositionComponent with HasGameReference<InGame> {

  @override
  Future<void> onLoad() async {
    size = Vector2(500, 20);
  }

  JudgeLine() : super(priority: 200);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(size.toRect(), paint);
  }
}