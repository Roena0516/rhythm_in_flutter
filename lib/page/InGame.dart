import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rhythm/components/JudgeLine.dart';
import 'package:rhythm/components/Lane.dart';
import 'package:rhythm/components/LineInputChecker.dart';
import 'package:rhythm/components/RateText.dart';
import 'package:rhythm/components/TimeChecker.dart';
import 'package:rhythm/loadChart.dart';

import '../main.dart';
import '../components/ComboText.dart';
import '../components/JudgeText.dart';
import '../components/JudgementManager.dart';
import '../components/NoteGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(GameWidget(game: InGame()));
}

class InGameWrapper extends StatefulWidget {
  @override
  State<InGameWrapper> createState() => _InGameWrapperState();
}

class _InGameWrapperState extends State<InGameWrapper> {
  late final InGame _game;

  @override
  void initState() {
    super.initState();
    _game = InGame();
  }

  @override
  void dispose() {
    _game.onRemove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}

class InGame extends FlameGame {
  late final JudgementManager judgementManager;
  bool isStarted = false;

  late final startTime = currentTime() * 1000;
  double getCurrentTime() => (currentTime() * 1000) - startTime;

  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    print("startTime: ${startTime}ms");
    print("${getCurrentTime()}ms");

    final levelData = await loader();
    print("completed ${getCurrentTime()}ms");

    final timeChecker = TimeChecker(
        getCurrentTime: getCurrentTime
    );
    await add(
        timeChecker
    );

    final judgeText = JudgeText()
      ..priority = 400;
    add(judgeText);

    final rateText = RateText()
      ..priority = 400;
    add(rateText);

    final comboText = ComboText()
      ..priority = 400;
    add(comboText);

    final noteGenerator = NoteGenerator(
      notes: levelData.notes,
      info: levelData.info,
      getCurrentTime: getCurrentTime,
    )
      ..priority = 300;

    judgementManager = JudgementManager(
      generator: noteGenerator,
      getCurrentTime: getCurrentTime,
      judgeText: judgeText,
      rateText: rateText,
      comboText: comboText,
    );

    add (
        noteGenerator
    );

    await noteGenerator.initialized;

    judgementManager.calcRate();

    final lineInputChecker = LineInputChecker()
      ..judgementManager = judgementManager
      ..priority = 500;

    add(lineInputChecker);

    // Lane에서 입력을 받음
    final lane1 = Lane()
      ..laneNum = 1
      ..anchor = Anchor.center
      ..noteGenerator = noteGenerator
      ..judgementManager = judgementManager
      ..priority = 100;
    final lane2 = Lane()
      ..laneNum = 2
      ..anchor = Anchor.center
      ..noteGenerator = noteGenerator
      ..judgementManager = judgementManager
      ..priority = 100;
    final lane3 = Lane()
      ..laneNum = 3
      ..anchor = Anchor.center
      ..noteGenerator = noteGenerator
      ..judgementManager = judgementManager
      ..priority = 100;
    final lane4 = Lane()
      ..laneNum = 4
      ..anchor = Anchor.center
      ..noteGenerator = noteGenerator
      ..judgementManager = judgementManager
      ..priority = 100;

    lane1.position = (game.size - lane1.size) / 2;
    lane1.position.add(Vector2(-62.5 - 125, 0));
    lane2.position = (game.size - lane2.size) / 2;
    lane2.position.add(Vector2(-62.5, 0));
    lane3.position = (game.size - lane3.size) / 2;
    lane3.position.add(Vector2(62.5, 0));
    lane4.position = (game.size - lane4.size) / 2;
    lane4.position.add(Vector2(62.5 + 125, 0));

    add(lane1); add(lane2); add(lane3); add(lane4);

    // 판정선 표시용
    final judgeLine = JudgeLine()
      ..anchor = Anchor.center
      ..priority = 100;

    judgeLine.position = (game.size - judgeLine.size) / 2;
    judgeLine.position.add(Vector2(0, 230));

    add(judgeLine);

    isStarted = true;
  }
}