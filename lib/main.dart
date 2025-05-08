import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(SassySalonApp());

class SassySalonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sassy Salon',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
