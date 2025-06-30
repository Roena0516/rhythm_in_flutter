
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
          Text('PerfectP: ${resultData['count']['PerfectP']}'),
          Text('Perfect: ${resultData['count']['Perfect']}'),
          Text('Great: ${resultData['count']['Great']}'),
          Text('Good: ${resultData['count']['Good']}'),
          Text('Bad: ${resultData['count']['Bad']}'),
          Text('Miss: ${resultData['count']['Miss']}'),
          Text('Rate: ${resultData['rate']}%'),
          Text(resultData['isFC'] ? 'FULL COMBO' : ''),
          Text(resultData['isAP'] ? 'ALL PERFECT' : ''),
        ],
      ),
    );
  }
}