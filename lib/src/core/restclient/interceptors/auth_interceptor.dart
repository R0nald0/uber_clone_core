
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor{
  @override  
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({"key" :"a461c75cf7be441dada35243251307"});
    return super.onRequest(options, handler);
  }

}