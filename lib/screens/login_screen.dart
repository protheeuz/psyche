import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../core/utils/validators.dart';
import '../core/widgets/custom_loading.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final ApiService _apiService = ApiService();

  void _printLog() {
    print("Starting login process...");
  }

  void _printPostLog() {
    print("Finished login process.");
  }

  Future<void> _login() async {
    _printLog();

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showCupertinoDialog("Error", "Username dan password tidak boleh kosong");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.loginUser(username, password);
      print("Login response status: ${response.statusCode}");
      print("Login response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        int? userId = responseBody['user_id'];
        if (userId == null) {
          print("Error: User ID not found in response");
          throw Exception("User ID not found in response");
        }
        print("User ID: $userId");
        String fullName = responseBody['full_name'];
        String accessToken = responseBody['access_token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('user_id', userId);
        await prefs.setString('full_name', fullName);
        await prefs.setString('access_token', accessToken);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        _showCupertinoDialog(
            "Error", "Gagal login. Username atau password salah.");
      }
    } catch (e) {
      print("Login exception: $e");
      _showCupertinoDialog(
          "Error", "Terjadi kesalahan saat login. Silakan coba lagi.");
    }

    _printPostLog();

    setState(() {
      _isLoading = false;
    });
  }

  void _showCupertinoDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Masuk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Poppins',
                  ),
                ),
                Image.asset(
                  "assets/images/login.jpg",
                  height: 250,
                  width: double.infinity,
                ),
                const Text(
                  "Dapatkan akses Aplikasi dari.",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Masukkan Username',
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Kata Sandi",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Masukkan Kata Sandi',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 17,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: _login,
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF5B86E5),
                          Color(0xFF36D1DC),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CustomLoading(
                              isLoading: true,
                              size: 65,
                            )
                          : const Text(
                              "Masuk",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Belum punya akun?",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          "Daftar di sini",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Color(0xFF5B86E5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
