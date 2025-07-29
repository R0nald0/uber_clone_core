import 'dart:convert';

class Messages {
  Messages({
    required this.role,
    required this.content
  });
  final String role;
  final String content; 

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      role: map['role'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Messages.fromJson(String source) => Messages.fromMap(json.decode(source));
}