import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _loggedInKey = 'loggedIn';

  Future<void> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loggedInKey, true);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
}
