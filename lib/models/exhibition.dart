class Exhibition {
  final String name;
  final String imagePath;
  final String visitedDate;
  final String recordedWork;

  Exhibition({
    required this.name,
    required this.imagePath,
    required this.visitedDate,
    required this.recordedWork,
  });

  factory Exhibition.fromJson(Map<String, dynamic> json) {
    return Exhibition(
      name: json['name'] ?? '이름 없음',
      imagePath: json['imagePath'] ?? 'assets/images/polygon.png',
      visitedDate: json['visitedDate'] ?? '날짜 없음',
      recordedWork: json['recordedWork'] ?? '0개',
    );
  }
}
