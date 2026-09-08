import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venue.dart';
import '../models/booking.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl =
      'https://listing-consequence-tech-discussions.trycloudflare.com';

  Future<List<Venue>> getVenues() async {
    final res = await http.get(Uri.parse('$baseUrl/venues'),
        headers: {'bypass-tunnel-reminder': 'true'});
    if (res.statusCode != 200) throw ApiException(res.statusCode, _err(res));
    return (jsonDecode(res.body) as List)
        .map((e) => Venue.fromJson(e))
        .toList();
  }

  Future<List<Booking>> getBookings({int? venueId}) async {
    final uri = venueId == null
        ? Uri.parse('$baseUrl/bookings')
        : Uri.parse('$baseUrl/bookings?venue_id=$venueId');
    final res =
        await http.get(uri, headers: {'bypass-tunnel-reminder': 'true'});
    if (res.statusCode != 200) throw ApiException(res.statusCode, _err(res));
    return (jsonDecode(res.body) as List)
        .map((e) => Booking.fromJson(e))
        .toList();
  }

  Future<Booking> createBooking(
      {required int venueId,
      required int courtNumber,
      required String playerName,
      required String playerEmail,
      required DateTime startTime,
      required DateTime endTime}) async {
    final res = await http.post(Uri.parse('$baseUrl/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'bypass-tunnel-reminder': 'true'
        },
        body: jsonEncode({
          'venue_id': venueId,
          'court_number': courtNumber,
          'player_name': playerName,
          'player_email': playerEmail,
          'start_time': startTime.toUtc().toIso8601String(),
          'end_time': endTime.toUtc().toIso8601String()
        }));
    if (res.statusCode != 201) throw ApiException(res.statusCode, _err(res));
    return Booking.fromJson(jsonDecode(res.body));
  }

  Future<void> cancelBooking(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/bookings/$id'),
        headers: {'bypass-tunnel-reminder': 'true'});
    if (res.statusCode != 200) throw ApiException(res.statusCode, _err(res));
  }

  String _err(http.Response res) {
    try {
      return (jsonDecode(res.body) as Map)['error'] ?? 'Error';
    } catch (_) {
      return 'Error (${res.statusCode})';
    }
  }
}
