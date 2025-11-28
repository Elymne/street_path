import 'package:poc_street_path/core/data_model.dart';

class Reaction extends DataModel {
  final String contentId;
  final String authorName;
  final ReactionType flag;

  Reaction({
    required this.contentId,
    required super.id,
    required super.createdAt,
    required this.authorName,
    required this.flag,
  });

  static final Map<String, Type> allowed = {
    'id': String,
    'createdAt': int,
    'authorName': String,
    'contentId': String,
    'flag': int,
  };

  Map<String, Object> toRaw() {
    return {'id': id, 'createdAt': createdAt, 'authorName': authorName, 'contentId': contentId, 'flag': flag};
  }

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] as String,
      createdAt: json['createdAt'],
      contentId: json['contentId'] as String,
      authorName: json['authorName'] as String,
      flag: ReactionType.fromValue(json['flag'] as int),
    );
  }
}

enum ReactionType {
  unknown(-1),
  like(0),
  dislike(1);

  final int value;
  const ReactionType(this.value);

  static ReactionType fromValue(int value) {
    final reactionType = ReactionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ReactionType.unknown,
    );
    return reactionType;
  }
}
