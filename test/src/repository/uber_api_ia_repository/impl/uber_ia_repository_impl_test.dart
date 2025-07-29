import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/core/exceptions/uber_rest_client_exception.dart';
import 'package:uber_clone_core/src/core/restclient/impl/ia_rest_client.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';
import 'package:uber_clone_core/src/model/Ia_request.dart';
import 'package:uber_clone_core/src/model/messages.dart';
import 'package:uber_clone_core/src/repository/uber_api_ia_repository/impl/uber_ia_repository_impl.dart';
import 'package:uber_clone_core/src/repository/uber_api_ia_repository/uber_ia_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class MockRestClient extends Mock implements IaRestClientImpl {}

void main() {
  late MockRestClient mockRestClient;
  late UberIaRepository uberRepositoryIa;
  setUp(() {
    mockRestClient = MockRestClient();
    uberRepositoryIa = UberIaRepositoryImpl(restClient: mockRestClient);
  });

  test("should return reponse a Message with message", () async {
    when(() => mockRestClient.get(any()))
        .thenAnswer((_) async => UberCloneResponse(data: jsonREsul));

    final result = await uberRepositoryIa.freeChatIa();
    expect(result, isInstanceOf<Messages>());
    verify(() => mockRestClient.get(any())).called(1);
  });

  group("test for sendIaMessage", () {
    final iaRequest = IaRequest(
          model: "modelo teste",
          messages: [Messages(role: "user", content: "teste mensagem")]);
    
    test('getSuggestionsByUserData,should return list de messages sugestion dto', () async{
       final userDataIaRequest = (
          location : 'teste/teste',
          time :DateTime.now().toIso8601String(),
          wheather : 25.0,
          iaMessage :IaRequest(model: "modelo teste", messages: [Messages(role:"assistent", content: "teste contente")])
      );

       when(() => mockRestClient.post(any(),data: any(named: 'data'))).thenAnswer((_) async =>UberCloneResponse(
        data:  resultMessageResponseDto,statuCode: 200,statusMessage: "success"
       ) );

       final result = await uberRepositoryIa.getSuggestionsByUserData(userDataIaRequest);

       expect(result.length, equals(2));

    });
  
    test(
        "sendMessageIa,should send messager on string and return Message with response",
        () async {
      when(() => mockRestClient.post(any(),
              queryParameters: any(named: "queryParameters"))) .thenAnswer((_) async => UberCloneResponse(data: jsonREsul));

      final result = await uberRepositoryIa.sendMessageIa(iaRequest);
      expect(result, isInstanceOf<Messages>());
      expect(result.content, equals("Fast language models"));
    });

    test('sendMessageIa ,should lounch RepositoryException when error on RestClient',() async {
      when(() => mockRestClient.post(any(),queryParameters: any(named: 'queryParameters')))
          .thenThrow(UberRestClientException());
      expect(() => uberRepositoryIa.sendMessageIa(iaRequest),
          throwsA(isA<RepositoryException>()));
       verify(() =>mockRestClient.post(any(),queryParameters: any(named: "queryParameters"))).called(1);
    });
  });
}

final jsonREsul = {
  "choices": [
    {
      "index": 0,
      "message": {"role": "assistant", "content": "Fast language models"},
      "logprobs": null,
      "finish_reason": "stop"
    }
  ]
};

final resultMessageResponseDto =  [
    {
        "title": "Academia Body Fit - Av. Luiz Tarquínio, 456, Itapoã",
        "description": "Aberta até 22h, tem avaliação 4.9 no Google. Oferece treinos ao ar livre com vista para o mar.\n",
        "role": "assistent"
    },
    {
        "title": "Clínica Itapoã Saúde - R. do Acaraí, 210, Itapoã",
        "description": "Especializada em medicina preventiva e check-ups. Atendimento até 18h, com 10% de desconto em exames de rotina.",
        "role": "assistent"
    }
];
