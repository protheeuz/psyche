class User {
  final String id; // Menggunakan 'id' bukan 'userId'
  final String email;
  final String username;
  final String fullName; // Menggunakan 'fullName' untuk nama lengkap

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
  });

  // Fungsi untuk membuat User dari response JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
    );
  }
}