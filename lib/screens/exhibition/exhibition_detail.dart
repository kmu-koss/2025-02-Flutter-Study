import 'package:flutter/material.dart';

import '../../models/work.dart';
import '../../data/work_loader.dart';

class ExhibitionDetail extends StatefulWidget {
  final int index;
  final String exhibitionName;
  const ExhibitionDetail({super.key, required this.index, required this.exhibitionName});

  @override
  State<ExhibitionDetail> createState() => _ExhibitionDetailState();
}

class _ExhibitionDetailState extends State<ExhibitionDetail> {
  late Future<List<Work>> worksFuture;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    worksFuture = loadWorksByExhibitionId(widget.index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.exhibitionName}")
      ),

      body: FutureBuilder<List<Work>>(
        future: worksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('아직 기록한 작품이 없어요!'));
          }

          final works = snapshot.data!;
          return PageView.builder(
            controller: _pageController,
            itemCount: works.length,
            itemBuilder: (context, i) {
              final work = works[i];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (i > 0)
                              Positioned(
                                left: 0,
                                child: IconButton(
                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                ),
                              ),
                            ClipRRect(child: Image.asset(work.imagePath)),
                            if (i < works.length - 1)
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios, color: Colors.white
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text("작품명"),
                      ],
                    ),
                  ],
                ),
              );
            }
          );
        },
      ),
    );
  }
}
