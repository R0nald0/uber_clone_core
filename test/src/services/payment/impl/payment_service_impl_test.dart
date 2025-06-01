import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/repository/payments_repository/i_payments_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/src/services/payment/impl/payment_service_impl.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

import '../../../objetc_to_use.dart';


class MockRepositoryUserRepository extends Mock implements IUserRepository{} 
class MockPaymentRepository extends Mock implements IPaymentsRepository{}
class  MockLogger extends Mock implements IAppUberLog{}



void main() {
   late MockRepositoryUserRepository mockRepositoryUserRepository ;
   late MockPaymentRepository mockPaymentRepository;
   late IPaymentService paymentService;
   late MockLogger mockLogger;
   
  setUp((){
    mockRepositoryUserRepository = MockRepositoryUserRepository();
    mockPaymentRepository =MockPaymentRepository();
    mockLogger = MockLogger();
    paymentService = PaymentServiceImpl(
      paymentsRepository: mockPaymentRepository, 
      userRepository: mockRepositoryUserRepository,
      logger: mockLogger
      ) ;
  });
  
  setUpAll(() {
    registerFallbackValue(usuario1);
  });
  
  group('test start payment', (){
    
    test('startPaymentTrip,should make the payment for the trip and return true ', () async{
        
       when(() => mockRepositoryUserRepository.getDataUserOn(any())).thenAnswer((_) async => usuario2);
       when(() => mockRepositoryUserRepository.findById(any())).thenAnswer((_) async => usuario1);
       when(() => mockRepositoryUserRepository.updateUser(any())).thenAnswer((_) async => true);
      
        final data = (
         paymentType : PaymentType(id: 1, type: 'PIX'), 
          recipientId : usuario2.idUsuario! ,
          senderId : usuario1.idUsuario! ,
          value: '30,00'
        );
        
        final result = await paymentService.startPaymentTrip(data);
        expect(result, isTrue);

    });

     test('startPaymentTrip,should throw  UserNotFound Exceptiom if user null ', () async{
       
       when(() => mockRepositoryUserRepository.getDataUserOn(any())).thenThrow(UserNotFound());
      
        final data = (
         paymentType : PaymentType(id: 1, type: 'PIX'), 
          recipientId : usuario2.idUsuario! ,
          senderId : usuario1.idUsuario! ,
          value:'30.00'
        );
        
        expect(()async => await paymentService.startPaymentTrip(data),throwsA(isA<UserNotFound>()));
        verify(() => mockRepositoryUserRepository.getDataUserOn(any())).called(1);

    });

    test('startPaymentTrip,should throw  PaymentExceptiom if balance zero or insufficient ', () async{
       final useUp1  = usuario2.copyWith(balance: Decimal.parse('29.99'));
      //final useUp2  = usuario2.copyWith(balance: Decimal.tryParse('30.0')); 

       when(() => mockRepositoryUserRepository.getDataUserOn(any())).thenAnswer((_) async => useUp1);
       when(() => mockRepositoryUserRepository.findById(any())).thenAnswer((_) async => usuario2);

        final data = (
         paymentType : PaymentType(id: 1, type: 'PIX'), 
          recipientId : usuario2.idUsuario! ,
          senderId : useUp1.idUsuario! ,
          value: '30.00'
        );
        
        expect(()async => await paymentService.startPaymentTrip(data),throwsA(isA<PaymentException>()));

    });

  });
}



final usuario1 = Usuario(
    idUsuario: 'u001',
    email: 'joao@email.com',
    nome: 'João Silva',
    tipoUsuario: 'passageiro',
    senha: 'senha123',
    latitude: -23.5505,
    longitude: -46.6333,
    idRequisicaoAtiva: null,
    balance: Decimal.parse('150.57'),
  );