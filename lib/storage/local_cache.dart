import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static Future<void> saveUserInfo({
    required String name,
    required String email,
    required String cellphone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_cellphone', cellphone);
  }

  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name'),
      'email': prefs.getString('user_email'),
      'cellphone': prefs.getString('user_cellphone'),
    };
  }

  static Future<void> saveLastServiceId(String serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_service_id', serviceId);
  }

  static Future<String?> getLastServiceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_service_id');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
