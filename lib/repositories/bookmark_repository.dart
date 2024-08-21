import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark.dart';

class BookmarkRepository {
  Future<void> addBookmark(Bookmark bookmark, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks_$userId') ?? [];
    bookmarks.add(bookmark.toMap().toString());
    await prefs.setStringList('bookmarks_$userId', bookmarks);
  }

  Future<List<Bookmark>> getBookmarks(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks_$userId') ?? [];
    return bookmarks.map((bookmarkString) {
      final bookmarkMap = _stringToMap(bookmarkString);
      return Bookmark.fromMap(bookmarkMap);
    }).toList();
  }

  Map<String, String> _stringToMap(String bookmarkString) {
    final Map<String, String> resultMap = {};
    bookmarkString.substring(1, bookmarkString.length - 1).split(', ').forEach((element) {
      final keyValue = element.split(': ');
      resultMap[keyValue[0]] = keyValue[1];
    });
    return resultMap;
  }

  Future<void> removeBookmark(String content, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks_$userId') ?? [];

    // Cari bookmark yg memiliki content yang cocok dan hapus dari daftar
    bookmarks.removeWhere((bookmarkString) {
      final bookmarkMap = _stringToMap(bookmarkString);
      return bookmarkMap['content'] == content;
    });

    // Simpan perubahan ke SharedPreferences
    await prefs.setStringList('bookmarks_$userId', bookmarks);
  }
}