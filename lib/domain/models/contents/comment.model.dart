import 'package:poc_street_path/core/model.dart';

class Comment extends Model {
  static final Map<String, Type> allowed = {'id': String, 'createdAt': int, 'contentId': String, 'authorName': String, 'text': String};

  final String contentId;
  final String authorName;
  final String text;

  Comment({required super.id, required this.contentId, required super.createdAt, required this.authorName, required this.text});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      contentId: json['contentId'] as String,
      authorName: json['authorName'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createdAt': createdAt, 'contentId': contentId, 'authorName': authorName, 'text': text};
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
