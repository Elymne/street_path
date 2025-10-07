import 'package:poc_street_path/core/model.dart';

class Subpost extends Model {
  final String userId;
  final String comment;

  Subpost({required super.id, required super.createdAt, required this.userId, required this.comment});

  factory Subpost.fromJson(Map<String, dynamic> json) {
    return Subpost(
      id: json['id'] as String,
      createdAt: json['createdAt'],
      userId: json['userId'] as String,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createdAt': createdAt, 'userId': userId, 'comment': comment};
  }

  static bool isValidJson(Map<String, dynamic> json) {
    return json.containsKey('id') &&
        json.containsKey('createdAt') &&
        json.containsKey('userId') &&
        json.containsKey('comment') &&
        json['id'] is String &&
        json['createdAt'] is int &&
        json['userId'] is String &&
        json['comment'] is String;
  }
}
