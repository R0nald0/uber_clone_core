class RequestException  implements Exception{
  final String message;
  final dynamic stackTrace;
  RequestException({required this.message,this.stackTrace});
}