
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PolylineData {
  final Map<PolylineId, Polyline> router;
  final String distanceBetween;
  final String durationBetweenPoints;
  final int distanceInt;
  final int duration;
  PolylineData({
    required this.router,
    required this.distanceBetween,
    required this.durationBetweenPoints,
    required this.distanceInt,
    required this.duration,
  });

  PolylineData copyWith({
    Map<PolylineId, Polyline>? router,
    String? distanceBetween,
    String? durationBetweenPoints,
    int? distanceInt,
    int? duration,
  }) {
    return PolylineData(
      router: router ?? this.router,
      distanceBetween: distanceBetween ?? this.distanceBetween,
      durationBetweenPoints: durationBetweenPoints ?? this.durationBetweenPoints,
      distanceInt: distanceInt ?? this.distanceInt,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'router': router,
      'distanceBetween': distanceBetween,
      'durationBetweenPoints': durationBetweenPoints,
      'distanceInt': distanceInt,
      'duration': duration,
    };
  }

  factory PolylineData.fromMap(Map<String, dynamic> map) {
    return PolylineData(
      router: Map<PolylineId, Polyline>.from(map['router'] ?? const {}),
      distanceBetween: map['distanceBetween'] ?? '',
      durationBetweenPoints: map['durationBetweenPoints'] ?? '',
      distanceInt: map['distanceInt']?.toInt() ?? 0,
      duration: map['duration']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PolylineData.fromJson(String source) => PolylineData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PolylineData(router: $router, distanceBetween: $distanceBetween, durationBetweenPoints: $durationBetweenPoints, distanceInt: $distanceInt, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PolylineData &&
      mapEquals(other.router, router) &&
      other.distanceBetween == distanceBetween &&
      other.durationBetweenPoints == durationBetweenPoints &&
      other.distanceInt == distanceInt &&
      other.duration == duration;
  }

  @override
  int get hashCode {
    return router.hashCode ^
      distanceBetween.hashCode ^
      durationBetweenPoints.hashCode ^
      distanceInt.hashCode ^
      duration.hashCode;
  }
}
