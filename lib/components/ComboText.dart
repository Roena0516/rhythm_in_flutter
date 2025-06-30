import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../page/InGame.dart';

class ComboText extends TextComponent with HasGameReference<InGame> {
  ComboText()
      : super(
    text: '',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 48,
      ),
    ),
    priority: 400
  );


  @override
  Future<void> onLoad() async {
    size = Vector2(100, 50);
    position = Vector2(game.size.x / 2, 160);
    anchor = Anchor.center;
  }
}