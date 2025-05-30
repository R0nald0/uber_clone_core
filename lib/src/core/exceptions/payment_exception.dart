class PaymentException implements Exception{
   final String message;
   final StackTrace? stackTrace;
 
  PaymentException({required this.message,this.stackTrace});  
}