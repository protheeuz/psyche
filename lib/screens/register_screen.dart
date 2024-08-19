import 'package:flutter/material.dart';
import '../core/utils/validators.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/custom_button.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String fullName = _fullNameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      _showDialog("Error", "Kata Sandi tidak cocok");
      return;
    }

    if (email.isEmpty || username.isEmpty || fullName.isEmpty || password.isEmpty) {
      _showDialog("Error", "Semua field harus diisi");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.registerUser(email, username, fullName, password);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showDialog("Error", "Registrasi gagal. Coba lagi.");
      }
    } catch (e) {
      _showDialog("Error", "Terjadi kesalahan saat registrasi. Silakan coba lagi.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) => Validators.validateEmail(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _usernameController,
                labelText: 'Nama Pengguna',
                validator: (value) => Validators.validateNotEmpty(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _fullNameController,
                labelText: 'Nama Lengkap',
                validator: (value) => Validators.validateNotEmpty(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Kata Sandi',
                isPassword: true,
                validator: (value) => Validators.validateNotEmpty(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Konfirmasi Kata Sandi',
                isPassword: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Kata Sandi tidak cocok';
                  }
                  return Validators.validateNotEmpty(value);
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'Daftar',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _register();
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}