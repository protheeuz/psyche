import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../repositories/education_repository.dart';
import '../services/youtube_service.dart';
import 'youtube_player_screen.dart';

class EducationVideoScreen extends StatefulWidget {
  const EducationVideoScreen({super.key});

  @override
  _EducationVideoScreenState createState() => _EducationVideoScreenState();
}

class _EducationVideoScreenState extends State<EducationVideoScreen> {
  final EducationRepository _educationRepository = EducationRepository();
  final YouTubeService _youTubeService = YouTubeService();
  late Map<String, List<String>> _videoSections;
  late final Map<String, String> _videoTitles = {};

  @override
  void initState() {
    super.initState();
    _videoSections = _educationRepository.getVideoEducation();
    _fetchVideoTitles();
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
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 16 / 13,
                ),
                itemCount: section.value.length,
                itemBuilder: (context, index) {
                  final videoUrl = section.value[index];
                  final videoId = YoutubePlayer.convertUrlToId(videoUrl)!;
                  final videoTitle = _videoTitles[videoId] ?? 'Menunggu...';
                  final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YouTubePlayerScreen(videoId: videoId, videoTitle: videoTitle),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0), // Adjust the border radius here
                            child: Image.network(
                              thumbnailUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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