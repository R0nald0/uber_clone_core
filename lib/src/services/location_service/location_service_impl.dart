import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_core/src/core/exceptions/addres_exception.dart';
import 'package:uber_clone_core/src/core/logger/i_app_uber_log.dart';
import 'package:uber_clone_core/src/model/addres.dart';
import 'package:uber_clone_core/src/model/user_position.dart';
import 'package:uber_clone_core/src/repository/location_repository/i_location_repository.dart';
import 'package:uber_clone_core/src/services/location_service/i_location_service.dart';

class LocationServiceImpl implements ILocationService{
  
  final ILocationRepository _locationRepository;
  final IAppUberLog _log;

  LocationServiceImpl({
    required ILocationRepository locationRepositoryImpl,
    required IAppUberLog log
  }) : _locationRepository = locationRepositoryImpl,_log =log;

  @override
  Future<Address> findDataLocationFromLatLong(double latitude, double longitude) =>
      _locationRepository.setNameMyLocal(latitude, longitude);

  @override
  Future<List<Address>> findAddresByName(String nameAddress,String apikey) =>
      _locationRepository.findAddresByName(nameAddress,apikey);
      

  

 @override
  Marker createLocationMarker(double latitude,double longitude, BitmapDescriptor? icon, String idMarcador,
      String tiuloLocal, double hue) {
     try {
  return Marker(
     markerId: MarkerId(idMarcador),
     infoWindow: InfoWindow(title: tiuloLocal),
     position: LatLng(latitude, longitude),
     icon: icon ?? BitmapDescriptor.defaultMarkerWithHue(hue));
} on PlatformException catch (e,s) {
     const message = 'Erro ao criar marcador de posição';
     _log.erro(message,e,s);
     throw  AddresException(message: message);
} 
  }

@override
  Future<AssetMapBitmap> markerPositionIconCostomizer(
    String caminho, double devicePixelRatio,Size? sizeIcon) async {
    ImageConfiguration configuration = ImageConfiguration(size: sizeIcon ?? const Size(23, 23) );
    final pathImage = caminho;
    final assetBitMap = BitmapDescriptor.asset(configuration, pathImage);
    return assetBitMap;
  }

  @override
  Stream<UserPosition> getUserRealTimeLocation() => _locationRepository.getUserRealTimeLocation();

  
}
