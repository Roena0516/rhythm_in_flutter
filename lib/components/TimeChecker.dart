import 'package:flame/components.dart';
import '../page/InGame.dart';

class TimeChecker extends PositionComponent with HasGameReference<InGame> {
  final double Function() getCurrentTime;

  TimeChecker({
    required this.getCurrentTime,
  }) : super(priority: 300);

  @override
  Future<void> onLoad() async {
  }

  @override
  void update(double dt) {
    // print("currentTime: ${getCurrentTime()}ms");
  }
}