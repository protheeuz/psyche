import 'package:http/http.dart' as http;
import 'dart:convert';

class AiChatService {
  final String apiKey = 'YOUR_API_KEY_HERE';

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('https://api.your-ai-service.com/chat'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to communicate with AI');
    }
  }
}
