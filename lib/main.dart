import 'package:flutter/material.dart';
import 'screens/venue_list_screen.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venue Booking',
      theme: ThemeData(
          colorSchemeSeed: const Color(0xFF39D98A), useMaterial3: true),
      home: const VenueListScreen(),
    );
  }
}
