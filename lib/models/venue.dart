class Venue {
  final int id;
  final String name;
  final String city;
  final int courts;

  Venue({
    required this.id,
    required this.name,
    required this.city,
    required this.courts,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as int,
      name: json['name'] as String,
      city: json['city'] as String,
      courts: json['courts'] as int,
    );
  }
}
