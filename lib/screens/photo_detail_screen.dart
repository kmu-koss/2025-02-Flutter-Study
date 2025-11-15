import 'package:flutter/material.dart';

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('하루 한 장'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ 임시 이미지 영역 (기능 없이 시각 확인용)
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    '이미지 미리보기',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '2025.11.12', // 임시 날짜
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              '기록 표시', // 임시 텍스트
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
