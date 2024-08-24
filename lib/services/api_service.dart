import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = dotenv.get('BACKEND_API_URL');

  Future<http.Response> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return response;
  }

  Future<http.Response> postData(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> registerUser(
      String email, String username, String fullName, String password) async {
    final response = await postData('register/', {
      'email': email,
      'username': username,
      'full_name': fullName,
      'password': password,
    });

    print("Register response status: ${response.statusCode}");
    print("Register response body: ${response.body}");

    return response;
  }

  Future<http.Response> loginUser(String username, String password) async {
    final response = await postData('login/', {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(
          "Response data: $responseData"); // Tambahkan log untuk melihat respons

      int? userId = responseData['user_id']; // Pastikan ini ada dan tidak null
      if (userId == null) {
        print("Error: User ID not found in response");
        throw Exception("User ID not found in response");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('full_name', responseData['full_name']);
      await prefs.setString('access_token', responseData['access_token']);
    } else {
      print("Login failed with status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }

    return response;
  }

  Future<http.Response> submitScreeningResult(
      int score, String result, int userId) async {
    final response = await postData('screenings/', {
      'user_id': userId,
      'score': score,
      'result': result,
    });

    if (response.statusCode == 200) {
      print('Screening result submitted successfully');
    } else {
      print('Failed to submit screening result: ${response.body}');
    }

    return response;
  }

  Future<Map<String, dynamic>?> getLatestScreening(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/screenings/latest?user_id=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      final int score = result['score'];
      
      if (score > 27) {
        result['score'] = 27;
      }
      
      return result;
    } else {
      print('Failed to fetch latest screening: ${response.body}');
      return null;
    }
  }

  Future<void> submitNoteToBackend(String noteText, int userId) async {
    final response = await postData('notes/', {
      'note_text': noteText,
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      print('Note submitted successfully');
    } else {
      print('Failed to submit note: ${response.body}');
    }
  }
}
