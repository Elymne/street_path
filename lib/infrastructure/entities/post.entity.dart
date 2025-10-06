import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/infrastructure/entities/reaction.entity.dart';
import 'package:poc_street_path/infrastructure/entities/subpost.entity.dart';

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

  @Backlink()
  final reactions = ToMany<ReactionEntity>();

  @Backlink()
  final subposts = ToMany<SubpostEntity>();
}
