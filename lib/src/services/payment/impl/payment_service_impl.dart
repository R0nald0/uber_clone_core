import 'package:uber_clone_core/src/model/payment_type.dart';
import 'package:uber_clone_core/src/repository/payments_repository/i_payments_repository.dart';

import '../i_payment_service.dart';

class PaymentServiceImpl implements IPaymentService {
  final IPaymentsRepository _paymentsRepository;
  PaymentServiceImpl({
    required IPaymentsRepository paymentsRepository,
  }):_paymentsRepository = paymentsRepository;
  
  
  @override
  Future<PaymentType> findById(int id) => _paymentsRepository.findById(id);

  @override
  Future<List<PaymentType>> getTypesPayment() => _paymentsRepository.getTypesPayment();

}
