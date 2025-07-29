import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:uber_clone_core/src/core/exceptions/uber_rest_client_exception.dart';
import 'package:uber_clone_core/src/core/restclient/interceptors/auth_interceptor.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_rest_client.dart';

class WhetherRestClientImpl implements UberCloneRestClient {
  late Dio _dio;

  WhetherRestClientImpl() {
    _dio = Dio(BaseOptions(
        baseUrl: const String.fromEnvironment('WHEATHER_BASE_URL'),
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60)))
      ..interceptors.addAll([
        AuthInterceptor(),
        LogInterceptor()
        ]);
  }

  @override
  UberCloneRestClient auth() {
    return this;
  }

  @override
  Future<UberCloneResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
    final Response(:data,:statusCode,:statusMessage) = await  _dio.get<T>(path,
          queryParameters: queryParameters, options: Options(headers: headers));

   return  UberCloneResponse(data: data,statuCode: statusCode ,statusMessage: statusMessage );    
    } on DioException catch (e,s) {
      log('Erro ao buscar dados da api',error:  e,stackTrace: s);
      throw UberRestClientException();
    }
  }
  
  @override
  Future<UberCloneResponse<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) {
    // TODO: implement post
    throw UnimplementedError();
  }
  
  @override
  UberCloneRestClient unAuth() {
    // TODO: implement unAuth
    throw UnimplementedError();
  }


}
