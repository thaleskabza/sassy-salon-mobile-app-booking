// lib/screens/booking_screen.dart
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: const Center(
        child: Text(
          'Booking Screen Placeholder',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
