import 'dart:convert';


class AddressDao {
  final int id;
  final String name;
  final String zipCode;
  final  bool favorite;
  final String lat;
  final String lon;   

  AddressDao({
    required this.id,
    required this.name,
    required this.zipCode,
    required this.favorite,
    required this.lat,
    required this.lon
  });


  AddressDao copyWith({
    int? id,
    String? name,
    String? zipCode,
    bool? favorite,
    String? lat,
    String? lon,
  }) {
    return AddressDao(
      id: id ?? this.id,
      name: name ?? this.name,
      zipCode: zipCode ?? this.zipCode,
      favorite: favorite ?? this.favorite,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'zipCode': zipCode,
      'favorite': favorite,
      'lat': lat,
      'lon': lon,
    };
  }

  factory AddressDao.fromMap(Map<String, dynamic> map) {
    return AddressDao(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      zipCode: map['zipCode'] ?? '',
      favorite: map['favorite'] ?? false,
      lat: map['lat'] ?? '',
      lon: map['lon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressDao.fromJson(String source) => AddressDao.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressDao(id: $id, name: $name, zipCode: $zipCode, favorite: $favorite, lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AddressDao &&
      other.id == id &&
      other.name == name &&
      other.zipCode == zipCode &&
      other.favorite == favorite &&
      other.lat == lat &&
      other.lon == lon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      zipCode.hashCode ^
      favorite.hashCode ^
      lat.hashCode ^
      lon.hashCode;
  }
}
