import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';

@Entity()
class ReactionEntity {
  @Id()
  int obId = 0;

  @Unique()
  String id;

  int createdAt;
  String authorName;
  int? flag;

  ReactionEntity({required this.id, required this.createdAt, required this.authorName, required this.flag});

  static ReactionEntity fromModel(Reaction reaction) {
    return ReactionEntity(id: reaction.id, createdAt: reaction.createdAt, authorName: reaction.authorName, flag: reaction.flag.value);
  }
}
