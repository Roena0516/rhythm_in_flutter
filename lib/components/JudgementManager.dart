

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:rhythm/components/NoteGenerator.dart';

import '../loadChart.dart';

class JudgementManager {
  final double perfectP = 25;
  final double perfect = 40;
  final double great = 60;
  final double good = 110;
  final double bad = 160;

  final Map<String, int> judgeCount = {
    'PerfectP': 0,
    'Perfect': 0,
    'Great': 0,
    'Good': 0,
    'Bad': 0,
    'Miss': 0,
  };

  final Map<String, double> noteTypeRate = {
    'normal': 0.0,
    'hold': 0.0,
    'up': 0.0,
  };

  int combo = 0;
  double rate = 100.0;
  bool isAP = false;
  bool isFC = false;

  final NoteGenerator generator;
  final double Function() getCurrentTime;
  final TextComponent judgeText;
  final TextComponent rateText;
  final TextComponent comboText;

  JudgementManager({
    required this.generator,
    required this.getCurrentTime,
    required this.judgeText,
    required this.rateText,
    required this.comboText,
  });

  void calcRate() {
    final noteCounts = generator.noteTypeCounts;
    final total = (noteCounts['normal']! * 1 + noteCounts['hold']! * 1 + noteCounts['up']! * 2).toDouble();

    noteTypeRate['normal'] = noteCounts['normal']! > 0 ? 100 / total : 0;
    noteTypeRate['hold'] = noteCounts['hold']! > 0 ? 100 / total : 0;
    noteTypeRate['up'] = noteCounts['up']! > 0 ? 200 / total : 0;
  }

  void holdJudge(int laneNumber) {
    final nowMs = getCurrentTime();
    final notes = generator.notes.where((note) =>
    (note.position == laneNumber) &&
        !note.isInputed &&
        (nowMs - note.ms) > 0
    ).toList();
    for (final note in notes) {
      if (note.type == 'hold') {
        note.isInputed = true;
        return;
      }
    }
  }

  void flickJudge(int laneNumber) {
    final nowMs = getCurrentTime();
    final notes = generator.notes.where((note) =>
    (note.position == laneNumber) &&
        !note.isInputed &&
        (nowMs - note.ms).abs() <= bad
    ).toList();
    for (final note in notes) {
      final diff = (note.ms - nowMs).abs();

      if (note.type == 'up') {
        if (diff <= perfectP) {
          performAction(note, 'PerfectP');
          return;
        } else if (diff <= perfect) {
          performAction(note, 'Perfect');
          return;
        } else if (diff <= great) {
          performAction(note, 'Great');
          return;
        } else if (diff <= good) {
          performAction(note, 'Great');
          return;
        }
      }
    }
  }

  void judge(int laneNumber) {
    final nowMs = getCurrentTime();
    final notes = generator.notes.where((note) =>
    (note.position == laneNumber) &&
        !note.isInputed &&
        (nowMs - note.ms).abs() <= bad
    ).toList();

    for (final note in notes) {
      final diff = (note.ms - nowMs).abs();

      if (note.type == 'hold') {
        note.isInputed = true;
        return;
      }

      if (note.type == "normal") {
        if (diff <= perfectP) {
          performAction(note, 'PerfectP');
          return;
        } else if (diff <= perfect) {
          performAction(note, 'Perfect');
          return;
        } else if (diff <= great) {
          performAction(note, 'Great');
          return;
        } else if (diff <= good) {
          performAction(note, 'Good');
          return;
        } else if (diff <= bad) {
          performAction(note, 'Bad');
          return;
        }
      }
    }
  }

  void performAction(NoteClass note, String judgement) {
    note.isInputed = true;
    note.parents.removeFromParent();
    judgeCount[judgement] = judgeCount[judgement]! + 1;

    if (['Great', 'Good', 'Bad', 'Miss'].contains(judgement)) {
      changeRate(note.type, judgement);
    }

    if (judgement == 'Bad' || judgement == 'Miss') {
      clearCombo();
    } else {
      addCombo();
    }

    if (note.isEndNote) {
      _handleEndNote();
    }

    // TODO: 시각적 피드백 및 효과 추가
    judgeText.text = judgement;
    debugPrint('[$judgement] ${note.type} at lane ${note.position}, ${note.ms}, ${note.beat}beat, ${getCurrentTime()}ms');
  }

  void _handleEndNote() {
    if (judgeCount['Miss'] == 0 && judgeCount['Bad'] == 0) {
      isFC = true;
    }
    if (judgeCount.values.every((v) => v == 0 || v == judgeCount['PerfectP'])) {
      isAP = true;
    }
    // TODO: 게임 종료 처리 등
  }

  void changeRate(String type, String judgement) {
    double ratio = switch (judgement) {
      'Great' => 0.25,
      'Good' => 0.5,
      'Bad' || 'Miss' => 1.0,
      _ => 0,
    };

    rate -= noteTypeRate[type]! * ratio;

    double formattedRate = (rate * 100).floorToDouble() / 100;

    rateText.text = "${formattedRate.toStringAsFixed(2)}%";
  }

  void addCombo() {
    combo += 1;
    comboText.text = "$combo";
  }
  void clearCombo() {
    combo = 0;
    comboText.text = "$combo";
  }
}
