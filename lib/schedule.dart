import 'package:flutter/material.dart';
import 'plusSchedule.dart';

class SchedulePage extends StatelessWidget {
  const  SchedulePage({super.key});

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
        actions: [
          Transform.translate(
            offset: Offset(-20, 0),
            child: IconButton(
              icon: Icon(Icons.add_circle),
              iconSize: 35,
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PlusSchedulePage()));},
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xffFDF7EF),
      body: const Center(
        child: Text(
          '시간표 페이지',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Color(0xffB8D8E6),
        selectedItemColor: Color(0xff2C3E50),
        unselectedItemColor: Color(0xff2C3E50),
        iconSize: 35,

        items: [
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, 3),
              child: Icon(Icons.calendar_month),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Transform. translate(
              offset: const Offset(0, 3),
              child: Icon(Icons.checklist),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Transform. translate(
              offset: const Offset(0, 3),
              child: Icon(Icons.school),
            ),
            label: ' ',
          ),
        ],
      ),
    );
  }
}