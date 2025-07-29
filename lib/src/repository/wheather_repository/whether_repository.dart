import 'package:uber_clone_core/src/model/wheather_response.dart';

abstract interface class IWheatherRepository {
  
  Future<WhetherResponse> getWhetherByLocation(String region,int day, );
  
}