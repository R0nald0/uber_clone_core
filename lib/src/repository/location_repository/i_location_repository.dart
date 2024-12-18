import 'dart:ui';

import 'package:uber_clone_core/src/model/user_position.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class ILocationRepository {
  Future<Address> setNameMyLocal(double latitude, double longitude);
  Future<List<Address>> findAddresByName(String nameAddres, String apikey);
  Future<PolylineData> getRouteTrace(Address myLocation, Address myDestination,
      Color lineColor, int widthLine, String? mapskey);
  Stream<UserPosition> getUserRealTimeLocation();    
}
