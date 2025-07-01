import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../loadChart.dart';
import '../page/InGame.dart';

class Note extends PositionComponent with HasGameReference<InGame> {
  late dynamic myGame;
  final double speed;
  final NoteClass note;
  final double ms;
  final int lanePosition;
  final double fallTime;

  final double startY = -350;
  double endY = 500;

  final double Function() getCurrentTime;
  double getLaneX(int lane) => (lane - 1) * 125.0 - 125.0;

  Note({
    required this.note,
    required this.lanePosition,
    required this.ms,
    required this.fallTime,
    required this.speed,
    required this.getCurrentTime,
  }) : super(priority: 300);

  @override
  Future<void> onLoad() async {
    size = Vector2(125, 20);
    myGame = game as InGame;

    endY = game.size.y;

    final double baseX = (game.size.x - size.x) / 2 + getLaneX(note.position);
    final double baseY = -700;
    position = Vector2(baseX, baseY);

    print("fallTime: $fallTime");
    print("dropStartTime: ${ms - fallTime}");
  }

  @override
  void update(double dt) {
    final currentTime = getCurrentTime();
    final dropStartTime = (ms - fallTime);

    final elapsed = currentTime - dropStartTime;

    final progress = (elapsed * speed) / (endY - startY);
    final clamped = progress.clamp(0.0, 1.0);
    position = Vector2(position.x, startY + (endY - startY) * clamped + 200);

    if (note.type == "hold" && note.isInputed && currentTime - ms > 0 && myGame.isStarted) {
      myGame.judgementManager.performAction(note, 'PerfectP');
      removeFromParent();
    }

    if (!note.isInputed && currentTime - ms > 200 && myGame.isStarted) {
      myGame.judgementManager.performAction(note, 'Miss');
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Paint paint = Paint()..color = Colors.white;;
    if (note.type == "hold") {
      paint = Paint()..color = Colors.yellow;
      size = Vector2(125, 10);
    }
    if (note.type == "up") {
      paint = Paint()..color = Colors.blueAccent;
    }
    canvas.drawRect(size.toRect(), paint);
  }
}