import 'package:poc_street_path/domain/models/contents/content.model.dart';

class ContentText extends Content {
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
    return json.containsKey('id') &&
        json.containsKey('createdAt') &&
        json.containsKey('authorName') &&
        json.containsKey('bounces') &&
        json.containsKey('flowName') &&
        json.containsKey('title') &&
        json.containsKey('text') &&
        json['id'] is String &&
        json['createdAt'] is int &&
        json['authorName'] is String &&
        json['bounces'] is int &&
        json['flowName'] is String &&
        json['title'] is String &&
        json['text'] is String;
  }
}
