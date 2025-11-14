import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/work.dart';
import 'like_detail.dart';
import '../../data/work_loader_all.dart';
import '../exhibition/exhibition_main.dart';

class LikeMain extends StatefulWidget {
  const LikeMain({super.key});

  @override
  State<LikeMain> createState() => _LikeMainState();
}

class _LikeMainState extends State<LikeMain> {
  late Future<List<Work>> worksFuture;
  final Set<int> _shownIndex = {};

  @override
  void initState() {
    super.initState();
    worksFuture = loadAllWorks();
  }

  void _handleWork(int index, Work work) {
    setState(() {
      if (_shownIndex.contains(index)) {
        _shownIndex.remove(index);
        Get.to(() => LikeDetail(index: index, exhibitionName: work.exhibitionName));
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
        title: const Text(
          '내가 좋아하는 작품이에요!',
          style: TextStyle(
              fontFamily: 'Pretendard-SemiBold',
              fontSize: 24
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.off(() => const ExhibitionMain());
            },
            icon: const Icon(Icons.home_filled), color: const Color(0xff0D9F34),
          ),
        ],
      ),
      body: FutureBuilder<List<Work>>(
        future: worksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('아직 감상한 전시가 없어요!'));
          }

          final works = snapshot.data!;
          final likedWorks = works.where((e) => e.like == 1).toList();
          if (likedWorks.isEmpty) {
            return const Center(child: Text('아직 좋아하는 전시가 없어요!'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
            ),
            itemCount: likedWorks.length,
            itemBuilder: (context, index) {
              final exhb = likedWorks[index];
              final showText = _shownIndex.contains(index);

              return GestureDetector(
                onTap: () => _handleWork(index, exhb),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(exhb.imagePath, width: 150, height: 200, fit: BoxFit.cover),
                    if (showText)
                      Container(width: 150, height: 200, color: const Color(0xCC0D9F34)),
                    if (showText)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            exhb.title,
                            style: const TextStyle(
                              fontFamily: 'Pretendard-Medium',
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 120),
                          Text(
                            '전시회    ${exhb.exhibitionName}',
                            style: const TextStyle(
                              fontFamily: 'Pretendard-Light',
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '작가               ${exhb.author}',
                            style: const TextStyle(
                              fontFamily: 'Pretendard-Light',
                              fontSize: 12,
                            ),
                          ),
                        ],
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
