import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/core/exceptions/payment_type_not_found.dart';
import 'package:uber_clone_core/src/core/exceptions/repository_exception.dart';
import 'package:uber_clone_core/src/model/payment_type.dart';
import 'package:uber_clone_core/src/repository/payments_repository/impl/payments_types_repository.dart';
 
 
class MockLocalfireStore extends Mock implements FirebaseFirestore {}
 // ignore: subtype_of_sealed_class
 class MockCollection extends Mock implements CollectionReference<Map<String, dynamic>>{}
 class MockDocumentreference extends Mock implements DocumentReference<Map<String, dynamic>>{}
 class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>>{}

 class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>>{}
 class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>>{}

void main() {

    late  MockCollection mockCollection ; 
    late  MockDocumentreference mockDocumentreference;
    late  MockDocumentSnapshot mockDocumentSnapshot;
    late  MockQuerySnapshot mockQuerySnapshot ; 
    late  MockQueryDocumentSnapshot mockQueryDocumentSnapshot ; 
    late  MockLocalfireStore mockFireStore ; 
    late  PaymentsTypesRepositoryImpl paymentsRepository; 
   setUp((){
      mockQuerySnapshot =MockQuerySnapshot();
      mockDocumentreference = MockDocumentreference();
      mockDocumentSnapshot = MockDocumentSnapshot();
      mockQueryDocumentSnapshot =MockQueryDocumentSnapshot();
      mockFireStore = MockLocalfireStore();
      mockCollection = MockCollection();
      paymentsRepository = PaymentsTypesRepositoryImpl(firestore: mockFireStore);   
   }); 
  

   

  group("find paymenst", (){
  
    test("getTypesPayment,Should find payments type", ()async {
      when(() => mockFireStore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([
        mockQueryDocumentSnapshot,
        mockQueryDocumentSnapshot,
        mockQueryDocumentSnapshot,
      ]);
      when(() => mockQueryDocumentSnapshot.data()).thenReturn(paymentTypes.first.toMap());

      final result =await paymentsRepository.getTypesPayment();
      expect(result, isNotEmpty);
      expect(result.length, 3 );
       verify(() => mockFireStore.collection(any()),).called(1);
       verify(() => mockCollection.get()).called(1);
       verify(() => mockQuerySnapshot.docs).called(2);
       verify(() => mockQueryDocumentSnapshot.data()).called(3);
   });
    
    test("getTypesPayment,Should return empty list when List<QueryDocumentSnapshot> is empty", ()async {
      when(() => mockFireStore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(List.empty());
      when(() => mockQueryDocumentSnapshot.data()).thenReturn(paymentTypes.first.toMap());

      final result =await paymentsRepository.getTypesPayment();
      expect(result, isEmpty);

       verify(() => mockFireStore.collection(any()),).called(1);
       verify(() => mockCollection.get()).called(1);
       verify(() => mockQuerySnapshot.docs).called(1);
       verifyNever(() => mockQueryDocumentSnapshot.data());
   });
     
   test('getTypesPayment,should throw a RepositoryException when json invalid', ()async{
     
      when(() => mockFireStore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([
        mockQueryDocumentSnapshot,
      ]);
      when(() => mockQueryDocumentSnapshot.data()).thenReturn({'t':'adsa'});
  
      expect(()async => paymentsRepository.getTypesPayment(),throwsA(isA<RepositoryException>()) );
       verify(() => mockFireStore.collection(any()),).called(1);
       verify(() => mockCollection.get(any()),).called(1);
    
   });

   test('Given id valid,when findById is executed, should return a paymentType', ()async{
     
      when(() =>mockFireStore.collection(any())).thenReturn(mockCollection);
      when(() =>mockCollection.doc(any())).thenReturn(mockDocumentreference);
      when(() =>mockDocumentreference.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(() =>mockDocumentSnapshot.exists).thenReturn(true);
      when(() =>mockDocumentSnapshot.data()).thenReturn(paymentTypes.first.toMap());
      
      final result = await paymentsRepository.findById(1);
       
       expect(result.type, 'Crédito');
       expect(result.id, 4);
       verify(() => mockFireStore.collection(any()),).called(1);
       verify(() => mockCollection.doc(any()),).called(1);
       verify(() => mockDocumentreference.get()).called(1);
       verify(() => mockDocumentSnapshot.exists).called(1);
       verify(() => mockDocumentSnapshot.data()).called(2);
   });

   test('Given id invalid,when findById is executed, should throw a PaymentTypeNotFound', ()async{
     
      when(() =>mockFireStore.collection(any())).thenReturn(mockCollection);
      when(() =>mockCollection.doc(any())).thenReturn(mockDocumentreference);
      when(() =>mockDocumentreference.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(() =>mockDocumentSnapshot.exists).thenReturn(false);
  
      expect(()async => paymentsRepository.findById(1),throwsA(isA<PaymentTypeNotFound>()) );
       verify(() => mockFireStore.collection(any()),).called(1);
       verify(() => mockCollection.doc(any()),).called(1);
       verify(() => mockDocumentreference.get()).called(1);
        
   });

   test('should throw a RepositoryException when json invalid', ()async{
     
      when(() =>mockFireStore.collection(any())).thenReturn(mockCollection);
      when(() =>mockCollection.doc(any())).thenReturn(mockDocumentreference);
      when(() =>mockDocumentreference.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(() =>mockDocumentSnapshot.exists).thenReturn(true);
      when(() =>mockDocumentSnapshot.data()).thenReturn({'t':'adsa'});
      
  
      expect(()async => paymentsRepository.findById(1),throwsA(isA<RepositoryException>()) );
       verify(() => mockFireStore.collection(any()),).called(1);
       verify(() => mockCollection.doc(any()),).called(1);
       verify(() => mockDocumentreference.get()).called(1);
       
         
   });

  });
}
final List<PaymentType> paymentTypes = [
  PaymentType(type: 'Crédito', id: 4),
  PaymentType(type: 'Bitcoin', id: 3),
  PaymentType(type: 'Pix', id: 1),
  PaymentType(type: 'Dinheiro', id: 2),

];