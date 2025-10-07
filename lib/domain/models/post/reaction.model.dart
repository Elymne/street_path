import 'package:poc_street_path/core/model.dart';

class Reaction extends Model {
  final String userId;
  final bool isLiked;
  final int? flag; // todo : should represent which type of reaction this is, an enum should be used.

  Reaction({required super.id, required super.createdAt, required this.userId, required this.isLiked, required this.flag});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] as String,
      createdAt: json['createdAt'],
      userId: json['userId'] as String,
      isLiked: json['isLiked'] as bool,
      flag: json['flag'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createdAt': createdAt, 'userId': userId, 'isLiked': isLiked, 'flag': flag};
  }

  static bool isValidJson(Map<String, dynamic> json) {
    return json.containsKey('id') &&
        json.containsKey('createdAt') &&
        json.containsKey('userId') &&
        json.containsKey('isLiked') &&
        json.containsKey('flag') &&
        json['id'] is String &&
        json['createdAt'] is int &&
        json['userId'] is String &&
        json['isLiked'] is bool &&
        json['flag'] is int;
  }
}
