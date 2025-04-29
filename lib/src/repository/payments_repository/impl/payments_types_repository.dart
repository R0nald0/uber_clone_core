import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_core/src/core/exceptions/payment_type_not_found.dart';
import 'package:uber_clone_core/src/model/payment_type.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class PaymentsTypesRepositoryImpl {
  final FirebaseFirestore _firestore;

  PaymentsTypesRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<List<PaymentType>> getTypesPayment() async {
    final qSnapshot = await _firestore
        .collection(UberCloneConstants.PAYMENTS_DATA_BASE_NAME)
        .get();

    if (qSnapshot.docs.isEmpty) {
       throw  PaymentTypeNotFound();
    }
     
    final  data = qSnapshot.docs.map<PaymentType>((doc) => PaymentType.fromMap(doc.data())).toList() ;
    return data;
  }
}
