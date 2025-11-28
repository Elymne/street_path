import 'package:poc_street_path/core/data_model.dart';

class Comment extends DataModel {
  final String contentId;
  final String authorName;
  final String text;

  Comment({
    required super.id,
    required this.contentId,
    required super.createdAt,
    required this.authorName,
    required this.text,
  });

  static final Map<String, Type> allowed = {
    'id': String,
    'createdAt': int,
    'contentId': String,
    'authorName': String,
    'text': String,
  };

  Map<String, Object> toRaw() {
    return {'id': id, 'createdAt': createdAt, 'contentId': contentId, 'authorName': authorName, 'text': text};
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      contentId: json['contentId'] as String,
      authorName: json['authorName'] as String,
      text: json['text'] as String,
    );
  }
}
