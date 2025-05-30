import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_clone_core/src/core/exceptions/payment_exception.dart';
import 'package:uber_clone_core/src/core/exceptions/user_exception.dart';
import 'package:uber_clone_core/src/core/exceptions/user_not_found.dart';
import 'package:uber_clone_core/src/model/payment_type.dart';
import 'package:uber_clone_core/src/repository/payments_repository/i_payments_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';

import '../i_payment_service.dart';

class PaymentServiceImpl implements IPaymentService {
  final IPaymentsRepository _paymentsRepository;
  final IUserRepository _userRepository;
  PaymentServiceImpl({
    required IPaymentsRepository paymentsRepository,
    required IUserRepository userRepository,
  })  : _paymentsRepository = paymentsRepository,
        _userRepository = userRepository;

  @override
  Future<PaymentType> findById(int id) => _paymentsRepository.findById(id);

  @override
  Future<List<PaymentType>> getTypesPayment() =>
      _paymentsRepository.getTypesPayment();

  @override
  Future<bool> startPaymentTrip(
      ({
        PaymentType paymentType,
        Decimal value,
        String senderId,
        String recipientId
      }) data) async {
    try {
      
       final userSender = await _userRepository.getDataUserOn(data.senderId);
       final userRecipient = await _userRepository.findById(data.recipientId);

      if (userSender == null) {
        throw UserNotFound;
      }

      if (userSender.balance == Decimal.zero ||
          userSender.balance < data.value) {
        throw PaymentException(
            message:
                'Saldo insuficiente para pagamento escolha outra forma de pagamento');
      }

      final userSenderUpadted =
          userSender.copyWith(balance: userSender.balance - data.value);
  
     final updateuserSenderSuccess = await _userRepository.updateUser(userSenderUpadted);

      if (!updateuserSenderSuccess) {
         throw UserException(message: 'Erro ao atualizar saldo do rementente Logado');
      } 
      final userRecipientUpadted =
          userRecipient.copyWith(balance: userSender.balance + data.value);

     final updateUserRecipientSuccess = await _userRepository.updateUser(userRecipientUpadted);
     
      if (!updateUserRecipientSuccess) {
         throw UserException(message: 'Erro ao atualizar saldo do Usuário destinatário');
      } 

      return true;
    } on UserNotFound {
      rethrow;
    } on PaymentException catch (e) {
      throw PaymentException(message: e.message);
    }
  }
}
