import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uber_clone_core/src/model/tipo_viagem.dart';
import 'package:uber_clone_core/src/model/trip.dart';
import 'package:uber_clone_core/src/repository/location_repository/i_location_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class TripService implements ITripSerivce {
  final ILocationRepository _locationRepositoryImpl;


  TripService({
    required ILocationRepository locationRepositoryImpl, 
  })  : _locationRepositoryImpl = locationRepositoryImpl;

  @override
  Future<PolylineData> getRoute(Address myLocation, Address myDestination,
          Color lineColor, int widthLine, String? mapsKey) =>
      _locationRepositoryImpl.getRouteTrace(
          myLocation, myDestination, lineColor, widthLine, mapsKey);

  @override
  List<Trip> configureTripList(PolylineData data) {
    final distanceBetweenPoint = data.distanceInt.toDouble();
    final priceUberX =
        _calcularValorVieagem(distanceBetweenPoint, TipoViagem.uberX);
    final priceMoto =
        _calcularValorVieagem(distanceBetweenPoint, TipoViagem.uberMoto);

    return [
      Trip(
          type: 'UberX',
          price: priceUberX,
          timeTripe: data.durationBetweenPoints,
          distance: data.distanceBetween,
          quatitePersons: 4),
      Trip(
          type: 'Uber Moto ',
          price: priceMoto,
          timeTripe: data.durationBetweenPoints,
          distance: data.distanceBetween,
          quatitePersons: null)
    ];
  }

  String _calcularValorVieagem(
      double distanceBetweenPoint, TipoViagem tipoViagem) {
    final taxaCorrida = tipoViagem == TipoViagem.uberX ? 4 : 2;
    double distanciaKm = distanceBetweenPoint / 1000;
    double valorDacorrida = distanciaKm * taxaCorrida;

    String valorCobrado = _formatarValor(valorDacorrida);

    return valorCobrado;
  }

  String _formatarValor(double unFormatedValue) {
    var valor = NumberFormat('##,##0.00', 'pt-BR');
    String total = valor.format(unFormatedValue);
    return total;
  }
}
