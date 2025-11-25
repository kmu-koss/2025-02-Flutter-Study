import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:haruharu/system/detail_action.dart';
import 'package:haruharu/system/photo_entry.dart';

import 'upload_screen.dart';

const Color primaryColor = Color(0xFFB3E0FF);
const Color accentColor = Color(0xFF7AD1FF);
const Color lightBgColor = Color(0xFFF0F8FF);
const Color darkTextColor = Color(0xFF1A237E);
const Color inactiveColor = Color(0xFFDEDEDE);

class PhotoDetailScreen extends StatelessWidget {
  final Uint8List? imageBytes;
  final String date;
  final String note;
  final PhotoEntry originalEntry;


  const PhotoDetailScreen({
    super.key,
    this.imageBytes,
    required this.date,
    required this.note,
    required this.originalEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: darkTextColor),
        ),
        actions: [
          // 수정 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              onPressed: () async {
                final modifiedEntry = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadScreen(initialEntry: originalEntry),
                  ),
                );
                if (modifiedEntry != null && modifiedEntry is PhotoEntry) {
                  Navigator.pop(context, modifiedEntry);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: accentColor,
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
                Navigator.pop(context, DetailAction.delete);
              },
              style: TextButton.styleFrom(
                backgroundColor: accentColor,
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
            //사진
            AspectRatio(
              aspectRatio: 1,
              child: ClipRect(
                child: imageBytes == null || imageBytes!.isEmpty
                    ? Container(
                  color: lightBgColor,
                  child: const Center(
                    child: Text(
                      '사진',
                      style: TextStyle(color: darkTextColor),
                    ),
                  ),
                )
                    : Image.memory(
                  imageBytes!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            //날짜
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: lightBgColor,
              // decoration: BoxDecoration(
              //   color: Colors.grey[100],
              //   border: const Border(
              //     top: BorderSide(color: Colors.grey),
              //     bottom: BorderSide(color: Colors.grey),
              //   ),
              // ),
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

            // // 일기 내용 라벨
            // const Text(
            //   '일기 내용',
            //   style: TextStyle(color: Colors.grey),
            // ),
            // const SizedBox(height: 8),

            // 일기 내용 본문
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),

                color: inactiveColor,
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