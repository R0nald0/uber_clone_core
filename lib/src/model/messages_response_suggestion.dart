import 'dart:convert';

class MessagesResponseSuggestion {
  final String title;
  final String role ;
  final String description;
  MessagesResponseSuggestion({
    required this.title,
    required this.role,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'role':  role,
      'description': description,
    };
  }

  factory MessagesResponseSuggestion.fromMap(Map<String, dynamic> map) {
    return  switch(map){{
      'title' : final String title,
      'role' : final String role,
      'description' : final String description
    }
    => MessagesResponseSuggestion(title: title, role: role, description: description),
     _=> throw ArgumentError("Invalid json")
    };
  }

  String toJson() => json.encode(toMap());

  factory MessagesResponseSuggestion.fromJson(String source) => MessagesResponseSuggestion.fromMap(json.decode(source));

  MessagesResponseSuggestion copyWith({
    String? title,
    String? role ,
    String? description,
  }) {
    return MessagesResponseSuggestion(
      title: title ?? this.title,
      role : role ?? this.role,
      description: description ?? this.description,
    );
  }
}

