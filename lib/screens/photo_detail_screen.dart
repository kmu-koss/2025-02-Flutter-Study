import 'dart:io';

import 'package:flutter/material.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String? imagePath;
  final String date;
  final String note;


  const PhotoDetailScreen({
    super.key,
    this.imagePath,
    required this.date,
    required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          // 수정 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              onPressed: () {
                // TODO: 수정 기능 (나중에)
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[400],
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                '수정',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // 삭제 버튼
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: TextButton(
              onPressed: () {
                // TODO: 삭제 기능 (나중에)
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 사진 영역 (정사각형) ──
            AspectRatio(
              aspectRatio: 1,
              child: ClipRect(
                child: imagePath == null || imagePath!.isEmpty
                    ? Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: Text(
                      '사진',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
                    : Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 날짜 + 추가사진 줄 ──
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(
                  top: BorderSide(color: Colors.grey),
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: 추가사진 기능 (나중에)
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      minimumSize: const Size(80, 32),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      '추가사진',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 일기 내용 라벨 ──
            const Text(
              '일기 내용',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // ── 일기 내용 본문 ──
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.grey[100],
                child: SingleChildScrollView(
                  child: Text(
                    note.isEmpty ? ' ' : note,
                    style: const TextStyle(fontSize: 16),
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
