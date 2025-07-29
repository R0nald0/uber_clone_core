import 'dart:developer';

import 'package:uber_clone_core/src/core/exceptions/repository_exception.dart';
import 'package:uber_clone_core/src/core/restclient/impl/wheather_rest_client.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';
import 'package:uber_clone_core/src/model/wheather_response.dart';
import 'package:uber_clone_core/src/repository/wheather_repository/whether_repository.dart';

import '../../../core/restclient/uber_clone_rest_client.dart';

class WheatherRepositoryImpl implements IWheatherRepository {
  final UberCloneRestClient _wheatherRestClient;

  WheatherRepositoryImpl({required WhetherRestClientImpl wheatherRestClient})
      : _wheatherRestClient = wheatherRestClient;

  @override
  Future<WhetherResponse> getWhetherByLocation(String region, int day) async {
    try {
      final UberCloneResponse(:data) = await _wheatherRestClient
          .get('/forecast.json', queryParameters: {'q': region, 'days': day});
      return WhetherResponse.fromMap(data);
    } on Exception catch (e, s) {
      log('Erro ao buscar dados do tempo', error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao buscar dados do tempo");
    }
  }
}
