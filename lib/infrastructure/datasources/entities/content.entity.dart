import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';

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

  static PostEntity fromPost(Content post) {
    return PostEntity()
      ..id = post.id
      ..createdAt = post.createdAt
      ..userId = post.authorName
      ..flowName = post.flowName
      ..bounces = post.bounces;
  }

  Content toPost() {
    return Content(id: id ?? '', createdAt: createdAt ?? 0, authorName: userId ?? '', flowName: flowName ?? '', bounces: bounces ?? 0);
  }
}
