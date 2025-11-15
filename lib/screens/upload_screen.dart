import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('업로드'),
        actions: [
          TextButton(
            onPressed: () {
              //
            },
            child: const Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              height: 250,
              color: Colors.grey[200],
              child: const Center(child: Text('사진 추가')),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("2025. 11. 10", style: TextStyle(fontSize: 16)),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                hintText: '일기 내용을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
