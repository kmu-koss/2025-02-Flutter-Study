class Work {
  final String exhibitionName;
  final String imagePath;
  final String title;
  final String author;
  final String date;
  final String review;
  final int like;

  Work({
    required this.exhibitionName,
    required this.imagePath,
    required this.title,
    required this.author,
    required this.date,
    required this.review,
    required this.like,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      exhibitionName: json['exhibitionName'] ?? '전시회 이름 없음',
      imagePath: json['imagePath'] ?? 'assets/images/polygon.png',
      title: json['title'] ?? '제목 없음',
      author: json['author'] ?? '작가 없음',
      date: json['date'] ?? '날짜 없음',
      review: json['review'] ?? '...',
      like: json['like'] ?? 0,
    );
  }
}
