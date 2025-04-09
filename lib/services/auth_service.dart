import '../models/user.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email == 'teste@teste.com' && password == '123456';
  }

  Future<bool> register(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> recoverPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty;
  }
}
