import 'dart:developer';

import 'package:uber_clone_core/src/core/exceptions/repository_exception.dart';
import 'package:uber_clone_core/src/core/exceptions/uber_rest_client_exception.dart';
import 'package:uber_clone_core/src/core/restclient/impl/ia_rest_client.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_rest_client.dart';
import 'package:uber_clone_core/src/model/Ia_request.dart';
import 'package:uber_clone_core/src/model/messages_response_suggestion.dart';
import 'package:uber_clone_core/src/repository/uber_api_ia_repository/uber_ia_repository.dart';

import '../../../model/messages.dart';

class UberIaRepositoryImpl implements UberIaRepository {
  final UberCloneRestClient _restClient;

  UberIaRepositoryImpl({required IaRestClientImpl restClient})
      : _restClient = restClient;

  @override
  Future<List<MessagesResponseSuggestion>> freeChatIa(({String subject, String location , String title}) data) async {
    try {
      final UberCloneResponse(data: List result) = await _restClient.post("/ia/message",data: {
         'title': data.title,
         'subject': data.subject,
         'location': data.location
      });

    return result
          .map<MessagesResponseSuggestion>(
              (e) => MessagesResponseSuggestion.fromMap(e))
          .toList();
    } on UberRestClientException catch (e, s) {
      log("Erro ao buscar reposta do agent", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao recuperar resposta");
    }
  }

  @override
  Future<List<MessagesResponseSuggestion>> getSuggestionsByUserData(
      ({
        double wheather,
        String location,
        String time,
        IaRequest iaMessage
      }) userDataIaRequest) async {
    try {
      final UberCloneResponse(data: List result) =
          await _restClient.post('/ia/suggestions', data: {
        'whether': userDataIaRequest.wheather,
        'location': userDataIaRequest.location,
        'time': userDataIaRequest.time,
        'iaMessage': {
          'role': 'user',
          'content': userDataIaRequest.iaMessage.messages.first.content
        }
      });

      return result
          .map<MessagesResponseSuggestion>(
              (e) => MessagesResponseSuggestion.fromMap(e))
          .toList();
    } on UberRestClientException catch (e, s) {
      log("Erro ao buscar reposta do agent", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao recuperar resposta");
    } on ArgumentError catch (e, s) {
      log("Json inválido", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao converter dados");
    }
  }

  @override
  Future<MessagesResponseSuggestion> getDetailSuggestion(
      ({String title, String subject}) data) async {
    try {
      final UberCloneResponse(data: result) = await _restClient.post(
          '/ia/suggestions/details',
          data: {'title': data.title, 'subject': data.subject});
       
  
     return MessagesResponseSuggestion.fromMap(result);
    } on UberRestClientException catch (e, s) {
      log("Erro ao buscar reposta do agent", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao recuperar resposta");
    } on ArgumentError catch (e, s) {
      log("Json inválido", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao converter dados");
    }
  }
 

  @override
  Future<Messages> sendMessageIa(IaRequest iaRequest) async {
    try {
      final UberCloneResponse(:data) = await _restClient.post("/ia/message",
          queryParameters: {
            'model': iaRequest.model,
            'messages': iaRequest.messages
          });

      final result = data['choices'] as List;
      final messagesList = result.first['message'];
      return Messages.fromMap(messagesList);
    } on UberRestClientException catch (e, s) {
      log("Erro ao buscar reposta do agent", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao recuperar resposta");
    }
  }
}
