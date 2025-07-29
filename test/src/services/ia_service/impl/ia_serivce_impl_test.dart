import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/model/Ia_request.dart';
import 'package:uber_clone_core/src/model/messages_response_suggestion.dart';
import 'package:uber_clone_core/src/repository/location_repository/i_location_repository.dart';
import 'package:uber_clone_core/src/repository/uber_api_ia_repository/uber_ia_repository.dart';
import 'package:uber_clone_core/src/repository/wheather_repository/whether_repository.dart';
import 'package:uber_clone_core/src/services/ia_service/ia_service.dart';
import 'package:uber_clone_core/src/services/ia_service/impl/ia_serivce_impl.dart';

import '../../../objetc_to_use.dart';


class MockIaRepository extends Mock implements UberIaRepository{}
class MockWheatherRepository extends Mock implements IWheatherRepository{}
class MockLocationRepository extends Mock implements ILocationRepository{}
void main() {
   late MockIaRepository mockIaRepository;
   late MockLocationRepository mockLocationRepository;
   late MockWheatherRepository mockWheatherRepository;

   late IaService iaService;

    setUpAll(() {
    registerFallbackValue((
      iaMessage: IaRequest(model: '', messages: []),
      location: '',
      time: '',
      wheather: 0.0,
    ));
  });
   setUp((){
    mockIaRepository = MockIaRepository();
    mockWheatherRepository = MockWheatherRepository();
    mockLocationRepository = MockLocationRepository(); 

    iaService  = IaSerivceImpl(iaRepository: mockIaRepository, locationRepositoryImpl: mockLocationRepository, wheatherRepository: mockWheatherRepository);

   });  

   group('send messages ia',(){
    final ObjetcToUse(:addressTest,:fakeWeatherResponse,:usuario2) = ObjetcToUse();
    final messages  = [MessagesResponseSuggestion(description: "teste",role: "teste ",title: "teste"),MessagesResponseSuggestion(description: "teste2",role: "teste2 ",title: "teste2")];

     test("sendMessage , should receive message and user , and return List of messages ", () async {
    
       when(() => mockLocationRepository.setNameMyLocal(usuario2.latitude,usuario2.longitude)).thenAnswer((_) async => addressTest );
       when(() => mockWheatherRepository.getWhetherByLocation(any(), 1)).thenAnswer((_) async =>  fakeWeatherResponse);
       when(() => mockIaRepository.getSuggestionsByUserData(any())).thenAnswer((_) async => messages) ;
         
       final result = await iaService.sendMessage("teste", usuario2);
        expect(result.length, 2);
     });

   });

}
