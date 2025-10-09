import 'package:poc_street_path/core/model.dart';

class Comment extends Model {
  final String authorName;
  final String text;

  Comment({required super.id, required super.createdAt, required this.authorName, required this.text});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      createdAt: json['createdAt'],
      authorName: json['authorId'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createdAt': createdAt, 'authorName': authorName, 'text': text};
  }

  static bool isValidJson(Map<String, dynamic> json) {
    return json.containsKey('id') &&
        json.containsKey('createdAt') &&
        json.containsKey('authorName') &&
        json.containsKey('text') &&
        json['id'] is String &&
        json['createdAt'] is int &&
        json['authorName'] is String &&
        json['text'] is String;
  }
}
