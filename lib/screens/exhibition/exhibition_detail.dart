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
  late PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    worksFuture = loadWorksByExhibitionId(widget.index + 1);
    _pageController = PageController(viewportFraction: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.exhibitionName,
          style: const TextStyle(
              fontFamily: 'Pretendard-Regular',
              fontSize: 18
          ),
        ),
      ),
      body: FutureBuilder<List<Work>>(
        future: worksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('아직 기록한 작품이 없어요!'));
          }
          final works = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: works.length,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, i) {
                            final work = works[i];
                            final active = i == _currentPage;
                            final scale = active ? 1.0 : 0.8;
                            final opacity = active ? 1.0 : 0.5;

                            return AnimatedContainer(
                              height: 220,
                              width: 150,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              child: Transform.scale(
                                scale: scale,
                                child: Opacity(
                                  opacity: opacity,
                                  child: ClipRRect(
                                    child: Image.asset(
                                        work.imagePath, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      if (_currentPage > 0)
                        Positioned(
                          left: 20,
                          child: IconButton(
                            onPressed: () {
                              if (_currentPage > 0) {
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut
                                );
                              }
                            },
                            icon: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xff0D9F34),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Icon(Icons.arrow_back_ios, color: Colors.white)
                            ),
                          ),
                        ),
                      if (_currentPage < works.length - 1)
                        Positioned(
                          right: 20,
                          child: IconButton(
                            onPressed: () {
                              if (_currentPage < works.length - 1) {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut
                                );
                              }
                            },
                            icon: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xff0D9F34),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.white)
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const Text(
                "작품명",
                style: TextStyle(
                    fontFamily: 'Pretendard-Light',
                    fontSize: 18
                )
              ),
              Text(
                works[_currentPage].title,
                style: const TextStyle(
                    fontFamily: 'Pretendard-Medium',
                    fontSize: 24
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                          "작가",
                          style: TextStyle(
                              fontFamily: 'Pretendard-Light',
                              fontSize: 18
                          )
                      ),
                      Text(
                        works[_currentPage].author,
                        style: const TextStyle(
                            fontFamily: 'Pretendard-Regular',
                            fontSize: 24
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 50),
                  Column(
                    children: [
                      const Text(
                        "제작 시기",
                        style: TextStyle(
                            fontFamily: 'Pretendard-Light',
                            fontSize: 18
                        ),
                      ),
                      Text(
                        works[_currentPage].date,
                        style: const TextStyle(
                            fontFamily: 'Pretendard-Regular',
                            fontSize: 24
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                  "감상평",
                  style: TextStyle(
                      fontFamily: 'Pretendard-Light',
                      fontSize: 18
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Text(
                  works[_currentPage].review,
                  style: const TextStyle(
                      fontFamily: 'Pretendard-Regular',
                      fontSize: 18),
                ),
              ),
              const SizedBox(height: 200)
            ],
          );
        },
      ),
    );
  }
}
