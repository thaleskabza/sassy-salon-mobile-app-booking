import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sassy_salon_mobile_app_booking/screens/welcome_screen.dart';
import 'package:sassy_salon_mobile_app_booking/screens/booking_screen.dart';
import 'package:sassy_salon_mobile_app_booking/screens/view_bookings_screen.dart';

void main() {
  testWidgets('Welcome screen has two buttons and navigates properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: WelcomeScreen()),
    );

    // Verify the presence of buttons
    expect(find.text('Book Appointment'), findsOneWidget);
    expect(find.text('View Bookings'), findsOneWidget);

    // Tap Book Appointment button
    await tester.tap(find.text('Book Appointment'));
    await tester.pumpAndSettle();

    expect(find.byType(BookingScreen), findsOneWidget);

    // Navigate back to WelcomeScreen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap View Bookings button
    await tester.tap(find.text('View Bookings'));
    await tester.pumpAndSettle();

    expect(find.byType(ViewBookingsScreen), findsOneWidget);
  });
}
