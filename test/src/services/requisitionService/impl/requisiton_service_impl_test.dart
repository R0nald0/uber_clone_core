import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/repository/auth_repository/I_auth_repository.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/i_requisition_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/src/services/requisitionService/impl/requisiton_service_impl.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

import '../../../repository/requisition_repository/impl/requisition_repository_test.dart';



class UserRepositoryMock extends Mock implements IUserRepository {}

class AuthRepositoryMock extends Mock implements IAuthRepository {}

class UberLogMock extends Mock implements IAppUberLog {}

class RequestRepositoryMock extends Mock implements IRequestRepository {}
class MyUsuario extends Fake implements Usuario {}

void main() {
  late IUserRepository userRepository;
  late IAuthRepository authRepository;
  late IAppUberLog log;
  late IRequistionService requisitionServiceImpl;
  late IRequestRepository requestRepository;

  setUp(() {
    requestRepository = RequestRepositoryMock();
    userRepository = UserRepositoryMock();
    authRepository = AuthRepositoryMock();
    log = UberLogMock();

    requisitionServiceImpl = RequisitonServiceImpl(
      requisitonRepository: requestRepository,
      userRepository: userRepository,
      authRepository: authRepository,
      log: log,
    );
  });


  setUpAll(() {
    registerFallbackValue(passageiro);
  });

  group('update requistion test', () {
    test(
        "given a logintude and latitude,when updatePositionRealTime isExecuted,it should return request with position updated",
        () {});

    test(
        "Given a Request valid,when updataDataRequisition isExecuted,it should return true",
        () async {

      when(() => requestRepository.updataDataRequestActiveted(requisicao))
          .thenAnswer((_) async => true);
      when(() => requestRepository.findActvitesRequestById(any()))
          .thenAnswer((_) async => requisicaoAtualizada);

      final result = await requisitionServiceImpl.updataDataRequisition(
          requisicao);

      expect(result, isInstanceOf<Requisicao>());
      expect(result.passageiro.email, 'testeUpdate@hotmail.com');
    });
  });

  group('delete test gruop', () {

    test('deleteAcvitedRequest,should delete actveted request e retur true', () async{

     when(() => requestRepository.deleteAcvitedRequest(requisicao)).thenAnswer((_) async => true);
      when(() =>  authRepository.verifyStateUserLogged()).thenAnswer((_) async=> passageiro.idUsuario!);
      when(()=> userRepository.findById(passageiro.idUsuario!)).thenAnswer((_) async => passageiro );
      when(() => userRepository.updateUser(any()),).thenAnswer((_) async => true); 

      final result = await requisitionServiceImpl.deleteAcvitedRequest(requisicao);

      expect(result, isTrue);
      verify(() => requestRepository.deleteAcvitedRequest(requisicao),).called(1);
      verify(() => authRepository.verifyStateUserLogged(),).called(1);
      verify(() => userRepository.findById(passageiro.idUsuario!)).called(1);
      verify(() => userRepository.updateUser(any())).called(1);
    });
  });
}

Address destino = Address(
  id: 1,
  rua: "Rua Principal",
  nomeDestino: "Shopping Center",
  bairro: "Centro",
  cep: "12345-678",
  cidade: "São Paulo",
  numero: "100",
  latitude: -23.5505,
  longitude: -46.6333,
  favorite: true,
);

// Criando o objeto Usuario (passageiro)
Usuario passageiro = Usuario(
  idUsuario: "p001",
  email: "testeUpdate@hotmail.com",
  idRequisicaoAtiva: "r001",
  nome: "João Silva",
  tipoUsuario: "passageiro",
  senha: "senha123",
  latitude: -23.5515,
  longitude: -46.6344,
  balance: Decimal.parse('150.00')
);

// Criando o objeto Usuario (motorista)
Usuario motorista = Usuario(
  idUsuario: "m001",
  email: "motorista@email.com",
  idRequisicaoAtiva: "r001",
  nome: "Maria Santos",
  tipoUsuario: "motorista",
  senha: "senha456",
  latitude: -23.5520,
  longitude: -46.6350,
  balance: Decimal.parse('150.00')
);

// Criando o objeto Requisicao
Requisicao requisicaoAtualizada = Requisicao(
  id: "r001",
  paymentType: PaymentType(id: 1, type: "money"),
  destino: destino,
  passageiro: passageiro,
  status: RequestState.em_viagem,
  motorista: null,
  requestDate: DateTime.now(),
  valorCorrida: "25.50",
);
