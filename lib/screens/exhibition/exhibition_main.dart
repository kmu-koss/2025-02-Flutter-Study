import 'package:flutter/material.dart';

import '../../data/exhibition_loader.dart';
import '../../models/exhibition.dart';

class ExhibitionMain extends StatefulWidget {
  const ExhibitionMain({super.key});

  @override
  State<ExhibitionMain> createState() => _ExhibitionMainState();
}

class _ExhibitionMainState extends State<ExhibitionMain> {
  late Future<List<Exhibition>> exhibitionsFuture;

  @override
  void initState() {
    super.initState();
    exhibitionsFuture = loadExhibitions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내가 감상한 전시회에요!'),

      ),
      body: FutureBuilder<List<Exhibition>>(
        future: exhibitionsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('아직 감상한 전시가 없어요!'));
          }

          final exhibitions = snapshot.data!;
          return ListView.builder(
            itemCount: exhibitions.length,
            itemBuilder: (context, index) {
              final exhb = exhibitions[index];
              return ListTile(
                leading: Image.asset(exhb.imagePath, width: 150, fit: BoxFit.cover),
                title: Text(exhb.name),
              );
            },
          );
        },
      ),
    );
  }
}
