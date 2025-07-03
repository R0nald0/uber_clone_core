import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:uber_clone_core/src/core/types_payment.dart';
import 'package:uber_clone_core/src/repository/payments_repository/i_payments_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class PaymentServiceImpl implements IPaymentService {
  final IPaymentsRepository _paymentsRepository;
  final IUserRepository _userRepository;
  final IAppUberLog _logger;

  PaymentServiceImpl({
    required IPaymentsRepository paymentsRepository,
    required IUserRepository userRepository,
    required IAppUberLog logger,
  })  : _paymentsRepository = paymentsRepository,
        _userRepository = userRepository,
        _logger = logger;

  @override
  Future<PaymentType> findById(int id) => _paymentsRepository.findById(id);

  @override
  Future<List<PaymentType>> getTypesPayment() =>
      _paymentsRepository.getTypesPayment();

  @override
  Future<bool> startPaymentTrip(
      ({
        PaymentType paymentType,
        String value,
        String senderId,
        String recipientId
      }) data) async {
    try {
      final price = Decimal.parse(data.value.changeCommaToDot());

      final userRecipient =
          await _userRepository.getDataUserOn(data.recipientId);
      final userSender = await _userRepository.findById(data.senderId);
     
      if (userRecipient == null) {
        throw UserNotFound;
      }

      switch (TypesPayment.findByName(data.paymentType.type)) {
        case TypesPayment.CREDIT_CARD:
          await _paymentsRepository.createPaymentIntent(price.toDouble());
        case TypesPayment.PIX:
          return true ;  //await _updateSenderBalance(userSender, price);
        case TypesPayment.MONEY:
           return true;// await _updateSenderBalance(userSender, price);
        case TypesPayment.BITCOIN:
          return true ;// await _updateSenderBalance(userSender, price);
      }
      return await _upadateRecipientBalance(userRecipient, price);
    
    } on FormatException catch (e, s) {
      _logger.erro('Formato Inválido,erro converter valor do preço', e, s);
      throw PaymentException(
          message: "Erro ao realizar pagamento,contate o suporte");
    } on UserNotFound {
      throw UserNotFound();
    } on PaymentException catch (e, s) {
      _logger.erro(e.message, e, s);
      throw PaymentException(message: e.message);
    } on RequestException {
      rethrow;
    } on UserException catch (e, s) {
      _logger.erro(e.message!, e, s);
      throw UserException(message: e.message);
    }
  }

  Future<bool> _upadateRecipientBalance(Usuario userRecipient, Decimal price) async {
     final userRecipientUpadted =
        userRecipient.copyWith(balance: userRecipient.balance + price);
    
    final updateUserRecipientSuccess =
        await _userRepository.updateUser(userRecipientUpadted);
    
    if (!updateUserRecipientSuccess) {
      throw UserException(
          message: 'Erro ao atualizar saldo do Usuário destinatário');
    }
    
    return true;
  }

  Future<void> _updateSenderBalance(Usuario userSender, Decimal price) async {
    
    if (userSender.balance <= Decimal.zero || userSender.balance < price) {
      throw PaymentException(
          message: 'Saldo insuficiente,Escolha outra forma de pagamento');
    }
    
    final userSenderUpadted =
        userSender.copyWith(balance: userSender.balance - price);
    final updateuserSenderSuccess =
        await _userRepository.updateUser(userSenderUpadted);
    
    if (!updateuserSenderSuccess) {
      throw UserException(
          message: 'Erro ao atualizar saldo do rementente Logado');
    }
  }

  @override
  Future<bool> creatIntentPayment(
      double? amount, PaymentType paymentType) async {
    try {
      if (amount == null) {
        throw PaymentException(
            message: "Dados inválidos para realizar pagamento");
      }
    
      switch (TypesPayment.findByName(paymentType.type)) {
        case TypesPayment.CREDIT_CARD:
          await _paymentsRepository.createPaymentIntent(amount);
        case TypesPayment.PIX:
          await _paymentsRepository.createPaymentIntent(amount);
        case TypesPayment.MONEY:
          _paymentsRepository.createPaymentIntent(amount);
        case TypesPayment.BITCOIN:
          _paymentsRepository.createPaymentIntent(amount);
      }
      return true;

    } on PaymentException catch (e, s) {
      log("Dados inválidos para realizar pagamento", error: e, stackTrace: s);
      throw PaymentException(message: e.message);
    }
    
  }

  @override
  Future<String> findAll() => _paymentsRepository.findAll();
}
