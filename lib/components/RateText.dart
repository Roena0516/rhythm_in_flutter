import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../page/InGame.dart';

class RateText extends TextComponent with HasGameReference<InGame> {
  RateText()
      : super(
    text: '100.00%',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 28,
      ),
    ),
    priority: 400
  );


  @override
  Future<void> onLoad() async {
    size = Vector2(100, 50);
    position = Vector2(game.size.x / 2 + 300, 400);
    anchor = Anchor.center;
  }
}