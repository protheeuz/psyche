import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/bookmark.dart';
import '../repositories/education_repository.dart';
import '../services/youtube_service.dart';
import '../repositories/bookmark_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'youtube_player_screen.dart';

class EducationVideoScreen extends StatefulWidget {
  const EducationVideoScreen({super.key});

  @override
  _EducationVideoScreenState createState() => _EducationVideoScreenState();
}

class _EducationVideoScreenState extends State<EducationVideoScreen> {
  final EducationRepository _educationRepository = EducationRepository();
  final YouTubeService _youTubeService = YouTubeService();
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  late Map<String, List<String>> _videoSections;
  late final Map<String, String> _videoTitles = {};
  late Map<String, bool> _bookmarkedVideos = {};
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _videoSections = _educationRepository.getVideoEducation();
    _fetchVideoTitles();
    _loadBookmarkedVideos();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
  }

  Future<void> _fetchVideoTitles() async {
    for (var section in _videoSections.entries) {
      final videoIds = section.value.map((url) => YoutubePlayer.convertUrlToId(url)!).toList();
      final titles = await _youTubeService.getVideoTitles(videoIds);
      setState(() {
        _videoTitles.addAll(titles);
      });
    }
  }

  Future<void> _loadBookmarkedVideos() async {
    if (_userId == null) return;

    final bookmarks = await _bookmarkRepository.getBookmarks(_userId!);
    setState(() {
      for (var bookmark in bookmarks) {
        if (bookmark.type == 'video') {
          _bookmarkedVideos[bookmark.content] = true;
        }
      }
    });
  }

  Future<void> _toggleBookmark(String videoId, String title) async {
    if (_userId == null) return;

    final isBookmarked = _bookmarkedVideos[videoId] ?? false;
    final videoUrl = 'https://www.youtube.com/watch?v=$videoId';

    if (isBookmarked) {
      // Hapus bookmark
      await _bookmarkRepository.removeBookmark(videoId, _userId!);
      setState(() {
        _bookmarkedVideos[videoId] = false;
      });
    } else {
      // Tambahkan bookmark
      final bookmark = Bookmark(
        title: title,
        url: videoUrl,
        type: 'video',
        date: DateTime.now(),
        content: videoId,
      );
      await _bookmarkRepository.addBookmark(bookmark, _userId!);
      setState(() {
        _bookmarkedVideos[videoId] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi Video'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _videoSections.entries.length,
        itemBuilder: (context, sectionIndex) {
          var section = _videoSections.entries.elementAt(sectionIndex);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  section.key,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 16 / 13,
                ),
                itemCount: section.value.length,
                itemBuilder: (context, index) {
                  final videoUrl = section.value[index];
                  final videoId = YoutubePlayer.convertUrlToId(videoUrl)!;
                  final videoTitle = _videoTitles[videoId] ?? 'Menunggu...';
                  final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
                  final isBookmarked = _bookmarkedVideos[videoId] ?? false;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YouTubePlayerScreen(
                              videoId: videoId, videoTitle: videoTitle),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image.network(
                                  thumbnailUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                videoTitle,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: -20,
                          right: -20,
                          child: IconButton(
                            icon: Icon(
                              size: 30,
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked ? Colors.yellow : Colors.green,
                            ),
                            onPressed: () => _toggleBookmark(videoId, videoTitle),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}