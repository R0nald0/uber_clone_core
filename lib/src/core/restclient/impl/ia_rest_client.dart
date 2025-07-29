import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:uber_clone_core/src/core/exceptions/uber_rest_client_exception.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_rest_client.dart';

class IaRestClientImpl implements UberCloneRestClient {
  late Dio _dio;

  IaRestClientImpl() {
    _dio = Dio(BaseOptions(
        baseUrl: const String.fromEnvironment('LOCAL_BASE_URL'),
        connectTimeout: const Duration(seconds: 10),
        ));
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      )
    ]);
  }

  @override
  UberCloneRestClient auth() {
    _dio.options.extra = {"auth": true};
    return this;
  }

  @override
  UberCloneRestClient unAuth() {
    _dio.options.extra = {"auth": false};
    return this;
  }

  @override
  Future<UberCloneResponse<T>> post<T>(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final Response(data: mapData, :statusCode, :statusMessage) =
          await _dio.post(path, data: data, queryParameters: queryParameters);

      return UberCloneResponse(
          data: mapData, statuCode: statusCode, statusMessage: statusMessage);
    } on DioException catch (e, s) {
      log("Erro ao criar intent payment", error: e, stackTrace: s);
      throw UberRestClientException(
          data: e.response?.data,
          errorMessage: e.message,
          statuCode: e.response!.statusCode!);
    }
  }

  @override
  Future<UberCloneResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final Response(data: mapData, :statusCode, :statusMessage) =
          await _dio.get(path);
      return UberCloneResponse(
          data: mapData, statuCode: statusCode, statusMessage: statusMessage);
    } on DioException catch (e, s) {
      log("Erro ao criar intent payment", error: e, stackTrace: s);
      throw UberRestClientException(
          data: e.response?.data,
          errorMessage: e.message,
          statuCode: e.response!.statusCode!);
    }
  }
}
