import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const _kLoggedIn = 'logged_in';
  static const _kLevel = 'kazakh_level';
  static const _kGoal = 'daily_goal_minutes';
  static const _kEmail = 'auth_email';
  static const _kPassHash = 'auth_pass_hash';
  static const _kFirstName = 'first_name';
  static const _kLastName = 'last_name';

  static Future<bool> isLoggedIn() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kLoggedIn, value);
  }

  static Future<void> saveCredentials({
    required String email,
    required String passwordHash,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kEmail, email);
    await p.setString(_kPassHash, passwordHash);
  }

  static Future<String?> getEmail() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kEmail);
  }

  static Future<String?> getPasswordHash() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kPassHash);
  }

  static Future<String?> getLevel() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kLevel);
  }

  static Future<void> setLevel(String level) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLevel, level);
  }

  static Future<int?> getGoalMinutes() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_kGoal);
  }

  static Future<void> setGoalMinutes(int minutes) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kGoal, minutes);
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kLoggedIn, false);
  }

  static Future<void> saveProfile({
    required String firstName,
    required String lastName,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kFirstName, firstName);
    await p.setString(_kLastName, lastName);
  }

  static Future<String?> getFirstName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kFirstName);
  }

  static Future<String?> getLastName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kLastName);
  }
}
