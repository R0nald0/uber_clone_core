import 'dart:convert';

class IaRequestDto {
   final String role;
   final String content;
  IaRequestDto({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory IaRequestDto.fromMap(Map<String, dynamic> map) {
    return IaRequestDto(
      role: map['role'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IaRequestDto.fromJson(String source) => IaRequestDto.fromMap(json.decode(source));
}

