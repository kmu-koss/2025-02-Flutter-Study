import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/exhibition.dart';

Future<List<Exhibition>> loadExhibitions() async {
  final String jsonString = await rootBundle.loadString('assets/data/exhibitions.json');
  final List<dynamic> jsonList = json.decode(jsonString);

  return jsonList.map((item) {
    final exhibitionData = item['exhibition'];
    if (exhibitionData == null) {
      return Exhibition(
        name: '정보 없음',
        imagePath: 'assets/images/polygon.png',
        visitedDate: '날짜 없음',
        recordedWork: '0개'
      );
    }
    return Exhibition.fromJson(exhibitionData);
  }).toList();
}