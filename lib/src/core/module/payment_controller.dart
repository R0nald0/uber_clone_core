import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/src/core/types_payment.dart';
import 'package:uber_clone_core/src/services/payment/i_payment_service.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
part 'payment_controller.g.dart';

class PaymentController = PaymentControllerBase with _$PaymentController;

abstract class PaymentControllerBase with Store {
  final IPaymentService _paymentService;
  PaymentControllerBase({required IPaymentService paymentService}):_paymentService = paymentService;

 @readonly
 String? _errorMessage ;

 @action
  Future<void> createIntentPayment(String amount,TypesPayment type) async{
      try {
         final amountDouble = double.tryParse(amount.changeCommaToDot());
         await _paymentService.creatIntentPayment(amountDouble,PaymentType(id: 4, type: type.name)); 
     
      }on PaymentException catch (e) {
         _errorMessage = null;
        _errorMessage = e.message;
      }
      
    //  _paymentService.creatIntentPayment(amount);
  } 
  
 
}
