import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_core/src/model/user_position.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class ILocationService {
  Future<Address> findDataLocationFromLatLong(double latitude, double longitude);
  Future<List<Address>> findAddresByName(String nameAddress,String apikey);
  Marker createLocationMarker(double latitude,double longitude, BitmapDescriptor? icon, String idMarcador,
      String tiuloLocal, double hue);

 Future<AssetMapBitmap> markerPositionIconCostomizer(
    String caminho, double devicePixelRatio,Size? sizeIcon); 

 Stream<UserPosition> getUserRealTimeLocation();   
}