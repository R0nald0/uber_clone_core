import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/core/restclient/impl/wheather_rest_client.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';
import 'package:uber_clone_core/src/model/wheather_response.dart';
import 'package:uber_clone_core/src/repository/wheather_repository/impl/whether_repository_impl.dart';
import 'package:uber_clone_core/src/repository/wheather_repository/whether_repository.dart';
 


class MockUberRestClient extends Mock implements WhetherRestClientImpl{}

void main() {
  
  late MockUberRestClient mockUberRestClient;
  late IWheatherRepository wheatherRepository; 

 setUpAll((){
    mockUberRestClient = MockUberRestClient();
    wheatherRepository =WheatherRepositoryImpl(wheatherRestClient: mockUberRestClient);
 });

 group("test get wheathers", (){

  test('getWheatherByLocation,should receive a region and day quantities and return WheatherReponsew with data os days', () async {
     final data = {
         "location": {
           "name": "San Paulo",
           "region": "Sao Paulo",
           "country": "Brazil",
         },
         "current": {
           "temp_c": 15.0,
           "temp_f": 59.0,
        }
     };
    when(() => mockUberRestClient.get(any(),queryParameters: any(named: 'queryParameters')))
    .thenAnswer((_) async =>UberCloneResponse(
      data:data,
      statuCode: 200,
      statusMessage: "succss" 
    ));
   
    final result = await wheatherRepository.getWhetherByLocation('sao paulo',1);
    expect(result, isInstanceOf<WhetherResponse>());
    expect(result.location.name,equals('San Paulo') );
    verify(() =>mockUberRestClient.get(any(),queryParameters: any(named: 'queryParameters'))).called(1);
    
  });

 });
}