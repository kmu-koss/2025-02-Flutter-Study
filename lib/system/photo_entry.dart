import 'dart:typed_data';

class PhotoEntry {
  final Uint8List? imageBytes;
  final String date;
  final String note;

  PhotoEntry({
    this.imageBytes,
    required this.date,
    required this.note,
  });
}