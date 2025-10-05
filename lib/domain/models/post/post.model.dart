import 'package:poc_street_path/core/model.dart';
import 'package:poc_street_path/domain/models/post/reaction.model.dart';
import 'package:poc_street_path/domain/models/post/subpost.model.dart';

abstract class Post extends Model {
  final String userId;
  final String flowName;
  final int bounces;
  final List<Reaction> reactions;
  final List<Subpost> subposts;

  Post({
    required super.id,
    required super.createdAt,
    required this.userId,
    required this.bounces,
    required this.flowName,
    required this.reactions,
    required this.subposts,
  });
}
