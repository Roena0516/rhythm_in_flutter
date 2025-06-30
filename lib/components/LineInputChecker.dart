import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../page/InGame.dart';
import 'Lane.dart';

class LineInputChecker extends PositionComponent with HasGameReference<InGame>, TapCallbacks, DragCallbacks {

  Vector2 _lastPosition = Vector2.zero();
  dynamic judgementManager;

  final Lane lane1;
  final Lane lane2;
  final Lane lane3;
  final Lane lane4;

  int prev = 1;
  late double centerPosition;
  late double lane1Position;
  late double lane2Position;
  late double lane3Position;
  late double lane4Position;

  List<bool> isHolding = [false, false, false, false];

  LineInputChecker({
    required this.lane1,
    required this.lane2,
    required this.lane3,
    required this.lane4,
  }) : super(priority: 500);

  @override
  Future<void> onLoad() async {
    size = Vector2(550, 300);
    position = Vector2(game.size.x / 2, 550);
    anchor = Anchor.center;
    centerPosition = game.size.x / 2;
    lane1Position = centerPosition - 300;
    lane2Position = centerPosition - 125;
    lane3Position = centerPosition;
    lane4Position = centerPosition + 125;
    // print(centerPosition);
    // print("$lane1Position $lane2Position $lane3Position $lane4Position");
  }

  @override
  void onDragStart(DragStartEvent event) {
    _lastPosition = event.canvasPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _lastPosition += event.canvasDelta;  // 현재 위치 추정
    int laneNum = 0;

    if (_lastPosition.x >= lane1Position && _lastPosition.x <= lane2Position) {
      laneNum = 1;
      lane1.setColor(Color(0x80FFFFFF));
    }
    if (_lastPosition.x > lane2Position && _lastPosition.x <= lane3Position) {
      laneNum = 2;
      lane2.setColor(Color(0x80FFFFFF));
    }
    if (_lastPosition.x > lane3Position && _lastPosition.x <= lane4Position) {
      laneNum = 3;
      lane3.setColor(Color(0x80FFFFFF));
    }
    if (_lastPosition.x > lane4Position && _lastPosition.x <= lane4Position + 100) {
      laneNum = 4;
      lane4.setColor(Color(0x80FFFFFF));
    }

    if (toRect().contains(_lastPosition.toOffset()) && prev != laneNum) {
      print('드래그 감지됨! $laneNum, $prev');
      isHolding[laneNum - 1] = true;
      isHolding[prev - 1] = false;
      if (prev == 1) {
        lane1.setColor(Color(0x40FFFFFF));
      }
      if (prev == 2) {
        lane2.setColor(Color(0x40FFFFFF));
      }
      if (prev == 3) {
        lane3.setColor(Color(0x40FFFFFF));
      }
      if (prev == 4) {
        lane4.setColor(Color(0x40FFFFFF));
      }
      prev = laneNum;
      judgementManager.judge(laneNum);
    }

    if (toRect().contains(_lastPosition.toOffset())) {
      judgementManager.flickJudge(laneNum);
    }
  }

  @override
  void update(double dt) {
    if (isHolding[0]) {
      judgementManager.holdJudge(1);
    }
    if (isHolding[1]) {
      judgementManager.holdJudge(2);
    }
    if (isHolding[2]) {
      judgementManager.holdJudge(3);
    }
    if (isHolding[3]) {
      judgementManager.holdJudge(4);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _lastPosition = event.canvasPosition;  // 현재 위치 추정
    int laneNum = 0;

    if (_lastPosition.x >= lane1Position && _lastPosition.x <= lane2Position) {
      laneNum = 1;
      lane1.setColor(Color(0x80FFFFFF));
    }
    if (_lastPosition.x > lane2Position && _lastPosition.x <= lane3Position) {
      laneNum = 2;
      lane2.setColor(Color(0x80FFFFFF));
    }
    if (_lastPosition.x > lane3Position && _lastPosition.x <= lane4Position) {
      laneNum = 3;
      lane3.setColor(Color(0x80FFFFFF));
    }
    if (_lastPosition.x > lane4Position && _lastPosition.x <= lane4Position + 100) {
      laneNum = 4;
      lane4.setColor(Color(0x80FFFFFF));
    }

    prev = laneNum;
    isHolding[laneNum - 1] = true;

    print('탭 감지됨! $laneNum ${_lastPosition.x}');
    judgementManager.judge(laneNum);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _lastPosition = event.canvasPosition;

    int laneNum = 1;

    if (_lastPosition.x >= lane1Position && _lastPosition.x <= lane2Position) {
      laneNum = 1;
      lane1.setColor(Color(0x40FFFFFF));
    }
    if (_lastPosition.x > lane2Position && _lastPosition.x <= lane3Position) {
      laneNum = 2;
      lane2.setColor(Color(0x40FFFFFF));
    }
    if (_lastPosition.x > lane3Position && _lastPosition.x <= lane4Position) {
      laneNum = 3;
      lane3.setColor(Color(0x40FFFFFF));
    }
    if (_lastPosition.x > lane4Position && _lastPosition.x <= lane4Position + 100) {
      laneNum = 4;
      lane4.setColor(Color(0x40FFFFFF));
    }

    isHolding[laneNum - 1] = false;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    lane1.setColor(Color(0x40FFFFFF));
    lane2.setColor(Color(0x40FFFFFF));
    lane3.setColor(Color(0x40FFFFFF));
    lane4.setColor(Color(0x40FFFFFF));

    isHolding[0] = false;
    isHolding[1] = false;
    isHolding[2] = false;
    isHolding[3] = false;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    int laneNum = 1;

    if (_lastPosition.x >= lane1Position && _lastPosition.x <= lane2Position) {
      laneNum = 1;
    }
    if (_lastPosition.x > lane2Position && _lastPosition.x <= lane3Position) {
      laneNum = 2;
    }
    if (_lastPosition.x > lane3Position && _lastPosition.x <= lane4Position) {
      laneNum = 3;
    }
    if (_lastPosition.x > lane4Position && _lastPosition.x <= lane4Position + 100) {
      laneNum = 4;
    }

    lane1.setColor(Color(0x40FFFFFF));
    lane2.setColor(Color(0x40FFFFFF));
    lane3.setColor(Color(0x40FFFFFF));
    lane4.setColor(Color(0x40FFFFFF));

    isHolding[laneNum - 1] = false;
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   final paint = Paint()..color = Colors.blueGrey;
  //   canvas.drawRect(size.toRect(), paint);
  // }
}