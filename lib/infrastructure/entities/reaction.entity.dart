import 'package:objectbox/objectbox.dart';

@Entity()
class ReactionEntity {
  @Id()
  int obId = 0;

  @Unique()
  String? id;

  int? createdAt;

  String? userId;

  bool? isLiked;

  int? flag;
}
