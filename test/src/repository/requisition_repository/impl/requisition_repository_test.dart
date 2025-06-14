import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/core/offline_database/database_off_line.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/impl/requisition_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

import '../../../objetc_to_use.dart';
import '../../user_repository/impl/user_repository_impl_test.dart';

class MockLocalfireStore extends Mock implements FirebaseFirestore {}

class MockDatabaseOffline extends Mock implements DatabaseOffLine {}

class MockStreamRequisition extends Mock
    implements Stream<DocumentSnapshot<Map<String, dynamic>>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

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

class MockRquest extends Mock implements Requisicao {}

class MockLog extends Mock implements IAppUberLog {}

void main() {
  late MockDatabaseOffline mockDatabaseOffline;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockSnapshot;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQuery mockQuery;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;

  late MockAppUberLog logMock;
  late MockLocalStorage localStorageMock;
  late MockLocalfireStore fireStoreMock;
  late MockRquest mockRquest;
  late RequisitionRepository requisitionReposiory;

  setUp(() {
    mockDatabaseOffline = MockDatabaseOffline();
    mockRquest = MockRquest();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockQuery = MockQuery();
    mockSnapshot = MockDocumentSnapshot();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    logMock = MockAppUberLog();

    logMock = MockAppUberLog();
    localStorageMock = MockLocalStorage();
    fireStoreMock = MockLocalfireStore();

    requisitionReposiory = RequisitionRepository(
        logger: logMock,
        localStorage: localStorageMock,
        firestore: fireStoreMock,
        uberDatabaseOffline: mockDatabaseOffline);
  });

  group('Find requests', () {
    test('findAllFromUser,should return data in DataBase offline', () async {
      when(() => mockDatabaseOffline.findAllData(any()))
          .thenAnswer((_) async => ObjetcToUse.mapRequest);
      final result = await requisitionReposiory.findAllFromUser('2');
      expect(result, isNotEmpty);
    });

    test("findAllFromUser,should find all request by id user", () async {
      when(
        () => mockDatabaseOffline.findAllData(any()),
      ).thenAnswer((_) async => List.empty());
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() =>
              mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs)
          .thenReturn([mockQueryDocumentSnapshot]);

      when(
        () => mockDatabaseOffline.save(any(), any()),
      ).thenAnswer((_) async => 1);
      when(
        () => mockQueryDocumentSnapshot.data(),
      ).thenReturn(requisicao.toMap());
      final result = await requisitionReposiory
          .findAllFromUser(requisicao.motorista!.idRequisicaoAtiva!);

      expect(result.length, 1);
      verify(() => fireStoreMock.collection(any())).called(1);
      verify(
        () => mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')),
      ).called(1);
      verify(() => mockQuery.get()).called(1);
      verify(() => mockQuerySnapshot.docs).called(1);
    });

    test('findAllFromUser,should return empty list when not found data',
        () async {
      when(
        () => mockDatabaseOffline.findAllData(any()),
      ).thenAnswer((_) async => List.empty());
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() =>
              mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await requisitionReposiory.findAllFromUser('123');
      expect(result, isEmpty);
    });
    test('findAllFromUser,launch RequestException when FirebaseExcpetion',
        () async {
      when(
        () => mockDatabaseOffline.findAllData(any()),
      ).thenAnswer((_) async => List.empty());
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() =>
              mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockQuery);
      when(() => mockQuery.get())
          .thenThrow(FirebaseException(plugin: 'firestore', message: 'Erro'));

      expect(
        () => requisitionReposiory.findAllFromUser('123'),
        throwsA(isA<RequestException>()),
      );
    });

    test('findAllFromUser,launch RequestException when ArgumentError',
        () async {
      when(
        () => mockDatabaseOffline.findAllData(any()),
      ).thenAnswer((_) async => List.empty());
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() =>
              mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs)
          .thenReturn([mockQueryDocumentSnapshot]);
      when(
        () => mockQueryDocumentSnapshot.data(),
      ).thenReturn({'t': "a"});

      expect(
        () => requisitionReposiory.findAllFromUser('123'),
        throwsA(isA<RequestException>()),
      );
    });
  });
  group('verfyActivatedRequisition', () {
    test(
        'verifyActivatedRequisition should return the requisition saved in localStorage',
        () async {
      when(() => localStorageMock.read<String>(any()))
          .thenAnswer((_) async => requisicao.toJson());

      final result = await requisitionReposiory.verfyActivatedRequest("r001");

      expect(result, isNotNull);
      expect(result.id, "r001");
      verify(
        () => localStorageMock.read<String>(any()),
      ).called(1);
    });

    test(
        'Should retrieve the requisition from the online database and save it to local storage.',
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

      final result = await requisitionReposiory.verfyActivatedRequest('r001');

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
    test(
        "Given valid request data, when the createRequest method is executed, it should save the request record in the database successfully",
        () async {
      when(() => localStorageMock.write<String>(any(), any()))
          .thenAnswer((_) async => true);

      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.id).thenReturn(requisicao.id!);
      when(() => mockDocument.set(any()))
          .thenAnswer((_) async => Future<void>.value());

      final result = await requisitionReposiory.createRequestActive(requisicao);

      expect(result, requisicao.id);
      verify(() => fireStoreMock.collection(any())).called(2);
      verify(() => mockCollection.doc(any())).called(2);
      verify(() => mockDocument.id).called(2);
      verify(() => mockDocument.set(any())).called(2);
    });
  });

  /* group("find requests teste", (){
       /* verify(() => fireStoreMock.collection(any())).called(1);
      verify(() =>mockCollection.doc() ).called(1);
       verify(() => mockDocument.snapshots()).called(1);
      verify(() => mockSnapshot.exists).called(1);
      verify(() => mockSnapshot.data()).called(1); */
    test('Given a valid request,when is called findAndObserverRequestbyId,it should find and return stream of requisition', () async {
        
       final mockStreamRequisition = MockStreamRequisition();
      
       when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
       when(() => mockCollection.doc(any())).thenReturn(mockDocument);
       when(() => mockDocument.id).thenReturn('2');
       when(() => mockDocument.snapshots()).thenAnswer((_) => mockStreamRequisition); 
       when(() => mockStreamRequisition.isEmpty).thenAnswer((_) async => false);
       when(() => mockStreamRequisition.map(any())).thenAnswer((_)  => Stream.value(requisicao)); 
       
       when(() => mockSnapshot.exists).thenReturn(true);
      // when(() => mockSnapshot.data()).thenReturn(requisicao.toMap());
    
      final resul =  requisitionReposiory.findAndObserverRequestbyId(requisicao);
      
      await expectLater(resul,emits(isInstanceOf<Requisicao>()));
   

    });

  });  */

  group('updateRequisitonTests', () {
    final motoristaUp =
        requisicao.motorista!.copyWith(latitude: 2, longitude: 32);
    final requisitionUpdated = requisicao.copyWith(motorista: motoristaUp);

    test(
        'Give a requisition, whem to execute updataDataRequestActiveted.should update Requistion ',
        () async {
      when(() => localStorageMock.write<String>(any(), any()))
          .thenAnswer((_) async => true);
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.id).thenReturn(requisicao.id!);

      when(() => mockDocument.update(any()))
          .thenAnswer((_) async => Future<void>.value());

      final passager = passageiro.copyWith(email: "testeUpdate@hotmail.com");

      final dataUpdate = {
        'status': 'EM_VIAGEM',
        'passageiro': passager.toMap()
      };

      final result =
          await requisitionReposiory.updataDataRequestActiveted(requisicao);
      expect(result, isTrue);

      verify(() => fireStoreMock.collection(any())).called(2);
      verify(() => mockCollection.doc(any())).called(2);

      verify(() => mockDocument.update(any())).called(2);
    });

    test(
        'updateUserPositionRequestActiveted,should retunr RepositoryException when converter invalid json',
        () async {
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.update(any())).thenThrow(ArgumentError(''));

      expect(
          () => requisitionReposiory
              .updateUserPositionRequestActiveted(requisitionUpdated),
          throwsA(isA<RequestException>()));

      verify(() => fireStoreMock.collection(any())).called(1);
      verify(() => mockCollection.doc(any())).called(1);
      verify(() => mockDocument.update(any())).called(1);
    });
  });

  group('delete requisition', () {
    test(
        'Given a requisition ,whem delete is executed ,it should remove request on firebae',
        () async {
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);

      when(() => mockDocument.delete()).thenAnswer((_) => Future<void>.value());

      await requisitionReposiory.delete(requisicao);

      verify(() => fireStoreMock.collection(any())).called(1);
      verify(() => mockCollection.doc(any())).called(1);
      verify(() => mockDocument.delete()).called(1);
    });

    test(
        'Given a invalid requisition ,whem delete is executed ,it should throw a RequestException',
        () async {
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);

      when(() => mockDocument.delete())
          .thenThrow(FirebaseException(plugin: "plugin"));

      expect(() async => await requisitionReposiory.delete(requisicao),
          throwsA(isA<RequestException>()));
    });

    test(
        'Given a requisition ,whem deleteAcvitedReuest is executed ,it should remove request on firebase and localStorage and return true',
        () async {
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.delete()).thenAnswer((_) => Future<void>.value());
      when(() => mockDatabaseOffline.save(any(), any())).thenAnswer((_) async => 1);
      when(() => localStorageMock.remove(any())).thenAnswer((_) async => true);

      final result = await requisitionReposiory.deleteAcvitedRequest(requisicao);

      expect(result, isTrue);
      verify(() => fireStoreMock.collection(any())).called(1);
      verify(() => mockCollection.doc(any())).called(1);
      verify(() => mockDatabaseOffline.save(any(),any())).called(1);
      verify(() => mockDocument.delete()).called(1);
      verify(() => localStorageMock.remove(any())).called(1);
    });

    test('Given a invalid requisition ,when deleteAcvitedRequest is executed ,it should return false',
        () async {
      when(() => localStorageMock.remove(any())).thenAnswer((_) async => false);
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.delete()).thenAnswer((_) => Future<void>.value());

      final result =
          await requisitionReposiory.deleteAcvitedRequest(requisicao);

      expect(result, isFalse);
      verifyNever(() => fireStoreMock.collection(any()));
      verifyNever(() => mockCollection.doc(any()));
      verifyNever(() => mockDatabaseOffline.save(any(), any()));
      verifyNever(() => mockDocument.delete());
      verify(() => localStorageMock.remove(any())).called(1);
    });
  });

  test(
      'Given a invalid requisition ,whem deleteAcvitedReuest is executed ,it should throw a RequestException',
      () async {
    when(() => localStorageMock.remove(any())).thenAnswer((_) async => true);    
    when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocument);
    when(() => mockDocument.delete())
        .thenThrow(FirebaseException(plugin: "plugin"));  

    expect(
        () async => await requisitionReposiory.deleteAcvitedRequest(requisicao),
        throwsA(isA<RequestException>()));
    verify(() => localStorageMock.remove(any())).called(1);

    //  falta para fazer --- teste firebaseExceptions,disposer da lista de corridas ativas no app motorista
    //  feito teste para delete requistiom e deleteAcvitedReuest
    //  para commit realizado fluxo do app motorista até encerrear corrida
  });
}

final destino = Address(
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
final passageiro = Usuario(
    idUsuario: "p001",
    email: "passageiro@email.com",
    idRequisicaoAtiva: "r001",
    nome: "João Silva",
    tipoUsuario: "passageiro",
    senha: "senha123",
    latitude: -23.5515,
    longitude: -46.6344,
    balance: Decimal.parse('150.00'));

// Criando o objeto Usuario (motorista)
final motorista = Usuario(
    idUsuario: "m001",
    email: "motorista@email.com",
    idRequisicaoAtiva: "r001",
    nome: "Maria Santos",
    tipoUsuario: "motorista",
    senha: "senha456",
    latitude: -23.5520,
    longitude: -46.6350,
    balance: Decimal.parse('150.00'));

final paymentType = PaymentType(id: 1, type: 'dinheiro');
// Criando o objeto Requisicao
Requisicao requisicao = Requisicao(
  requestDate: DateTime.now(),
  paymentType: paymentType,
  id: "r001",
  destino: destino,
  passageiro: passageiro,
  status: RequestState.aguardando,
  motorista: motorista,
  valorCorrida: "25.50",
);
