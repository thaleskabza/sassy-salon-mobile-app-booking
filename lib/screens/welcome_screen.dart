// screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'view_bookings_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sassy Melanin')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Book Appointment'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingScreen()),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('View Bookings'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewBookingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
