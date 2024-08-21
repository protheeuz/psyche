import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YouTubeService {
  final String apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';

  Future<Map<String, String>> getVideoTitles(List<String> videoIds) async {
    final ids = videoIds.join(',');
    final url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$ids&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      Map<String, String> titles = {};
      for (var item in jsonData['items']) {
        final id = item['id'];
        final title = item['snippet']['title'];
        titles[id] = title;
      }
      return titles;
    } else {
      return {};
    }
  }
}