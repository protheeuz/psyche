class Bookmark {
  final String title;
  final String url;
  final String type;
  final DateTime date;
  final String content; 

  Bookmark({
    required this.title,
    required this.url,
    required this.type,
    required this.date,
    required this.content,
  });

  Map<String, String> toMap() {
    return {
      'title': title,
      'url': url,
      'type': type,
      'date': date.toIso8601String(),
      'content': content, 
    };
  }

  factory Bookmark.fromMap(Map<String, String> map) {
    return Bookmark(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      type: map['type'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      content: map['content'] ?? '',
    );
  }
}