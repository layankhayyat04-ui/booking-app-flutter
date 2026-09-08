import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../services/pi_service.dart';
import 'booking_form_screen.dart';
import 'my_bookings_screen.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});
  @override
  State<VenueListScreen> createState() => _S();
}

class _S extends State<VenueListScreen> {
  final ApiService _api = ApiService();
  late Future<List<Venue>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getVenues();
  }

  void _reload() => setState(() => _future = _api.getVenues());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues'), actions: [
        IconButton(
            icon: const Icon(Icons.event_note),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MyBookingsScreen()));
            })
      ]),
      body: FutureBuilder<List<Venue>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final venues = snap.data ?? [];
          if (venues.isEmpty)
            return const Center(child: Text('No venues yet.'));
          return ListView.builder(
            itemCount: venues.length,
            itemBuilder: (context, i) {
              final v = venues[i];
              return ListTile(
                leading: const Icon(Icons.sports_tennis),
                title: Text(v.name),
                subtitle: Text('${v.city} · ${v.courts} courts'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BookingFormScreen(venue: v))),
              );
            },
          );
        },
      ),
    );
  }
}
