import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  // Save user information
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

  // 🔧 Define this method to fix the error
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name'),
      'email': prefs.getString('user_email'),
      'cellphone': prefs.getString('user_cellphone'),
    };
  }

  // Store last selected service ID
  static Future<void> saveLastServiceId(String serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_service_id', serviceId);
  }

  static Future<String?> getLastServiceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_service_id');
  }

  // Cache bookings offline
  static Future<void> saveBookingList(List<dynamic> bookingsJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_bookings', jsonEncode(bookingsJson));
  }

  static Future<List<dynamic>> getCachedBookingList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cached_bookings');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return [];
  }

  // Clear everything (optional for debugging)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
