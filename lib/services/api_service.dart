import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = dotenv.get('BACKEND_API_URL');

  /// Fetch data from the given endpoint using a GET request
  Future<http.Response> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return response;
  }

  /// Send data to the given endpoint using a POST request
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

  /// Register a new user
  Future<http.Response> registerUser(String email, String username, String password) async {
    final response = await postData('register/', {
      'email': email,
      'username': username,
      'password': password,
    });
    return response;
  }

  /// Log in a user
  Future<http.Response> loginUser(String email, String password) async {
    final response = await postData('login/', {
      'email': email,
      'password': password,
    });
    return response;
  }

  // Add more methods for other API calls as needed
}