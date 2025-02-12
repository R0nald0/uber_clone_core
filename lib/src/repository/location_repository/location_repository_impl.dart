import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places/google_places.dart';
import 'package:uber_clone_core/src/core/exceptions/addres_exception.dart';
import 'package:uber_clone_core/src/core/logger/i_app_uber_log.dart';
import 'package:uber_clone_core/src/model/addres.dart';
import 'package:uber_clone_core/src/model/polyline_data.dart';
import 'package:uber_clone_core/src/model/user_position.dart';
import 'package:uber_clone_core/src/repository/location_repository/i_location_repository.dart';

class LocationRepositoryImpl implements ILocationRepository {
  final IAppUberLog _log;

  LocationRepositoryImpl({required IAppUberLog log}) : _log = log;
  @override
  Future<Address> setNameMyLocal(double latitude, double longitude) async {
    setLocaleIdentifier('pt_BR');
    final placeMarkers = await placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarkers.first;
    if (kDebugMode) {
      print(placeMark);
    }
    return Address(
        bairro: placeMark.subLocality ?? '',
        cep: placeMark.postalCode ?? '',
        cidade: placeMark.subLocality ?? '',
        latitude: latitude,
        longitude: longitude,
        nomeDestino:
            '${placeMark.thoroughfare},${placeMark.subLocality},${placeMark.subAdministrativeArea}',
        numero: placeMark.subThoroughfare ?? '',
        rua: placeMark.thoroughfare ?? '');
  }

  @override
  Future<List<Address>> findAddresByName(String nameAddres, String apikey) async {
    try {
      
      if (apikey.isEmpty) {
        throw AddresException(message: 'Api key não encotrado');
      } 

      final googlPlace = GooglePlaces(apikey);
      final search = await googlPlace.search.getTextSearch(nameAddres);

      if (search?.status == "REQUEST_DENIED") {
        throw AddresException(
            message: "Requisiçao para buscar a apid do google place negado");
      }

      final resultsSeaches = search?.results;

      if (resultsSeaches != null) {
        final adreess = resultsSeaches.map<Address>((element) {
          final location = element.geometry?.location;
          final fomatedAdres = element.formattedAddress ?? '';
          final namePlace = element.name ?? '';

          return Address(
            bairro: "",
            cep: "",
            cidade: "",
            latitude: location?.lat ?? 0.0,
            longitude: location?.lng ?? 0.0,
            nomeDestino: '$namePlace,$fomatedAdres',
            numero: '',
            rua: "",
          );
        }).toList();

        return adreess;
      }
      return <Address>[];
    } on AddresException catch (e, s) {
      _log.erro(e.message, e, s);
      throw AddresException(message: 'Erro ao buscar possivéis endereços...');
    }
  }

  /* Future<List<Address>> findAddresByName(String nameAddres) async {
    try {
      /* final apiKey = dotenv.env[''];
      if (apiKey == null) {
        throw AddresException(message: 'erroa ao buscar api key');
      }

      final googlPlace = GooglePlaces(apiKey);
      final search = await googlPlace.search.getTextSearch(nameAddres);
 */
      final locations = await locationFromAddress(nameAddres);

      /*   if (search?.status == "REQUEST_DENIED") {
        throw AddresException(
            message: "Requisiçao para buscar a apid do google place negado");
      } */
      if (locations.isNotEmpty) {
        final listAddress = <Address>[];
        for (var add in locations)  {
           final  addres  =  await setNameMyLocal(add.latitude, add.longitude);
           listAddress.add(addres);
        }        
      
        return listAddress;
      }

      /*  final resultsSeaches = search?.results;

      if (resultsSeaches != null) {
         final adreess = resultsSeaches.map<Address>((element) {
          final location = element.geometry?.location;
          final fomatedAdres = element.formattedAddress ?? '';
          final namePlace = element.name ?? '';

          return Address(
            bairro: "",
            cep: "",
            cidade: "",
            latitude: location?.lat ?? 0.0,
            longitude: location?.lng ?? 0.0,
            nomeDestino: '$namePlace,$fomatedAdres',
            numero: '',
            rua: "",
          );
        }).toList();

        return adreess;
      } */
      return <Address>[];
    } on AddresException catch (e, s) {
      _log.erro(e.message, e, s);
      throw AddresException(message: 'Erro ao buscar possivéis endereços...');
    }
  }
 */
  @override
  Future<PolylineData> getRouteTrace(Address myLocation, Address myDestination,
      Color lineColor, int widthLine, String? mapskey) async {
    if (mapskey == null) {
      throw AddresException(message: 'erroa ao buscar api key');
    }

    try {
      var poliCordernate = <LatLng>[];

      final polyline = PolylinePoints();
      final polylineResult = await polyline.getRouteBetweenCoordinates(
          googleApiKey: mapskey,
          request: PolylineRequest(
              origin: PointLatLng(myLocation.latitude, myLocation.longitude),
              destination:
                  PointLatLng(myDestination.latitude, myDestination.longitude),
              mode: TravelMode.driving));

      if (polylineResult.status == null ||
          polylineResult.status == 'REQUEST_DENIED') {
        throw AddresException(message: 'Requisicão Negada');
      }
      if (polylineResult.points.isNotEmpty) {
        for (var point in polylineResult.points) {
          poliCordernate.add(LatLng(point.latitude, point.longitude));
        }
      }
      final route = _createPolineRoute(poliCordernate, lineColor, widthLine);
      final polylineData = PolylineData(
          router: route,
          distanceBetween: polylineResult.distanceTexts?.first ?? '',
          durationBetweenPoints: polylineResult.durationTexts?.first ?? '',
          distanceInt: polylineResult.totalDistanceValue ?? 0,
          duration: polylineResult.totalDurationValue ?? 0);
      return polylineData;
    } on AddresException catch (e, s) {
      const message = 'erro ao buscar dados de rota';
      _log.erro(message, e, s);
      throw AddresException(message: message);
    }
  }

  Map<PolylineId, Polyline> _createPolineRoute(
      List<LatLng> poliCordernate, Color lineColor, int widthLine) {
    Map<PolylineId, Polyline> polylines = {};

    if (poliCordernate.isNotEmpty) {
      const id = PolylineId('poly');
      final poliRouter = Polyline(
          polylineId: id, color: lineColor, points: poliCordernate, width: 5);
      polylines[id] = poliRouter;
    }
    return polylines;
  }

  @override
  Stream<UserPosition> getUserRealTimeLocation() async* {
    LocationSettings settings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 5);

    final streamPostion =
        Geolocator.getPositionStream(locationSettings: settings);

    await for (var point in streamPostion) {
      yield UserPosition(
          latitude: point.latitude,
          longitude: point.longitude,
          altitude: point.altitude,
          altitudeAccuracy: point.altitudeAccuracy,
          heading: point.heading,
          headingAccuracy: point.headingAccuracy,
          speed: point.speed,
          speedAccuracy: point.speedAccuracy);
    }
  }
}
