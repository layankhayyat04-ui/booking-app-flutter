import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/pi_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  State<MyBookingsScreen> createState() => _S();
}

class _S extends State<MyBookingsScreen> {
  final ApiService _api = ApiService();
  late Future<List<Booking>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getBookings();
  }

  void _reload() => setState(() => _future = _api.getBookings());

  Future<void> _cancel(Booking b) async {
    try {
      await _api.cancelBooking(b.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cancelled.')));
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: FutureBuilder<List<Booking>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final bookings = snap.data ?? [];
          if (bookings.isEmpty)
            return const Center(child: Text('No bookings yet.'));
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, i) {
              final b = bookings[i];
              return ListTile(
                leading: Icon(
                    b.isConfirmed ? Icons.event_available : Icons.event_busy,
                    color: b.isConfirmed ? Colors.green : Colors.grey),
                title: Text('Court ${b.courtNumber} · ${b.playerName}'),
                subtitle: Text('${b.startTime.toLocal()} · ${b.status}'),
                trailing: b.isConfirmed
                    ? TextButton(
                        onPressed: () => _cancel(b),
                        child: const Text('Cancel'))
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
