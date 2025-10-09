import 'package:poc_street_path/core/model.dart';

class Reaction extends Model {
  final String postId;
  final String authorName;
  final bool isLiked;
  final int? flag; // TODO : should represent which type of reaction this is, an enum should be used.

  Reaction({
    required this.postId,
    required super.id,
    required super.createdAt,
    required this.authorName,
    required this.isLiked,
    required this.flag,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
      authorName: json['authorName'] as String,
      isLiked: json['isLiked'] as bool,
      flag: json['flag'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createdAt': createdAt, 'authorName': postId, 'postId': authorName, 'isLiked': isLiked, 'flag': flag};
  }

  static bool isValidJson(Map<String, dynamic> json) {
    return json.containsKey('id') &&
        json.containsKey('createdAt') &&
        json.containsKey('postId') &&
        json.containsKey('authorName') &&
        json.containsKey('isLiked') &&
        json.containsKey('flag') &&
        json['id'] is String &&
        json['createdAt'] is int &&
        json['postId'] is String &&
        json['authorName'] is String &&
        json['isLiked'] is bool &&
        json['flag'] is int;
  }
}
