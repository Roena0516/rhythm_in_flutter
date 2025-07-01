
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SongInfo {
  final String title;
  final String artist;
  final double bpm;

  SongInfo({
    required this.title,
    required this.artist,
    required this.bpm,
  });

  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo(
      title: json['title'],
      artist: json['artist'],
      bpm: json['bpm'],
    );
  }
}

class NoteClass {
  final double beat;
  double ms;
  final int position;
  final String type;
  bool isEndNote = false;
  bool isInputed = false;
  dynamic parents;

  NoteClass({
    required this.beat,
    required this.ms,
    required this.position,
    required this.type,
    required this.isEndNote,
    this.isInputed = false,
  });

  factory NoteClass.fromJson(Map<String, dynamic> json) {
    return NoteClass(
      beat: json['beat'].toDouble(),
      ms: 0,
      position: json['position'],
      type: json['type'],
      isEndNote: false,
    );
  }
}

class SongData {
  final SongInfo info;
  final List<NoteClass> notes;

  SongData({
    required this.info,
    required this.notes,
  });

  factory SongData.fromJson(Map<String, dynamic> json) {
    return SongData(
      info: SongInfo.fromJson(json['info']),
      notes: (json['notes'] as List).map((e) => NoteClass.fromJson(e)).toList(),
    );
  }
}


Future<SongData> loadSongData(String path) async {
  final String jsonStr = await rootBundle.loadString(path);
  final Map<String, dynamic> jsonMap = json.decode(jsonStr);
  return SongData.fromJson(jsonMap);
}

Future<SongData> loader() async {
  final songData = await loadSongData('assets/data/godish.json');
  print(songData.info.title);
  print(songData.info.bpm);
  return songData;
}