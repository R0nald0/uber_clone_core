
class UberRestClientException implements Exception {
   int? statuCode;
   dynamic data;
   String? errorMessage;

   UberRestClientException({this.data,this.errorMessage,this.statuCode}); 
   

  @override
  String toString() => 'UberRestClientException(statuCode: $statuCode, data: $data, errorMessage: $errorMessage)';
}
