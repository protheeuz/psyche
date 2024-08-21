import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiChatService {
  final String apiUrl = dotenv.get('GEMINI_API_URL');  // Pastikan dotenv sudah diisi dengan URL yang benar
  final String apiKey = dotenv.get('API_KEY');         // API key Anda

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
      return jsonDecode(response.body)['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to communicate with AI: ${response.statusCode}');
    }
  }
}