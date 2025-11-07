import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('하루 한 장'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRecallSection(),
          const SizedBox(height: 16),
          _buildPhotoSection('25년 9월'),
          const SizedBox(height: 16),
          _buildPhotoSection('25년 8월'),
          const SizedBox(height: 16),
          _buildPhotoSection('25년 7월'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 새 기록 추가
        },
        child: const Icon(Icons.add),
      ),
    );
  }


  Widget _buildRecallSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('회상', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _RecallBox(title: '일 년 전 오늘'),
              _RecallBox(title: '한 달 전 오늘'),
              _RecallBox(title: '일주일 전 오늘'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3열
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  index == 0 ? '' : '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RecallBox extends StatelessWidget {
  final String title;
  const _RecallBox({required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ),
      ),
    );
  }
}

