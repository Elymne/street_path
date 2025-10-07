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
}
