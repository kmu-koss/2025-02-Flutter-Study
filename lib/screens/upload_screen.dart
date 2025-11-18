import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  // 갤러리에서 사진 선택
  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 날짜 선택
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 저장(지금은 일단 뒤로가기만)
  void _saveEntry() {
    // TODO: 실제 저장 로직 넣기 (예: DB, 리스트 등)
    Navigator.pop(context);
  }

  String get _formattedDate {
    return "${_selectedDate.year}. ${_selectedDate.month}. ${_selectedDate.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _saveEntry,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[400],
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                '저장',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: AspectRatio(
                aspectRatio: 1,
                child: _image == null
                    ? Container(
                      color: Colors.grey[100],
                      child: const Center(
                          child: Text('사진', style: TextStyle(color: Colors.grey),
                          )
                      ),
                )
                    : Image.file(_image!, fit: BoxFit.cover,
                )
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.grey[100],
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickDate,
                    child: Text(
                      _formattedDate,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // 추가 사진 버튼 만들어야함

                ],
              ),
            ),
            const SizedBox(height: 16,),



            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
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
