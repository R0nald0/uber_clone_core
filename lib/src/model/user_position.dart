

class UserPosition {
  final double latitude;
  final double longitude;
  final double? speed;
  final double? speedAccuracy;
  final DateTime? timeStamp;
  final double? altitude;
  final double? heading;
  final double? altitudeAccuracy;
  final double? headingAccuracy;
  
  UserPosition({
    required this.latitude,
    required this.longitude,
    this.speed,
    this.speedAccuracy,
    this.timeStamp,
    this.altitude,
    this.heading,
    this.altitudeAccuracy,
    this.headingAccuracy,
  });

 

}
