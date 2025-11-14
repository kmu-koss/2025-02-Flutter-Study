import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/work.dart';

Future<List<Work>> loadWorksByExhibitionId(int exhibitionId) async {
  final String response = await rootBundle.loadString('assets/data/works.json');
  final List<dynamic> data = json.decode(response);

  final item = data.firstWhere(
        (e) => e['exhibitionId'] == exhibitionId,
    orElse: () => null,
  );

  if (item == null) return [];
  final works = (item['works'] as List)
      .map((workData) => Work.fromJson(workData))
      .toList();
  return works;
}
