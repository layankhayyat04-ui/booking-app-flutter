import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../services/pi_service.dart';

class BookingFormScreen extends StatefulWidget {
  final Venue venue;
  const BookingFormScreen({super.key, required this.venue});
  @override
  State<BookingFormScreen> createState() => _S();
}

class _S extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  int _court = 1;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 18, minute: 0);
  int _hours = 1;
  bool _submitting = false;

  DateTime get _start =>
      DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
  DateTime get _end => _start.add(Duration(hours: _hours));

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await _api.createBooking(
        venueId: widget.venue.id,
        courtNumber: _court,
        playerName: _name.text.trim(),
        playerEmail: _email.text.trim(),
        startTime: _start,
        endTime: _end,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Booking confirmed!')));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.venue.name}')),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Your name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 12),
          TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Your email'),
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Valid email required'
                  : null),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _court,
            decoration: const InputDecoration(labelText: 'Court number'),
            items: List.generate(widget.venue.courts, (i) => i + 1)
                .map((n) => DropdownMenuItem(value: n, child: Text('Court $n')))
                .toList(),
            onChanged: (v) => setState(() => _court = v ?? 1),
          ),
          const SizedBox(height: 12),
          ListTile(
              title: const Text('Date'),
              subtitle: Text('${_date.year}-${_date.month}-${_date.day}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final p = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)));
                if (p != null) setState(() => _date = p);
              }),
          ListTile(
              title: const Text('Start time'),
              subtitle: Text(_time.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final p =
                    await showTimePicker(context: context, initialTime: _time);
                if (p != null) setState(() => _time = p);
              }),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _hours,
            decoration: const InputDecoration(labelText: 'Duration (hours)'),
            items: [1, 2, 3]
                .map((h) => DropdownMenuItem(value: h, child: Text('$h h')))
                .toList(),
            onChanged: (v) => setState(() => _hours = v ?? 1),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Confirm booking'),
          ),
        ]),
      ),
    );
  }
}
