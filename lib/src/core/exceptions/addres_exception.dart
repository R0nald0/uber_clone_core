
class AddresException implements Exception {
  final String message;
  final dynamic stackTrace;
  AddresException({required this.message ,this.stackTrace});
}