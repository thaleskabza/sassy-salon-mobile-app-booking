import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'view_bookings_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_screen_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/images/ScutumCodicisLogo.png', height: 120),
              const SizedBox(height: 16),
              const Text(
                'Sassy Melanin',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 139, 129, 158),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Book Appointment'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookingScreen()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.list_alt),
                      label: const Text('View Bookings'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ViewBookingsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  '✨ Where Beauty Meets Culture ✨',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
