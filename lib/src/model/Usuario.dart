import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Usuario({
    this.idUsuario,
    required this.email,
    required this.nome,
    required this.tipoUsuario,
    required this.senha,
    required this.latitude,
    required this.longitude,
  });


  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'email': email,
      'nome': nome,
      'tipoUsuario': tipoUsuario,
      'senha': senha,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
  
  factory Usuario.fromFirestore( DocumentSnapshot snapshot ){
     return  Usuario(
        idUsuario: snapshot.get('idUsuario') ?? '',
        email: snapshot.get('email')?? '', 
        nome:  snapshot.get('nome') ?? '', 
        tipoUsuario: snapshot.get('tipoUsuario') ?? '', 
        senha: '', 
        latitude: 0, 
        longitude: 0
        );
  }
  
  Usuario.emptyUser() :
  email = '',
  idUsuario ='',
  latitude =0,
  longitude= 0,
  nome = '',
  senha = '',
  tipoUsuario = '',
  super();

  Map<String,dynamic> toMapUp(){
    Map<String,dynamic> map={
      'idUsuario' : idUsuario,
      "nome" : nome,
      "email":email,
      "tipoUsuario":tipoUsuario,
      "latitude"   : latitude,
      "longitude" : longitude
    };
    return map;
  }

  Usuario copyWith({
    ValueGetter<String?>? idUsuario,
    String? email,
    String? nome,
    String? tipoUsuario,
    String? senha,
    double? latitude,
    double? longitude,
  }) {
    return Usuario(
      idUsuario: idUsuario != null ? idUsuario() : this.idUsuario,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      senha: senha ?? this.senha,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['idUsuario'],
      email: map['email'] ?? '',
      nome: map['nome'] ?? '',
      tipoUsuario: map['tipoUsuario'] ?? '',
      senha: map['senha'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) => Usuario.fromMap(json.decode(source));
}
