import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';

import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/core/local_storage/impl/local_storage_impl.dart';
import 'package:uber_clone_core/src/repository/user_repository/impl/user_repository_impl.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

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

class MockLocalStorage extends Mock implements LocalStorageImpl {}

class MockAppUberLog extends Mock implements IAppUberLog {}

void main() {
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockSnapshot;

  late UserRepositoryImpl userRepositoryImpl;
  late MockAppUberLog logMock;
  late MockLocalStorage localStorageMock;
  late MockLocalfireStore fireStoreMock;
  late Usuario usuarioJson;

  setUp(() async {
        mockCollection = MockCollectionReference();
        mockDocument = MockDocumentReference();
        mockSnapshot = MockDocumentSnapshot();
        logMock = MockAppUberLog();
        localStorageMock = MockLocalStorage();
        fireStoreMock = MockLocalfireStore();

        userRepositoryImpl = UserRepositoryImpl(
            database: fireStoreMock,
            localStoreage: localStorageMock,
            log: logMock);

            
        usuarioJson = Usuario(
          idUsuario: '123',
          email: 'teste@email.com',
          nome: 'João Silva',
          tipoUsuario: 'Admin',
          senha: 'senha123',
          latitude: -23.55052,
          longitude: -46.633308,
          balance: Decimal.parse('150.00')
        );
      });

  group('getDataUserOn cases', () {
    test('getDataUserOn should return the user data saved in localStorage',
        () async {
     

      when(() => localStorageMock.containsKey(any()))
          .thenAnswer((_) async => true);

      when(() => localStorageMock.read<String>(any()))
          .thenAnswer((_) async => usuarioJson.toJson());

      final resposnse = await userRepositoryImpl.getDataUserOn("aaaa");

      expect(resposnse!.nome, "João Silva");
      verify(() => localStorageMock.containsKey(any())).called(1);
      verify(() => localStorageMock.read<String>(any())).called(1);
    });

    test('getDataUserOnFirebase  should fetch user data from firebase ',
        () async {
    

      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn(usuarioJson.toMap());
      // when(() =>mockSnapshot.get('email') ).thenReturn('teste@email.com');

      final result = await userRepositoryImpl.getDataUserOnFirebase("123");
      expect(result.email, 'teste@email.com');
      verify(() => mockCollection.doc(any())).called(1);
      verify(() => mockDocument.get()).called(1);
      verify(() => mockSnapshot.data()).called(1);
    });

    test( 'getDataUserOn when localStorage  not contains user data,should find data from online databese', () async {
      
      when(() => localStorageMock.write<String>(any(), any())).thenAnswer((_) async => true);
      when( () => localStorageMock.containsKey(any())).thenAnswer((_) async => false);

      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn(usuarioJson.toMap());

      final result = await userRepositoryImpl.getDataUserOn("a");

      expect(result!.email, 'teste@email.com');
      expect(result, isInstanceOf<Usuario>());

      verify(() => localStorageMock.write<String>(any(), any())).called(1);
      verify( () => mockDocument.get()).called(1);
    });
  });
   
  group("update data user", (){
    
    test('updateUser should update user data and return true', () async{
      
      when(() => fireStoreMock.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(() => mockDocument.update(any())).thenAnswer((invocation) => Future<void>.value());
      when(() => localStorageMock.write<String>(any(),any())).thenAnswer((_) async => true);
     
      final result =  await userRepositoryImpl.updateUser(usuarioJson);

      expect(result, isTrue);
      verify(() => fireStoreMock.collection(any())).called(1);
      verify(() => mockCollection.doc(any())).called(1);
      verify(() => mockDocument.update(any())).called(1);
      verify(() => localStorageMock.write<String>(any(),any())).called(1);
    });
  });

}
