import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class PaymentType {
   final int id;
  final String type;
   
  PaymentType.empty():this(id:1,type: 'money' ); 
  PaymentType({
    required this.id,
    required this.type
  });
 factory PaymentType.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc){
     return PaymentType(
      id: int.tryParse(doc.id) ?? 0, type: doc.data()['type']);
 }
 factory PaymentType.fromJson(Map<String,dynamic> json){
   return switch (json) {
       {
        'id' : final int id,
        'type' : final String type
       } => PaymentType(id: id, type: type),
       _=> throw ArgumentError("Inavalid json")
   };
 }
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }

  factory PaymentType.fromMap(Map<String, dynamic> map) {
    return PaymentType(
      id: map['id']?.toInt() ?? 0,
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

}
