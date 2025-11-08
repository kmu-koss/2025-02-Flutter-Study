class Exhibition {
  final String imagePath;
  final String name;
  final String visitedDate;
  final String recordedWork;

  Exhibition({
    required this.imagePath,
    required this.name,
    required this.visitedDate,
    required this.recordedWork,
  });

  factory Exhibition.fromJson(Map<String, dynamic> json) {
    return Exhibition(
      imagePath: json['imagePath'] ?? 'assets/images/polygon.png',
      name: json['name'] ?? '이름 없음',
      visitedDate: json['visitedDate'] ?? '날짜 없음',
      recordedWork: json['recordedWork'] ?? '0개',
    );
  }
}
