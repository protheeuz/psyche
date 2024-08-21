import 'package:flutter/material.dart';
import '../repositories/bookmark_repository.dart';
import '../models/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'youtube_player_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Bookmark> _bookmarks = [];
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  int? _userId;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) => _loadUserIdAndBookmarks());
  }

  Future<void> _loadUserIdAndBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');

    if (_userId != null) {
      final bookmarks = await _bookmarkRepository.getBookmarks(_userId!);
      setState(() {
        _bookmarks = bookmarks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Bookmark'),
      ),
      body: ListView.builder(
        itemCount: _bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = _bookmarks[index];
          final formattedDate = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(bookmark.date);
          final thumbnailUrl = bookmark.type == 'video' ? 'https://img.youtube.com/vi/${bookmark.content}/0.jpg' : null;

          return ListTile(
            leading: thumbnailUrl != null
                ? Image.network(
                    thumbnailUrl,
                    width: 100,
                    fit: BoxFit.cover,
                    height: 100,
                  )
                : null,
            title: Text(bookmark.title),
            subtitle: Text('${bookmark.type.toUpperCase()} - $formattedDate'),
            onTap: () {
              if (bookmark.type == 'video') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YouTubePlayerScreen(
                      videoId: bookmark.content,
                      videoTitle: bookmark.title,
                    ),
                  ),
                );
              } else if (bookmark.type == 'audio') {
                // Implementasikan logika navigasi ke audio player
              }
            },
          );
        },
      ),
    );
  }
}
