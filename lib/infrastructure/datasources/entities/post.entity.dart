import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/reaction.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/subpost.entity.dart';

@Entity()
class PostEntity {
  @Id()
  int obId = 0;

  @Unique()
  String? id;

  int? createdAt;
  String? userId;
  String? flowName;
  int? bounces;
  final reactions = ToMany<ReactionEntity>();
  final subposts = ToMany<SubpostEntity>();

  // static PostEntity fromPost(Post post) {
  //   final entity =
  //       PostEntity()
  //         ..id = post.id
  //         ..createdAt = post.createdAt
  //         ..userId = post.userId
  //         ..flowName = post.flowName
  //         ..bounces = post.bounces;

  //   entity.reactions.addAll(post.reactions.map((r) => ReactionEntity.fromReaction(r)));
  //   entity.subposts.addAll(post.subposts.map((s) => SubpostEntity.fromSubpost(s)));
  //   return entity;
  // }
}
