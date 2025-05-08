// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';
import '../models/booking_model.dart';

class ApiService {
  static const String baseUrl = 'https://sassy-salon-booking.vercel.app/api';

  static Future<List<ServiceModel>> fetchServices() async {
    final response = await http.get(Uri.parse('$baseUrl/services'));
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((json) => ServiceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  static Future<List<BookingModel>> fetchBookings() async {
    final now = DateTime.now();
    final from = now.subtract(Duration(days: 1)).toIso8601String();
    final to = now.add(Duration(days: 7)).toIso8601String();

    final response = await http.get(Uri.parse('$baseUrl/bookings?from=$from&to=$to'));
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((json) => BookingModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  static Future<BookingModel> bookService(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 201) {
      return BookingModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body)['error'] ?? 'Booking failed');
    }
  }
}
