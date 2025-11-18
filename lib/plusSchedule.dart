import 'package:flutter/material.dart';

class PlusSchedulePage extends StatelessWidget {
  const PlusSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFDF7EF),
        title: Row(
          children: [
            Image.asset(
              'assets/png/mainicon.png',
              height: 60,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xffFDF7EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: TextField(
                decoration: InputDecoration(labelText: '강의'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: TextField(
                decoration: InputDecoration(labelText: '날짜'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: TextField(
                decoration: InputDecoration(labelText: '강의실'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: TextField(
                decoration: InputDecoration(labelText: '교수'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: TextField(
                decoration: InputDecoration(labelText: '메모'),
              ),
            ),
            const Spacer(), // 화면 남는 공간을 아래 버튼으로 밀어줌
            SizedBox(
              height: 30,
              width: 120,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffA8C7E0),
                  foregroundColor: const Color(0xff2C3E50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: const Text('저장'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 30,
              width: 120,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffD5D5D5),
                  foregroundColor: const Color(0xff2C3E50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: const Text('취소'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}