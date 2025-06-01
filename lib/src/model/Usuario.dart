import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Usuario {
  final String? idUsuario;
  final String email;
  final String nome;
  final String tipoUsuario;
  final String senha;
  final double latitude;
  final double longitude;
  final String? idRequisicaoAtiva;
  final Decimal balance;

  Usuario(
      {this.idUsuario,
      required this.email,
      required this.nome,
      required this.tipoUsuario,
      required this.senha,
      required this.latitude,
      required this.longitude,
      required this.balance,
      this.idRequisicaoAtiva});

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'email': email,
      'nome': nome,
      'tipoUsuario': tipoUsuario,
      'senha': senha,
      'latitude': latitude,
      'longitude': longitude,
      'idRequisicaoAtiva': idRequisicaoAtiva,
      'balance': double.parse(balance.toString())
    };
  }
  
/* 
  factory Usuario.fromFirestore(DocumentSnapshot snapshot) {
    //final user = snapshot.data as Usuario;
    return Usuario(
        idUsuario: snapshot.get('idUsuario') ?? '',
        email: snapshot.get('email') ?? '',
        nome: snapshot.get('nome') ?? '',
        tipoUsuario: snapshot.get('tipoUsuario') ?? '',
        senha: '',
        latitude: double.parse(snapshot.get('latitude')),
        longitude: double.parse(snapshot.get('longitude')),
        idRequisicaoAtiva: snapshot.get('idRequisicaoAtiva'),
        balance: Decimal.parse(snapshot.get('balance').toString()));
  } */

  Usuario.emptyUser()
      : email = '',
        idUsuario = '',
        latitude = 0,
        longitude = 0,
        nome = '',
        senha = '',
        tipoUsuario = '',
        idRequisicaoAtiva = '',
        balance = Decimal.zero,
        super();

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
        idUsuario: map['idUsuario'],
        email: map['email'] ?? '',
        nome: map['nome'] ?? '',
        tipoUsuario: map['tipoUsuario'] ?? '',
        senha: map['senha'] ?? '',
        latitude: map['latitude']?.toDouble() ?? 0.0,
        longitude: map['longitude']?.toDouble() ?? 0.0,
        idRequisicaoAtiva: map['idRequisicaoAtiva'] ?? '',
        balance: Decimal.fromJson(map['balance'].toString()));
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));
  Usuario copyWith({
    ValueGetter<String?>? idUsuario,
    String? email,
    String? nome,
    String? tipoUsuario,
    String? senha,
    double? latitude,
    double? longitude,
    ValueGetter<String?>? idRequisicaoAtiva,
    Decimal? balance,
  }) {
    return Usuario(
      idUsuario: idUsuario != null ? idUsuario() : this.idUsuario,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      senha: senha ?? this.senha,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      idRequisicaoAtiva: idRequisicaoAtiva != null
          ? idRequisicaoAtiva()
          : this.idRequisicaoAtiva,
      balance: balance ?? this.balance,
    );
  }
}
