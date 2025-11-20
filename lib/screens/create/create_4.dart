import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../exhibition/exhibition_main.dart';
import 'create_3.dart';

class Create4 extends StatelessWidget {
  final List<String> titles;
  final List<String> authors;
  final List<String> dates;
  final List<String> reviews;
  final List<String> images;

  const Create4({
    super.key,
    required this.titles,
    required this.authors,
    required this.dates,
    required this.reviews,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                "작성한 감상평을 확인해주세요!",
                style: TextStyle(
                    fontFamily: "Pretendard-SemiBold",
                    fontSize: 24
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 20, top: 10),
                  child: Row(
                    children: [
                      Image.asset(
                        width: 150,
                        height: 200,
                        images[index],
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "작품명",
                            style: TextStyle(
                                fontFamily: "Pretendard-Light",
                                fontSize: 15
                            ),
                          ),
                          Text(
                            titles[index],
                            style: const TextStyle(
                                fontFamily: "Pretendard-Regular",
                                fontSize: 18
                            ),
                          ),
                          const Text(
                            "작가",
                            style: TextStyle(
                                fontFamily: "Pretendard-Light",
                                fontSize: 15
                            ),
                          ),
                          Text(
                            authors[index],
                            style: const TextStyle(
                                fontFamily: "Pretendard-Regular",
                                fontSize: 18
                            ),
                          ),const Text(
                            "제작 시기",
                            style: TextStyle(
                                fontFamily: "Pretendard-Light",
                                fontSize: 15
                            ),
                          ),
                          Text(
                            dates[index],
                            style: const TextStyle(
                                fontFamily: "Pretendard-Regular",
                                fontSize: 18
                            ),
                          ),
                          const Text(
                            "감상평",
                            style: TextStyle(
                                fontFamily: "Pretendard-Light",
                                fontSize: 15
                            ),
                          ),
                          Text(
                            reviews[index],
                            style: const TextStyle(
                                fontFamily: "Pretendard-Regular",
                                fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  backgroundColor: const Color(0xffD9D9D9),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Get.to(() => const Create3(images: [],));
                },
                child: const Text(
                  "취소",
                  style: TextStyle(
                    fontFamily: "Pretendard-Regular",
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 180,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  backgroundColor: const Color(0xff0D9F34),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Get.off(() => const ExhibitionMain());
                },
                child: const Text(
                  "완료",
                  style: TextStyle(
                    fontFamily: "Pretendard-Regular",
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
