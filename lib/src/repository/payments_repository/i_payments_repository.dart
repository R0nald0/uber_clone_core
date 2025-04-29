import 'package:uber_clone_core/src/model/payment_type.dart';

abstract interface class IPaymentsRepository {
   Future<List<PaymentType>> getTypesPayment();  
} 