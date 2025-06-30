import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../page/InGame.dart';

class LineInputChecker extends PositionComponent with HasGameReference<InGame>, TapCallbacks, DragCallbacks {

  Vector2 _lastPosition = Vector2.zero();
  dynamic judgementManager;
  int prev = 1;
  late double centerPosition;
  late double lane1Position;
  late double lane2Position;
  late double lane3Position;
  late double lane4Position;

  int isHolding = 0;

  LineInputChecker() : super(priority: 500);

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

    if (toRect().contains(_lastPosition.toOffset()) && prev != laneNum) {
      print('드래그 감지됨! $laneNum, $prev');
      prev = laneNum;
      judgementManager.judge(laneNum);
    }

    if (toRect().contains(_lastPosition.toOffset())) {
      judgementManager.flickJudge(laneNum);
    }
  }

  @override
  void update(double dt) {
    if (isHolding != 0) {
      judgementManager.holdJudge(isHolding);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _lastPosition = event.canvasPosition;  // 현재 위치 추정
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

    prev = laneNum;
    isHolding = laneNum;

    print('탭 감지됨! $laneNum ${_lastPosition.x}');
    judgementManager.judge(laneNum);
  }

  @override
  void onTapUp(TapUpEvent event) {
    isHolding = 0;
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   final paint = Paint()..color = Colors.blueGrey;
  //   canvas.drawRect(size.toRect(), paint);
  // }
}