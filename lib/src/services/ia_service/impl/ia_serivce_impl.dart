import 'dart:developer';

import 'package:uber_clone_core/src/core/exceptions/service_exception.dart';
import 'package:uber_clone_core/src/model/Ia_request.dart';
import 'package:uber_clone_core/src/model/messages.dart';
import 'package:uber_clone_core/src/model/wheather_response.dart';
import 'package:uber_clone_core/src/repository/uber_api_ia_repository/uber_ia_repository.dart';
import 'package:uber_clone_core/src/repository/wheather_repository/whether_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

import '../../../repository/location_repository/i_location_repository.dart';

class IaSerivceImpl implements IaService {
  final IWheatherRepository _wheatherRepository;
  final UberIaRepository _iaRepository;
  final ILocationRepository _locationRepository;

  IaSerivceImpl(
      {required UberIaRepository iaRepository,
      required ILocationRepository locationRepositoryImpl,
      required IWheatherRepository wheatherRepository})
      : _iaRepository = iaRepository,
        _locationRepository = locationRepositoryImpl,
        _wheatherRepository = wheatherRepository;


  @override
  Future<List<MessagesResponseSuggestion>> sendMessage(
      String message, Usuario user) async {
    try {
      final Usuario(:latitude, :longitude) = user;
      final Address(:cidade, :bairro) =
          await _locationRepository.setNameMyLocal(latitude, longitude);
      final WhetherResponse(
        location: Location(:name, :country, :region),
        current: Current(:tempC, :tempF)
      ) = await _wheatherRepository.getWhetherByLocation(cidade, 1);

      final time = DateTime.now().toIso8601String();
      final messageResult = Messages(role: 'user', content: message);
      final iaMessage = IaRequest(
          model: "llama-3.3-70b-versatile", messages: [messageResult]);

      final userDataIaRequest = (
        location: '$country/$region/$name/$bairro',
        time: time,
        wheather: tempC,
        iaMessage: iaMessage
      );

      return await _iaRepository.getSuggestionsByUserData(userDataIaRequest);
    } on RepositoryException {
      rethrow;
    }
  }
 
 
  @override
  Future<MessagesResponseSuggestion> getDetailSuggestion(
          ({String title, String subject}) data) =>
      _iaRepository.getDetailSuggestion(data);

  @override
  Future<List<MessagesResponseSuggestion>> freeChatIa(
      ({String subject, String title}) messageData,
      Usuario user) async {
    try {
      final Usuario(:latitude, :longitude) = user;
      final Address(:cidade, :bairro, :nomeDestino) =
          await _locationRepository.setNameMyLocal(latitude, longitude);

      final data = (
        location: '$cidade/$bairro',
        subject: messageData.subject,
        title: messageData.title
      );

     return await _iaRepository.freeChatIa(data);
    } on RepositoryException catch (e, s) {
       log('Erro ao buscar dados da ia' ,error:  e,stackTrace: s);
       throw ServiceException(message: 'Erro ao buscar reposta',);
    }
  }
}
