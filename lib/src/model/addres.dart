import 'dart:convert';

class Address {
  final int? id;
  final String rua;
  final String nomeDestino;
  final String bairro;
  final String cep;
  final String cidade;
  final String numero;
  final double latitude;
  final double longitude;
  final bool favorite;

  Address(
      {this.id,
        required this.bairro,
      required this.cep,
      required this.cidade,
      required this.latitude,
      required this.longitude,
      required this.nomeDestino,
      required this.numero,
      required this.rua,
      this.favorite = false});

  Address.emptyAddres()
      : id = null,
        rua = '',
        bairro = '',
        cep = '',
        cidade = '',
        latitude = 0.0,
        longitude = 0.0,
        nomeDestino = '',
        numero = '',
        favorite = false,
        super();

  Address copyWith({
    int? id,
    String? rua,
    String? nomeDestino,
    String? bairo,
    String? cep,
    String? cidade,
    String? numero,
    double? latitude,
    double? longitude,
    bool? favorite
  }) {
    return Address(
      id : id ?? this.id,
      rua: rua ?? this.rua,
      nomeDestino: nomeDestino ?? this.nomeDestino,
      bairro: bairo ?? bairro,
      cep: cep ?? this.cep,
      cidade: cidade ?? this.cidade,
      numero: numero ?? this.numero,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      favorite: favorite ?? this.favorite
    );
  }

  Map<String, dynamic> toMap() {
    return {
       'id' : id,
      'rua': rua,
      'nomeDestino': nomeDestino,
      'bairo': bairro,
      'cep': cep,
      'cidade': cidade,
      'numero': numero,
      'latitude': latitude,
      'longitude': longitude,
      'favorite' :favorite
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      rua: map['rua'] ?? '',
      nomeDestino: map['nomeDestino'] ?? '',
      bairro: map['bairo'] ?? '',
      cep: map['cep'] ?? '',
      cidade: map['cidade'] ?? '',
      numero: map['numero'] ?? '',
      latitude: double.tryParse(map['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(map['longitude'].toString()) ?? 0.0,
      favorite:  map['favorite'] == 1 ? true : false
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));
}
