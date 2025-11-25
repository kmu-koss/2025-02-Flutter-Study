import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haruharu/system/photo_entry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

const Color primaryColor = Color(0xFFB3E0FF);
const Color accentColor = Color(0xFF7AD1FF);
const Color lightBgColor = Color(0xFFF0F8FF);
const Color darkTextColor = Color(0xFF1A237E);
const Color inactiveColor = Color(0xFFDEDEDE);

class UploadScreen extends StatefulWidget {

  final PhotoEntry? initialEntry;

  const UploadScreen({super.key, this.initialEntry});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // File? _image;
  Uint8List? _image;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 💡 위젯이 생성될 때, initialEntry가 있으면 기존 데이터로 상태를 초기화합니다.
    if (widget.initialEntry != null) {
      final entry = widget.initialEntry!;
      _image = entry.imageBytes;
      // 날짜 문자열(예: '2025. 9. 28')을 DateTime 객체로 변환
      try {
        final parts = entry.date
            .split('.')
            .map((s) => int.tryParse(s.trim()))
            .toList();
        if (parts.length >= 3 && parts[0] != null && parts[1] != null &&
            parts[2] != null) {
          _selectedDate = DateTime(parts[0]!, parts[1]!, parts[2]!);
        }
      } catch (e) {
        // 날짜 변환 오류 시 기본값 사용
        _selectedDate = DateTime.now();
      }
      _noteController.text = entry.note;
    }
  }

  // 갤러리에서 사진 선택
  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // 웹 환경
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _image = bytes;
          // _imageFile = null;
        });
      } else {
        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();
        setState(() {
          _image = bytes;
          // _imageFile = file;
        });
      }
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
    final entry = PhotoEntry(
      imageBytes: _image,
      // 날짜 형식은 HomePage의 그룹화 로직과 맞춥니다. (예: 2025. 11. 25)
      date: _formattedDate.replaceAll('. ', '.'),
      note: _noteController.text,
    );
    // Navigator.pop에 결과 객체(entry)를 담아 반환
    Navigator.pop(context, entry);
  }

  String get _formattedDate {
    return "${_selectedDate.year}. ${_selectedDate.month}. ${_selectedDate
        .day}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: darkTextColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _saveEntry,
              style: TextButton.styleFrom(
                backgroundColor: accentColor,
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
                    color: lightBgColor,
                    child: const Center(
                        child: Text('사진', style: TextStyle(color: Colors.grey),
                        )
                    ),
                  )
                      : Image.memory(
                    _image!,
                    fit: BoxFit.cover,
                  )
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: lightBgColor,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickDate,
                    child: Text(
                      _formattedDate,
                      style: TextStyle(fontSize: 16, color: darkTextColor),
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
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveColor)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: accentColor)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}