import 'package:decimal/decimal.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class IPaymentService {
  Future<List<PaymentType>> getTypesPayment();
  Future<PaymentType> findById(int id);

  Future<bool> startPaymentTrip(({
        PaymentType paymentType,
        Decimal value,
        String senderId,
        String recipientId
      }) data);
}
