import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/impl/requisition_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

import '../../user_repository/impl/user_repository_impl_test.dart';

class MockLocalfireStore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockLog extends Mock implements IAppUberLog {}

void main() {
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockSnapshot;

  late MockAppUberLog logMock;
  late MockLocalStorage localStorageMock;
  late MockLocalfireStore fireStoreMock;

  late RequisitionRepository requisitionReposiory;

  setUp(() async {
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    logMock = MockAppUberLog();

    logMock = MockAppUberLog();
    localStorageMock = MockLocalStorage();
    fireStoreMock = MockLocalfireStore();

    requisitionReposiory = RequisitionRepository(
        logger: logMock,
        localStorage: localStorageMock,
        firestore: fireStoreMock);
  });

  group('verfyActivatedRequisition', () {
    test(
        'verfyActivatedRequisition should retuun requisiton saved on localStorage',
        () async {
      when(() => localStorageMock.read<String>(any()))
          .thenAnswer((_) async => requisicao.toJson());

      final result =
          await requisitionReposiory.verfyActivatedRequest("r001");

      expect(result, isNotNull);
      expect(result.id, "r001");
      verify(
        () => localStorageMock.read<String>(any()),
      ).called(1);
    });

    test(
        'verfyActivatedRequisition should find request in online Database and save on localStorage',
        () async {
      when(() => localStorageMock.write<String>(any(), any()))
          .thenAnswer((_) async => true);
      when(() => localStorageMock.read<String>(any()))
          .thenAnswer((_) async => null);

      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn(requisicao.toMap());

      final result =
          await requisitionReposiory.verfyActivatedRequest('r001');

      expect(result.id, 'r001');
      verify(
        () => localStorageMock.read<String>(any()),
      ).called(1);
      verify(() => localStorageMock.write<String>(any(), any())).called(1);
      verify(() => mockCollection.doc(any())).called(1);
      verify(() => mockDocument.get()).called(1);
      verify(() => mockSnapshot.data()).called(1);
    });
  });
  group("create requests tests", () {
     
     test("createRequest should save request on database", () async {

       when(() => localStorageMock.write<String>(any(), any())).thenAnswer((_) async => true );
       
       when(() => fireStoreMock.collection(any())).thenReturn(mockCollection); 
       when(() => mockCollection.doc(any())).thenReturn(mockDocument);
       when(() => mockDocument.id).thenReturn(requisicao.id!);
       when(() => mockDocument.set(any())).thenAnswer((_) async=> Future<void>.value());
      
      final result =await  requisitionReposiory.createRequest(requisicao);
      
      expect(result , isTrue);
      verify(() => fireStoreMock.collection(any())).called(2);
      verify(() => mockCollection.doc(any())).called(2);
      verify(() => mockDocument.id).called(1);
      verify(() => mockDocument.set(any())).called(2);

       

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
  email: "passageiro@email.com",
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
  nome: "Maria Santos",
  tipoUsuario: "motorista",
  senha: "senha456",
  latitude: -23.5520,
  longitude: -46.6350,
);

// Criando o objeto Requisicao
Requisicao requisicao = Requisicao(
  id: "r001",
  destino: destino,
  passageiro: passageiro,
  status: "Aguardando",
  motorista: motorista,
  valorCorrida: "25.50",
);
