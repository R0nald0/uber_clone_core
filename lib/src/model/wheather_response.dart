import 'dart:convert';

class WhetherResponse {
   final Location location;
   final Current current;
  WhetherResponse({
    required this.location,
    required this.current,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location.toMap(),
      'current': current.toMap(),
    };
  }

  factory WhetherResponse.fromMap(Map<String, dynamic> map) {
    return WhetherResponse(
      location: Location.fromMap(map['location']),
      current: Current.fromMap(map['current']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WhetherResponse.fromJson(String source) => WhetherResponse.fromMap(json.decode(source));
}

class Location {
  final String name;
  final String region;
  final String country;
    Location({
    required this.name,
    required this.region,
    required this.country
  });



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'region': region,
      'country': country,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map['name'] ?? '',
      region: map['region'] ?? '',
      country: map['country'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source));
  Location copyWith({
    String? name,
    String? region,
    String? country    
  }) {
    return Location(
          name: name ?? this.name,
      region: region ?? this.region,
      country: country ?? this.country
    );
  }
}
class Current {
  final double tempC;
  final double tempF;
  Current({
    required this.tempC,
    required this.tempF,
  });

  Map<String, dynamic> toMap() {
    return {
      'tempC': tempC,
      'tempF': tempF,
    };
  }

  factory Current.fromMap(Map<String, dynamic> map) {
    return Current(
      tempC: map['tempC']?.toDouble() ?? 0.0,
      tempF: map['tempF']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Current.fromJson(String source) => Current.fromMap(json.decode(source));
}

