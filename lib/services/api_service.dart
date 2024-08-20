import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = dotenv.get('BACKEND_API_URL');

  Future<http.Response> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return response;
  }

  Future<http.Response> postData(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> registerUser(String email, String username, String fullName, String password) async {
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

  Future<http.Response> loginUser(String email, String password) async {
    final response = await postData('login/', {
      'email': email,
      'password': password,
    });
    return response;
  }
}