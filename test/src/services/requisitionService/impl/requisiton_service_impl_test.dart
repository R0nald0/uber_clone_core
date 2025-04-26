
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/core/logger/i_app_uber_log.dart';
import 'package:uber_clone_core/src/repository/auth_repository/I_auth_repository.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/i_requisition_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/src/services/requisitionService/I_requistion_service.dart';
import 'package:uber_clone_core/src/services/requisitionService/impl/requisiton_service_impl.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

import '../../../repository/requisition_repository/impl/requisition_repository_test.dart';

  import 'package:mocktail/mocktail.dart';

  class RequestRepositoryMock extends Mock implements IRequestRepository{}
  class UserRepositoryMock extends Mock implements IUserRepository{}
  class AuthRepositoryMock extends Mock implements IAuthRepository{}
  class UberLogMock extends Mock implements IAppUberLog{}

void main() {
    late RequestRepositoryMock requestRepository;
    late IUserRepository userRepository;
    late IAuthRepository authRepository;
    late IAppUberLog log;
    late IRequistionService _requisitionServiceImpl;

  setUp((){
      requestRepository = RequestRepositoryMock();
      userRepository = UserRepositoryMock();
      authRepository =AuthRepositoryMock();
      log = UberLogMock();
  

     _requisitionServiceImpl = RequisitonServiceImpl(
      requisitonRepository:requestRepository,
      userRepository: userRepository, 
      authRepository: authRepository, 
      log: log,);     

  });

  group('update requistion realtime tests', (){

   test("given a logintude and latitude,when updatePositionRealTime isExecuted,it should return request with position updated",() {
       
   });

   
   test("Given a Request valid and MapOf<Object,object>,when updataDataRequisition isExecuted,it should return true",() async {
           final passager  = passageiro.copyWith(email: "testeUpdate@hotmail.com");
         final dataUpdate = {
          'status':'EM_VIAGEM',
           'passageiro' : passager.toMap() 
          };

          //TODO realizar test para atulizar requisição,remover  verificção de motorista null
          
          when(() => requestRepository.updataDataRequestActiveted(any(), any())).thenAnswer((_) async => true);
          when(()=> requestRepository.findActvitesRequestById(any()) ).thenAnswer((_) async =>requisicaoAtualizada );

          final result  =  await _requisitionServiceImpl.updataDataRequisition(requisicao, dataUpdate);

           expect(result, isInstanceOf<Requisicao>());
           expect(result.passageiro.email, 'testeUpdate@hotmail.com');

        


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
  idRequisicaoAtiva :"r001",
  nome: "João Silva",
  tipoUsuario: "passageiro",
  senha: "senha123",
  latitude: -23.5515,
  longitude: -46.6344,
);

// Criando o objeto Usuario (motorista)
Usuario motorista = Usuario(
  idUsuario: "m001",
  email: "motorista@email.com",
  idRequisicaoAtiva : "r001",
  nome: "Maria Santos",
  tipoUsuario: "motorista",
  senha: "senha456",
  latitude: -23.5520,
  longitude: -46.6350,
);

// Criando o objeto Requisicao
Requisicao requisicaoAtualizada = Requisicao(
  id: "r001",
  destino: destino,
  passageiro: passageiro,
  status: "EM_VIAGEM",
  motorista: null,
  valorCorrida: "25.50",
);