import 'dart:convert';


class PaymentType {
   final String type; 

   PaymentType({required this.type});
   
    

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }

  factory PaymentType.fromMap(Map<String, dynamic> map) {
    return PaymentType(
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentType.fromJson(String source) => PaymentType.fromMap(json.decode(source));
}

