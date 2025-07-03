import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class IPaymentService {
  Future<List<PaymentType>> getTypesPayment();
  Future<PaymentType> findById(int id);
  Future<bool> creatIntentPayment( double? amount,PaymentType paymentType); 
  Future<String> findAll();
  Future<bool> startPaymentTrip(({
        PaymentType paymentType,
        String value,
        String senderId,
        String recipientId
      }) data);
}
