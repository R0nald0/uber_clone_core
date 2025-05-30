import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uber_clone_core/src/model/addres.dart';
import 'package:uber_clone_core/src/model/payment_type.dart';
import 'package:uber_clone_core/src/util/request_state.dart';


import 'usuario.dart';

class Requisicao {
  final String? id;
  final Address destino;
  final Usuario passageiro;
  final RequestState status;
  final Usuario? motorista;
  final String valorCorrida;
  final PaymentType paymentType;
  final DateTime requestDate;

  Requisicao(
      {required this.id,
      required this.destino,
      required this.paymentType,
      required this.motorista,
      required this.passageiro,
      required this.status,
      required this.valorCorrida,
      required this.requestDate});

  Requisicao.empty()
      : id = null,
        paymentType = PaymentType.empty(),
        destino = Address.emptyAddres(),
        motorista = Usuario.emptyUser(),
        passageiro = Usuario.emptyUser(),
        status = RequestState.nao_chamado,
        valorCorrida = '',
        requestDate = DateTime.now(),
        super();

/*   Map<String,dynamic> requestToMap(){

    Map<String,dynamic> dadosPassageiro={
      "idUsuario" :  passageiro.idUsuario,
      "nome":        passageiro.nome,
      "email":       passageiro.email,
      "tipoUsuario": passageiro.tipoUsuario,
      "latitude" :   passageiro.latitude,
      "longitude" :  passageiro.longitude,
    };

    Map<String,dynamic> dadosDestino={
      "rua":destino.rua,
      "nomeDestino":destino.nomeDestino,
      "bairro" : destino.bairro,
      "cep" : destino.cep,
      "cidade" :destino.cidade,
      "numero" :destino.numero,
      "latitude":destino.latitude,
      "longitude" :destino.longitude
    };


    Map<String,dynamic> dadosRequisicao ={
      "idRequisicao" :id,
      "status" :status.value,
      "valorCorrida" :valorCorrida,
      "motorista" : motorista,
      "passageiro": dadosPassageiro,
      "destino" :dadosDestino,
      "payment_type" : paymentType.toMap(),
    };

    return dadosRequisicao;
  }
 */

  Requisicao copyWith(
      {ValueGetter<String?>? id,
      Address? destino,
      Usuario? passageiro,
      RequestState? status,
      Usuario? motorista,
      PaymentType? paymentType,
      String? valorCorrida,
      DateTime? requestDate}) {
    return Requisicao(
        id: id != null ? id() : this.id,
        destino: destino ?? this.destino,
        passageiro: passageiro ?? this.passageiro,
        status: status ?? this.status,
        motorista: motorista ?? this.motorista,
        paymentType: paymentType ?? this.paymentType,
        valorCorrida: valorCorrida ?? this.valorCorrida,
        requestDate: requestDate ?? this.requestDate);
  }

  Map<String, dynamic> toMap() {
    return {
      'idRequisicao': id,
      'destino': destino.toMap(),
      'passageiro': passageiro.toMap(),
      'status': status.value,
      'motorista': motorista?.toMap(),
      'valorCorrida': valorCorrida,
      'payment_type': paymentType.toMap(),
      'request_date': requestDate.toIso8601String()
    };
  }

  factory Requisicao.fromMap(Map<String, dynamic> map) {
   
    return switch (map) {
      {
        'idRequisicao': final String id,
        'destino': final Map<String, dynamic> destino,
        'passageiro': final Map<String, dynamic> passageiro,
        'status': final String status,
        'motorista': final Map<String, dynamic>? motorista,
        'payment_type': final Map<String, dynamic> paymentType,
        'valorCorrida': final String valorCorrida,
        'request_date': final dynamic  requestDate
      } =>
        Requisicao(
            id: id,
            destino: Address.fromMap(destino),
            passageiro: Usuario.fromMap(passageiro),
            status: RequestState.nao_chamado.findByName(status),
            paymentType: PaymentType.fromMap(paymentType),
            motorista: motorista != null ? Usuario.fromMap(motorista) : null,
            valorCorrida: valorCorrida,
            requestDate: requestDate is Timestamp ? requestDate.toDate() : DateTime.parse(requestDate),
            ) ,
      _ => throw ArgumentError('Invalid json')
    };
  }

  String toJson() => json.encode(toMap());

  factory Requisicao.fromJson(String source) => Requisicao.fromMap(json.decode(source));
}
