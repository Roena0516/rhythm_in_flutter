import 'dart:async';

import 'package:flame/components.dart';

import '../loadChart.dart';
import '../page/InGame.dart';
import 'Note.dart';

class NoteGenerator extends Component with HasGameReference<InGame> {
  final List<NoteClass> notes;
  final SongInfo info;
  final List<int> randomLane = [1, 2, 3, 4];

  final double speed;
  final double distance = 705; // pixel
  late final double fallTime; // ms

  final double Function() getCurrentTime;

  final Map<String, int> noteTypeCounts = {
    'normal': 0,
    'hold': 0,
    'up': 0,
  };

  final Completer<void> _initializedCompleter = Completer<void>();
  Future<void> get initialized => _initializedCompleter.future;

  NoteGenerator({
    required this.notes,
    required this.info,
    this.speed = 1.25,
    required this.getCurrentTime,
  }) : super(priority: 300);

  @override
  Future<void> onLoad() async {
    fallTime = (distance / speed);

    // shuffleLanes(); // 옵션에 따라 위치 랜덤화 가능

    await Future.delayed(const Duration(seconds: 1));
    await generateNotes();
  }

  void shuffleLanes() {
    randomLane.shuffle();
  }

  Future<void> generateNotes() async {
    final oneBeatDuration = 60 / info.bpm * 1000;

    for (final note in notes) {
      noteTypeCounts[note.type] = (noteTypeCounts[note.type] ?? 0) + 1;

      final mappedLane = randomLane[note.position - 1];
      final beatDuration = oneBeatDuration * note.beat;
      final ms = beatDuration + 3000;

      note.ms = ms;

      final noteComponent = Note(
        note: note,
        lanePosition: mappedLane,
        ms: ms,
        fallTime: fallTime,
        speed: speed,
        getCurrentTime: getCurrentTime,
      )
        ..priority = 300
        ..anchor = Anchor.center;

      noteComponent.note.parents = noteComponent;
      add(noteComponent);
      // await Future.delayed(const Duration(milliseconds: 36));
    }

    notes.last.isEndNote = true;
    _initializedCompleter.complete();
  }
}