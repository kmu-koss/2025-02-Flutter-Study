class Work {
  final String imagePath;
  final String title;
  final String author;
  final String date;
  final String review;

  Work({
    required this.imagePath,
    required this.title,
    required this.author,
    required this.date,
    required this.review,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      imagePath: json['imagePath'] ?? 'assets/images/polygon.png',
      title: json['title'] ?? '제목 없음',
      author: json['author'] ?? '작가 없음',
      date: json['date'] ?? '날짜 없음',
      review: json['review'] ?? '...',
    );
  }
}
