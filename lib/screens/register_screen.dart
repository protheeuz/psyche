import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/utils/validators.dart';
import '../core/widgets/custom_loading.dart';
import '../core/widgets/custom_text_field.dart';
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
  final ApiService _apiService = ApiService();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isPasswordMatch = true;

  @override
  void initState() {
    super.initState();

    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _isPasswordMatch = _passwordController.text == _confirmPasswordController.text;
        });
      }
    });
  }

  void _checkPasswordMatch(String value) {
    setState(() {
      _isPasswordMatch = _passwordController.text == value;
    });
  }

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String fullName = _fullNameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        _isPasswordMatch = false;
      });
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
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        _showDialog("Error", "Registrasi gagal. Coba lagi.");
      }
    } catch (e) {
      print('Error during registration: $e');
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

  void _showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Registrasi Berhasil"),
          content: const Text("Akun Anda telah berhasil dibuat."),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.pushReplacementNamed(context, '/login'); // Arahkan ke halaman login
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
                const SizedBox(height: 20),
                const Text(
                  "Daftar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Poppins',
                  ),
                ),
                Image.asset(
                  "assets/images/register.jpg",
                  height: 250,
                  width: double.infinity,
                ),
                const Text(
                  "Buat akun baru di sini",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Masukkan Email',
                  validator: (value) => Validators.validateEmail(value),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Masukkan Username',
                  validator: (value) => Validators.validateNotEmpty(value),
                  textInputAction: TextInputAction.next,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _fullNameController,
                  labelText: 'Nama Lengkap',
                  validator: (value) => Validators.validateNotEmpty(value),
                  textInputAction: TextInputAction.next,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Kata Sandi',
                  isPassword: true,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      size: 17,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) => Validators.validateNotEmpty(value),
                  textInputAction: TextInputAction.next,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Konfirmasi Kata Sandi',
                  isPassword: true,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      size: 17,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Kata Sandi tidak cocok';
                    }
                    return null;
                  },
                  focusNode: _confirmPasswordFocusNode,
                  onChanged: _checkPasswordMatch,
                  textInputAction: TextInputAction.done,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                if (!_isPasswordMatch)
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "(*) Kata Sandi tidak cocok",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _register,
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF5B86E5),
                          Color(0xFF36D1DC)
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
                          ? CustomLoading(isLoading: _isLoading, size: 65) // Tampilkan loading di tengah tombol
                          : const Text(
                              "Daftar",
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah punya akun? ",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.grey),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        "Masuk di sini",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF5B86E5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}