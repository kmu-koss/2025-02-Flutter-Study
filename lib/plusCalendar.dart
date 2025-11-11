import 'package:flutter/material.dart';

class PlusCalendarPage extends StatelessWidget {
  const  PlusCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDF7EF),
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
      backgroundColor: Color(0xffFDF7EF),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '일정'
                ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                decoration: InputDecoration(
                    labelText: '날짜'
                ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                decoration: InputDecoration(
                    labelText: '장소'
                ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                decoration: InputDecoration(
                    labelText: '메모'
                ),
              ),
            ),
            const SizedBox(height: 300,),
            SizedBox(
                height: 30,
                width: 120,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffA8C7E0),
                      foregroundColor: Color(0xff2C3E50),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('저장')
                )
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 30,
                width: 120,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffD5D5D5),
                      foregroundColor: Color(0xff2C3E50),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    elevation: 5,
                  ),
                  child: const Text('취소')
                )
            )
          ],
        )
      ),
    );
  }
}