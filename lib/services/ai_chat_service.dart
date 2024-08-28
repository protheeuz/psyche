import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiChatService {
  final String apiUrl = dotenv.get('GEMINI_API_URL');
  final String apiKey = dotenv.get('API_KEY');

  Future<String> sendMessage(String message) async {
    final url = '$apiUrl?key=$apiKey';
    print('Request URL: $url');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      String aiResponse = jsonDecode(response.body)['candidates'][0]['content']['parts'][0]['text'];

      // revision: Menghapus bagian yang berulang
      aiResponse = _removeDuplicateSentences(aiResponse);

      return aiResponse;
    } else {
      throw Exception('Failed to communicate with AI: ${response.statusCode}');
    }
  }

  // revision: Fungsi untuk menghapus kalimat yang berulang
  String _removeDuplicateSentences(String text) {
    List<String> sentences = text.split(RegExp(r'(?<=[.!?])\s+')); // Pisahkan berdasarkan tanda baca
    Set<String> uniqueSentences = {};
    List<String> filteredSentences = [];

    for (var sentence in sentences) {
      // revision: Mengecek apakah kalimat sudah ada di set unik
      if (!uniqueSentences.contains(sentence.trim())) {
        uniqueSentences.add(sentence.trim());
        filteredSentences.add(sentence);
      }
    }

    return filteredSentences.join(' ');
  }
}