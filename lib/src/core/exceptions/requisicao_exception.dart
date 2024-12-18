class RequisicaoException  implements Exception{
  final String message;
  final dynamic stackTrace;
  RequisicaoException({required this.message,this.stackTrace});
}