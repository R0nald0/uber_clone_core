import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_core/src/model/addres.dart';


class MapsCameraService {
  Future<void>  moveCamera(CameraPosition cameraPosition,Completer<GoogleMapController> controller) async{
      GoogleMapController controllerCamera = await controller.future;
      controllerCamera.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
   } 
   
   moverCameraBound( Address origem, Address destino,double padding, Completer<GoogleMapController> controller) async {
     
    double motLatitude = origem.latitude;
    double motLongitude = origem.longitude;

    double passLatitude = destino.latitude;
    double passLongitude = destino.longitude;

    double nLatitude, nLongitude, sLatitude, sLongitude;

    if (passLatitude <= motLatitude) {
      sLatitude = passLatitude;
      nLatitude = motLatitude;
    } else {
      sLatitude = motLatitude;
      nLatitude = passLatitude;
    }

    if (passLongitude <= motLongitude) {
      sLongitude = passLongitude;
      nLongitude = motLongitude;
    } else {
      sLongitude = motLongitude;
      nLongitude = passLongitude;
    }

  final latLngBounds = LatLngBounds(northeast: LatLng(nLatitude,nLongitude) ,southwest:LatLng( sLatitude,sLongitude)
    );
    
    GoogleMapController controllerBouds = await controller.future;
    controllerBouds
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, padding));
  }

}