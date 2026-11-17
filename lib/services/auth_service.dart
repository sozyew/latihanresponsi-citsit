import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyUsers = 'users';
  static const String _keyLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';

  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keyUsers) ?? '';

    if (existing.isNotEmpty) {
      final users = existing.split(',');
      for (final u in users) {
        if (u.split(':')[0] == username) {
          return false; // username sudah ada
        }
      }
    }

    final newEntry = '$username:$password';
    final updated = existing.isEmpty ? newEntry : '$existing,$newEntry';
    await prefs.setString(_keyUsers, updated);
    return true;
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keyUsers) ?? '';
    if (existing.isEmpty) return false;

    final users = existing.split(',');
    for (final u in users) {
      final parts = u.split(':');
      if (parts.length == 2 && parts[0] == username && parts[1] == password) {
        await prefs.setBool(_keyLoggedIn, true);
        await prefs.setString(_keyUsername, username);
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false);
    await prefs.remove(_keyUsername);
  }
}