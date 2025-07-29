
import 'dart:convert';

import 'package:uber_clone_core/src/model/messages.dart';

class IaRequest {
  final String model;
  final List<Messages> messages;
  IaRequest({
    required this.model,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  

  factory IaRequest.fromMap(Map<String, dynamic> map) {
    return switch(map){
      {
        'model' : final String model,
        'messages' : final List<Messages> messages
      }
         => IaRequest(
          model: model, 
          messages: messages
          )
      ,
      _=> throw ArgumentError(),
      
    };
  }

  String toJson() => json.encode(toMap());

  factory IaRequest.fromJson(String source) => IaRequest.fromMap(json.decode(source));

  IaRequest copyWith({
    String? model,
    List<Messages>? messages,
  }) {
    return IaRequest(
      model: model ?? this.model,
      messages: messages ?? this.messages,
    );
  }
}
