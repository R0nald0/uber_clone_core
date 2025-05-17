import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_core/src/core/exceptions/repository_exception.dart';
import 'package:uber_clone_core/src/repository/payments_repository/i_payments_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class PaymentsTypesRepositoryImpl implements IPaymentsRepository {
  final FirebaseFirestore _firestore;

  PaymentsTypesRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<List<PaymentType>> getTypesPayment() async {
    try {
      final qSnapshot = await _firestore
          .collection(UberCloneConstants.PAYMENTS_DATA_BASE_NAME)
          .get();

      if (qSnapshot.docs.isEmpty) {
         return List.empty();
      }
    
      return qSnapshot.docs
          .map<PaymentType>((doc) => PaymentType.fromQuerySnapshot(doc))
          .toList();
    } on ArgumentError catch (e,s) {
      log('Erro ao converter dados',error: e,stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar tipos de pagemntos');
    }
  }

  @override
  Future<PaymentType> findById(int id) async {
    try {
      final doc = await _firestore
          .collection(UberCloneConstants.PAYMENTS_DATA_BASE_NAME)
          .doc(id.toString())
          .get();
      if (!doc.exists || doc.data() == null) {
        throw PaymentTypeNotFound();
      }
      return PaymentType.fromJson(doc.data()!);
    } on PaymentTypeNotFound catch (e, s) {
      log('Erro ao buscar id inválido', error: e, stackTrace: s);
      throw PaymentTypeNotFound();
    } on ArgumentError catch (e, s) {
      log('Erro na conversão do json', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar dados');
    }
  }
}
