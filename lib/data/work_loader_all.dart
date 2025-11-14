import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/work.dart';

Future<List<Work>> loadAllWorks() async {
  final String response = await rootBundle.loadString('assets/data/works.json');
  final List<dynamic> data = json.decode(response);

  final allWorks = data.expand((item) {
    final works = item['works'] as List<dynamic>;
    return works.map((w) => Work.fromJson(w));
  }).toList();
  return allWorks;
}
