import 'dart:convert';

class Trip {
final  String type;
final  String price;
final  String timeTripe;
final  String distance;
final  int? quatitePersons;
  Trip({
    required this.type,
    required this.price,
    required this.timeTripe,
    required this.distance,
    required this.quatitePersons,
  });
  

  Trip copyWith({
    String? type,
    String? price,
    String? timeTripe,
    String? distance,
    int? quatitePersons,
  }) {
    return Trip(
      type: type ?? this.type,
      price: price ?? this.price,
      timeTripe: timeTripe ?? this.timeTripe,
      distance: distance ?? this.distance,
      quatitePersons: quatitePersons ?? this.quatitePersons,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'price': price,
      'timeTripe': timeTripe,
      'distance': distance,
      'quatitePersons': quatitePersons,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      type: map['type'] ?? '',
      price: map['price'] ?? '',
      timeTripe: map['timeTripe'] ?? '',
      distance: map['distance'] ?? '',
      quatitePersons: map['quatitePersons']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Trip(type: $type, price: $price, timeTripe: $timeTripe, distance: $distance, quatitePersons: $quatitePersons)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Trip &&
      other.type == type &&
      other.price == price &&
      other.timeTripe == timeTripe &&
      other.distance == distance &&
      other.quatitePersons == quatitePersons;
  }

  @override
  int get hashCode {
    return type.hashCode ^
      price.hashCode ^
      timeTripe.hashCode ^
      distance.hashCode ^
      quatitePersons.hashCode;
  }
}
