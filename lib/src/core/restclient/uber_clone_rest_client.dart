import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';

abstract interface class UberCloneRestClient {
  UberCloneRestClient auth();
  UberCloneRestClient unAuth();
  Future<UberCloneResponse<T>> post<T>(String path,
      {Object data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});

   Future<UberCloneResponse<T>> get<T>(String path,
      {
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});    
}
