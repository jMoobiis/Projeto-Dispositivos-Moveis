class User {
  final String name;
  final String email;
  final String phone;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone, 'password': password};
  }
}
