import 'package:poc_street_path/domain/models/contents/content_link.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ContentLinkEntity {
  @Id()
  int obId = 0;

  @Unique()
  String id;

  int createdAt;
  String authorName;
  String flowName;
  int bounces;
  String title;

  String ref;
  String description;

  ContentLinkEntity({
    required this.id,
    required this.createdAt,
    required this.authorName,
    required this.flowName,
    required this.bounces,
    required this.title,
    required this.ref,
    required this.description,
  });

  static ContentLinkEntity fromModel(ContentLink contentLink) {
    return ContentLinkEntity(
      id: contentLink.id,
      createdAt: contentLink.createdAt,
      authorName: contentLink.authorName,
      flowName: contentLink.flowName,
      bounces: contentLink.bounces,
      title: contentLink.title,
      ref: contentLink.ref,
      description: contentLink.description,
    );
  }

  ContentLink toModel() {
    return ContentLink(
      id: id,
      createdAt: createdAt,
      authorName: authorName,
      flowName: flowName,
      bounces: bounces,
      title: title,
      ref: ref,
      description: description,
    );
  }
}
