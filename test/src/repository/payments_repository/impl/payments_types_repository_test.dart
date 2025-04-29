import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uber_clone_core/src/model/payment_type.dart';
import 'package:uber_clone_core/src/repository/payments_repository/impl/payments_types_repository.dart';
 
 
class MockLocalfireStore extends Mock implements FirebaseFirestore {}
 // ignore: subtype_of_sealed_class
 class MockCollection extends Mock implements CollectionReference<Map<String, dynamic>>{}
 class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>>{}
 class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>>{}

void main() {

    late  MockCollection mockCollection ; 
    late  MockQuerySnapshot mockQuerySnapshot ; 
    late  MockQueryDocumentSnapshot mockQueryDocumentSnapshot ; 
    late  MockLocalfireStore mockFireStore ; 
    late  PaymentsTypesRepositoryImpl paymentsRepository; 
   setUp((){
      mockQuerySnapshot =MockQuerySnapshot();
      mockQueryDocumentSnapshot =MockQueryDocumentSnapshot();
      mockFireStore = MockLocalfireStore();
      mockCollection = MockCollection();
      paymentsRepository = PaymentsTypesRepositoryImpl(firestore: mockFireStore);   
   }); 
  

   

  group("find paymenst", (){
  
    test("Should find payments type", ()async {
      when(() => mockFireStore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([
        mockQueryDocumentSnapshot
      ]);
       when(() => mockQueryDocumentSnapshot.data()).thenReturn({'payment' : "Dinheiro"});
      final result =await paymentsRepository.getTypesPayment();
      expect(result, isInstanceOf<List<PaymentType>>());
   });

  });
}
final List<PaymentType> paymentTypes = [
  PaymentType(type: 'Crédito'),
  PaymentType(type: 'Débito'),
  PaymentType(type: 'Pix'),
  PaymentType(type: 'Dinheiro'),
  PaymentType(type: 'Boleto'),
];