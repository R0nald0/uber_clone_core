import 'package:flutter/material.dart';
import 'package:uber_clone_core/src/model/trip.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class ITripSerivce {
   Future<PolylineData> getRoute(Address myLocation, Address myDestination,Color lineColor, int widthLine,String? mapsKey);
   List<Trip> configureTripList(PolylineData data);

}