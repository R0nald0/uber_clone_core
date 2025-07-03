

import 'package:uber_clone_core/src/model/payment_type.dart';

abstract interface class IPaymentsRepository {
   Future<void> createPaymentIntent(double amount);
   Future<List<PaymentType>> getTypesPayment();  
     
   Future<PaymentType> findById(int id);
   
    Future<String> findAll();
  
}
