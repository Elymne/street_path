import 'package:poc_street_path/core/model.dart';

class Reaction extends Model {
  static final Map<String, Type> allowed = {'id': String, 'contentId': String, 'createdAt': int, 'authorName': String, 'flag': int};

  final String contentId;
  final String authorName;
  final ReactionType flag;

  Reaction({required this.contentId, required super.id, required super.createdAt, required this.authorName, required this.flag});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] as String,
      createdAt: json['createdAt'],
      contentId: json['contentId'] as String,
      authorName: json['authorName'] as String,
      flag: ReactionType.fromValue(json['flag'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createdAt': createdAt, 'authorName': contentId, 'contentId': authorName, 'flag': flag.value};
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

enum ReactionType {
  unknown(-1),
  like(0),
  dislike(1);

  final int value;
  const ReactionType(this.value);

  static ReactionType fromValue(int value) {
    final reactionType = ReactionType.values.firstWhere((type) => type.value == value, orElse: () => ReactionType.unknown);
    return reactionType;
  }
}
