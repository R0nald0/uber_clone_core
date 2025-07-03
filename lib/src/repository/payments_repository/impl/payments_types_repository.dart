import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uber_clone_core/src/core/exceptions/uber_rest_client_exception.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_response.dart';
import 'package:uber_clone_core/src/core/restclient/uber_clone_rest_client.dart';
import 'package:uber_clone_core/src/repository/payments_repository/i_payments_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class PaymentsTypesRepositoryImpl implements IPaymentsRepository {
  final FirebaseFirestore _firestore;
  final UberCloneRestClient _restClient;

  PaymentsTypesRepositoryImpl(
      {required FirebaseFirestore firestore,
      required UberCloneRestClient restclient})
      : _firestore = firestore,
        _restClient = restclient;

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
    } on ArgumentError catch (e, s) {
      log('Erro ao converter dados', error: e, stackTrace: s);
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

  @override
  Future<void> createPaymentIntent(double amount) async {
    try {
    
     final t = amount.toString().chandeToInt();
    
     t;
      final UberCloneResponse(:data) = await _restClient.unAuth().post(
          'create-payment-intent',
          data: {'amount': t, 'currency': 'brl'});
      final clientSecrete = data['clientSecret'];
    
     await Stripe.instance.initPaymentSheet(
      paymentSheetParameters:SetupPaymentSheetParameters(
        appearance: const PaymentSheetAppearance(
          primaryButton: PaymentSheetPrimaryButtonAppearance(
            colors: PaymentSheetPrimaryButtonTheme(
              light: PaymentSheetPrimaryButtonThemeColors(
                background: Colors.black,
                text: Colors.white
              )
            )
          )
        ),
        paymentIntentClientSecret: clientSecrete,
        merchantDisplayName: "Uber_clone_app",
       ) 
      );
     
    
     await Stripe.instance.presentPaymentSheet();
     await Stripe.instance.confirmPaymentSheetPayment();
     await Stripe.instance.presentPaymentSheet();
    
    } on UberRestClientException catch (e, s) {
      log("Erro ao cria payment-intent", error: e, stackTrace: s);
      throw PaymentException(message: "Erro ao criar pagamento");
    } on StripeException catch (e,s){
      log("Erro ao Realizar Pagamento", error: e, stackTrace: s);
      switch (e.error.code ) {
        case FailureCode.Canceled:{
            log("Pagamento Cancelado", error: e, stackTrace: s);
            throw PaymentException(message: "Pagamento Cancelado");
        }
             
        case FailureCode.Timeout:{
           log("Tempo para pagamento Expirou", error: e, stackTrace: s);
        throw PaymentException(message: "Pagamento Cancelado");
        }
        case FailureCode.Failed:
        case FailureCode.Unknown:
            log("Erro ao realizar pagamento", error: e, stackTrace: s);
            throw PaymentException(message: "Erro ao realizar pagamento");
        }
      
    }
  }

  @override
  Future<String> findAll() async{
      try {
      final UberCloneResponse(:data) = await _restClient.unAuth().get('all');
      final clientSecrete = data;
    
      return clientSecrete;
    } on UberRestClientException catch (e, s) {
      log("Erro ao cria payment-intent", error: e, stackTrace: s);
      throw PaymentException(message: "Erro ao criar pagamento");
    }
  }
}
