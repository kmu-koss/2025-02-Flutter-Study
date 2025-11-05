import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/exhibition_loader.dart';
import '../../models/exhibition.dart';
import 'exhibition_detail.dart';

class ExhibitionMain extends StatefulWidget {
  const ExhibitionMain({super.key});

  @override
  State<ExhibitionMain> createState() => _ExhibitionMainState();
}

class _ExhibitionMainState extends State<ExhibitionMain> {
  late Future<List<Exhibition>> exhibitionsFuture;
  final Set<int> _shownIndex = {};

  @override
  void initState() {
    super.initState();
    exhibitionsFuture = loadExhibitions();
  }

  void _handleExhb(int index) {
    setState(() {
      if (_shownIndex.contains(index)) {
        _shownIndex.remove(index);
        Get.to(() => ExhibitionDetail(index: index));
      } else {
        setState(() {
          _shownIndex.add(index);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '내가 감상한 전시회에요!',
          style: TextStyle(
            fontFamily: 'Pretendard-SemiBold',
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, // TODO: 좋아요 페이지 연결
            icon: Icon(Icons.favorite), color: Color(0xff0D9F34)
          ),
        ],
      ),
      body: FutureBuilder<List<Exhibition>>(
        future: exhibitionsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('아직 감상한 전시가 없어요!'));
          }

          final exhibitions = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
            ),
            itemCount: exhibitions.length,
            itemBuilder: (context, index) {
              final exhb = exhibitions[index];
              final showText = _shownIndex.contains(index);

              return GestureDetector(
                onTap: () => _handleExhb(index),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(exhb.imagePath, width: 150, height: 200, fit: BoxFit.cover),
                    if (showText)
                      Container(
                        child: Text(exhb.name),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
