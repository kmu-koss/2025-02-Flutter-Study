import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_2.dart';
import 'create_4.dart';

class Create3 extends StatefulWidget {
  final List<String> images;
  const Create3({super.key, required this.images});

  @override
  State<Create3> createState() => _Create3State();
}

class _Create3State extends State<Create3> {
  int currentPage = 0;

  late List<TextEditingController> titleControllers;
  late List<TextEditingController> authorControllers;
  late List<TextEditingController> dateControllers;
  late List<TextEditingController> reviewControllers;

  @override
  void initState() {
    super.initState();

    titleControllers = List.generate(widget.images.length, (_) => TextEditingController());
    authorControllers = List.generate(widget.images.length, (_) => TextEditingController());
    dateControllers = List.generate(widget.images.length, (_) => TextEditingController());
    reviewControllers = List.generate(widget.images.length, (_) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                "감상평을 작성해주세요!",
                style: TextStyle(
                    fontFamily: "Pretendard-SemiBold",
                    fontSize: 24
                ),
              ),
            ),
          ),

          Expanded(
            child: PageView.builder(
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Image.asset(
                    widget.images[index],
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          
          const Text(
            "작품명",
            style: TextStyle(
              fontFamily: "Pretendard-Light",
              fontSize: 18
            ),
          ),
          SizedBox(
            width: 150,
            child: TextField(
              controller: titleControllers[currentPage],
              style: const TextStyle(
                fontFamily: "Pretendard-Medium",
                fontSize: 24
              ),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "작가",
                    style: TextStyle(
                        fontFamily: "Pretendard-Light",
                        fontSize: 18
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: authorControllers[currentPage],
                      style: const TextStyle(
                          fontFamily: "Pretendard-Regular",
                          fontSize: 24
                      ),
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
                        fontFamily: "Pretendard-Light",
                        fontSize: 18
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: dateControllers[currentPage],
                      style: const TextStyle(
                          fontFamily: "Pretendard-Regular",
                          fontSize: 24
                      ),
                    ),
                  ),
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
              ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: reviewControllers[currentPage],
              style: const TextStyle(
                  fontFamily: "Pretendard-Regular",
                  fontSize: 18
              ),
            ),
          ),
          const SizedBox(height: 100),
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
                  Get.off(() => const Create2());
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
                  Get.to(() => Create4());
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
