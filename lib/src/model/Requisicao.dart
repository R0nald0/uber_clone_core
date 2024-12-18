

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uber_clone_core/src/model/addres.dart';

import 'Usuario.dart';

class Requisicao {
  final String? id;
  final Address destino;
  final Usuario passageiro;
  final String status;
  final Usuario? motorista;
  final String valorCorrida;
  
  Requisicao({required this.id, required this.destino,required this.motorista,required this.passageiro,required this.status,required this.valorCorrida});

 /*  Requisicao.consulta(){
      //OBTENDO ID REQUISICAO DA COLLECION
      DocumentReference ref = Banco.db.collection("requisicao").doc();
      this.id = ref.id;
  } */
  
  Requisicao.empty() :
    id =null,
    destino =Address.emptyAddres(),
    motorista =Usuario.emptyUser(),
    passageiro =Usuario.emptyUser(),
    status ='',
    valorCorrida ='',
    super();


  Map<String,dynamic> dadosPassageiroToMap(){

    Map<String,dynamic> dadosPassageiro={
      "idUsuario" :  passageiro.idUsuario,
      "nome":        passageiro.nome,
      "email":       passageiro.email,
      "tipoUsuario": passageiro.tipoUsuario,
      "latitude" :   passageiro.latitude,
      "longitude" :  passageiro.longitude
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
      "status" :status,
      "valorCorrida" :valorCorrida,
      "motorista" : motorista,
      "passageiro": dadosPassageiro,
      "destino" :dadosDestino
    };

    return dadosRequisicao;
  }


  Requisicao copyWith({
    ValueGetter<String?>? id,
    Address? destino,
    Usuario? passageiro,
    String? status,
    Usuario? motorista,
    String? valorCorrida,
  }) {
    return Requisicao(
      id: id != null ? id() : this.id,
      destino: destino ?? this.destino,
      passageiro: passageiro ?? this.passageiro,
      status: status ?? this.status,
      motorista: motorista ?? this.motorista,
      valorCorrida: valorCorrida ?? this.valorCorrida,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idRequisicao': id,
      'destino': destino.toMap(),
      'passageiro': passageiro.toMap(),
      'status': status,
      'motorista': motorista?.toMap(),
      'valorCorrida': valorCorrida,
    };
  }

  factory Requisicao.fromMap(Map<String, dynamic> map) {
    return Requisicao(
      id: map['idRequisicao'],
      destino: Address.fromMap(map['destino']),
      passageiro: Usuario.fromMap(map['passageiro']),
      status: map['status'] ?? '',
      motorista: map['motorista'] != null ? Usuario.fromMap(map['motorista']) : null,
      valorCorrida: map['valorCorrida'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Requisicao.fromJson(String source) => Requisicao.fromMap(json.decode(source));
}
