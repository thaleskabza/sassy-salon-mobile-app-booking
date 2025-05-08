// lib/screens/view_bookings_screen.dart
import 'package:flutter/material.dart';

class ViewBookingsScreen extends StatelessWidget {
  const ViewBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View My Bookings')),
      body: const Center(
        child: Text(
          'Bookings List Placeholder',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
