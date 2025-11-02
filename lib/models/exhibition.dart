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
      name: json['name'],
      imagePath: json['imagePath'],
      visitedDate: json['visitedDate'],
      recordedWork: json['recordedWork'],
    );
  }
}
