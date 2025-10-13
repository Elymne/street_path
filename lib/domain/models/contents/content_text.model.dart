import 'package:poc_street_path/domain/models/contents/content.model.dart';

class ContentText extends Content {
  static final Map<String, Type> allowed = {
    'id': String,
    'createdAt': int,
    'authorName': String,
    'bounces': int,
    'flowName': String,
    'title': String,
    'text': String,
  };

  final String text;

  ContentText({
    required super.id,
    required super.createdAt,
    required super.authorName,
    required super.bounces,
    required super.flowName,
    required super.title,
    required this.text,
  });

  factory ContentText.fromJson(Map<String, dynamic> json) {
    return ContentText(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      authorName: json['authorName'] as String,
      bounces: json['bounces'] as int,
      flowName: json['flowName'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'authorName': authorName,
      'bounces': bounces,
      'flowName': flowName,
      'title': title,
      'text': text,
    };
  }

  static bool isValidJson(Map<String, dynamic> json) {
    final allowedKey = allowed.keys.toSet();
    final jsonKeys = json.keys.toSet();

    if (allowedKey.length != jsonKeys.length) {
      return false;
    }

    final extraKeys = jsonKeys.difference(allowedKey);
    if (extraKeys.isNotEmpty) {
      return false;
    }

    for (final key in allowedKey.intersection(jsonKeys)) {
      final expectedType = allowed[key];
      final value = json[key];

      if (value != null && value.runtimeType != expectedType) {
        return false;
      }
    }

    return true;
  }
}
