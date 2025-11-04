import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const  SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간표'),
        backgroundColor: const Color(0xffB8D8E6),
      ),
      backgroundColor: const Color(0xffFDF7EF),
      body: const Center(
        child: Text(
          '시간표 페이지',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}