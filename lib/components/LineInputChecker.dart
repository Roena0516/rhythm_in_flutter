import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../page/InGame.dart';
import 'Lane.dart';

class LineInputChecker extends PositionComponent with HasGameReference<InGame>, TapCallbacks, DragCallbacks {
  dynamic judgementManager;

  final Lane lane;
  final int laneNum;

  Vector2 lastPosition = Vector2.zero();

  bool isHolding = false;

  double getLaneX(int lane) => (lane - 1) * 125.0 - 125.0;

  LineInputChecker({
    required this.lane,
    required this.laneNum,
  }) : super(priority: 500);

  @override
  Future<void> onLoad() async {
    size = Vector2(125, 700);
    final double baseX = (game.size.x - size.x) / 2 + getLaneX(laneNum);
    position = Vector2(baseX, game.size.y);
    if (laneNum == 1) {
      size = Vector2(175, 700);
      position.add(Vector2(-25, 0));
    }
    if (laneNum == 4) {
      size = Vector2(175, 700);
      position.add(Vector2(25, 0));
    }
    anchor = Anchor.center;
  }

  @override
  void onDragStart(DragStartEvent event) {
    lastPosition = event.canvasPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    lastPosition += event.canvasDelta;
    if (!toRect().contains(lastPosition.toOffset())) {
      // 영역 밖으로 나간 경우
      if (isHolding) {
        lane.setColor(Color(0x40FFFFFF));
        isHolding = false;
      }
    } else {
      judgementManager.flickJudge(laneNum);
      // 영역 안일 때만 hold 유지
      if (!isHolding) {
        isHolding = true;
        lane.setColor(Color(0x80FFFFFF));
      }
    }
  }

  @override
  void update(double dt) {
    if (isHolding) {
      judgementManager.holdJudge(laneNum);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    isHolding = true;

    print('탭 감지됨! $laneNum');
    lane.setColor(Color(0x80FFFFFF));
    judgementManager.judge(laneNum);
  }

  @override
  void onTapUp(TapUpEvent event) {
    lane.setColor(Color(0x40FFFFFF));
    isHolding = false;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    lane.setColor(Color(0x40FFFFFF));

    isHolding = false;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    lane.setColor(Color(0x40FFFFFF));

    isHolding = false;
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   final paint = Paint()..color = Colors.blueGrey;
  //   canvas.drawRect(size.toRect(), paint);
  // }
}