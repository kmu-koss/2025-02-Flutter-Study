import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_1.dart';
import 'create_3.dart';

class Create2 extends StatefulWidget {
  const Create2({super.key});

  @override
  State<Create2> createState() => _Create2State();
}

class _Create2State extends State<Create2> {
  Set<int> selectedIndexes = {}; // 선택된 이미지 index들을 담아두는 Set

  List<String> images = [
    "assets/images/work_onestepaway_1.png",
    "assets/images/work_onestepaway_2.png",
    "assets/images/work_onestepaway_3.png",
    "assets/images/work_onestepaway_4.jpg",
    "assets/images/work_onestepaway_5.jpg",
    "assets/images/work_yosigo_1.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                "기록하고 싶은 작품을 골라주세요!",
                style: TextStyle(
                  fontFamily: "Pretendard-SemiBold",
                  fontSize: 24
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final isSelected = selectedIndexes.contains(index);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedIndexes.remove(index);
                      } else {
                        selectedIndexes.add(index);
                      }
                    });
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                            width: 100,
                            height: 130,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 100,
                            height: 130,
                            decoration: const BoxDecoration(
                              color: Color(0xCC0D9F34),
                            ),
                            child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 40
                            ),
                          ),
                      ],
                    ),
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
                  Get.off(() => const Create1());
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
                  final selectedImages = selectedIndexes.map((index) => images[index]).toList();
                  Get.to(() => Create3(images: selectedImages));
                },
                child: const Text(
                  "다음",
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
