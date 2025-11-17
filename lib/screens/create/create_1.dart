import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../exhibition/exhibition_main.dart';

class Create1 extends StatelessWidget {
  const Create1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 130, top: 50),
            child: Text(
              "감상한 전시회의 정보를\n입력해주세요!",
              style: TextStyle(
                fontFamily: "Pretendard-SemiBold",
                fontSize: 24
              ),
            ),
          ),

          const SizedBox(height: 50),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "감상한 장소",
                  style: TextStyle(
                      fontFamily: "Pretendard-Regular",
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 30),
                child: SearchBar(
                  leading: Icon(Icons.search),
                  constraints: BoxConstraints(maxWidth: 200, minHeight: 50),
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                  hintText: "그라운드시소 서촌",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "감상한 전시회",
                  style: TextStyle(
                      fontFamily: "Pretendard-Regular",
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 30),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "이경준 사진전 : 원 스텝 어웨이"
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "감상한 날짜",
                  style: TextStyle(
                      fontFamily: "Pretendard-Regular",
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text("날짜 선택")
                ),
              ),
            ],
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
                  Get.off(() => const ExhibitionMain());
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
                  Get.to(() => const ExhibitionMain());
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

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
}
