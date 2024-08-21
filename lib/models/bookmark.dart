class Bookmark {
  final String title;
  final String url;
  final String type; // Bisa 'video' atau 'audio'
  final DateTime date;
  final String content; // Tambahkan variabel 'content' di sini

  Bookmark({
    required this.title,
    required this.url,
    required this.type,
    required this.date,
    required this.content, // Pastikan 'content' dimasukkan dalam konstruktor
  });

  Map<String, String> toMap() {
    return {
      'title': title,
      'url': url,
      'type': type,
      'date': date.toIso8601String(),
      'content': content, // Sertakan 'content' di dalam peta
    };
  }

  factory Bookmark.fromMap(Map<String, String> map) {
    return Bookmark(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      type: map['type'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      content: map['content'] ?? '', // Ambil 'content' dari peta
    );
  }
}