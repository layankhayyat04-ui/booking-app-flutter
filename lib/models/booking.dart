class Booking {
  final int id;
  final int venueId;
  final int courtNumber;
  final String playerName;
  final String playerEmail;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  Booking(
      {required this.id,
      required this.venueId,
      required this.courtNumber,
      required this.playerName,
      required this.playerEmail,
      required this.startTime,
      required this.endTime,
      required this.status});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      venueId: json['venue_id'] as int,
      courtNumber: json['court_number'] as int,
      playerName: json['player_name'] as String,
      playerEmail: json['player_email'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: json['status'] as String,
    );
  }

  bool get isConfirmed => status == 'confirmed';
}
