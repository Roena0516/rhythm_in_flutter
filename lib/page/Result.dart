
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> resultData;

  const ResultScreen({required this.resultData, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('결과')),
      body: Column(
        children: [
          Text('Score: ${resultData['score']}'),
          Text('Combo: ${resultData['combo']}'),
          Text(resultData['isFC'] ? 'Full Combo!' : ''),
          Text(resultData['isAP'] ? 'All Perfect!' : ''),
        ],
      ),
    );
  }
}