import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/models/contents/content_text.model.dart';

@Entity()
class ContentTextEntity {
  @Id()
  int obId = 0;

  @Unique()
  String id;

  int createdAt;
  String authorName;
  String flowName;
  int bounces;
  String title;

  String text;

  ContentTextEntity({
    required this.id,
    required this.createdAt,
    required this.authorName,
    required this.flowName,
    required this.bounces,
    required this.title,
    required this.text,
  });

  static ContentTextEntity fromModel(ContentText contentText) {
    return ContentTextEntity(
      id: contentText.id,
      createdAt: contentText.createdAt,
      authorName: contentText.authorName,
      flowName: contentText.flowName,
      bounces: contentText.bounces,
      title: contentText.title,
      text: contentText.text,
    );
  }

  Content toPost() {
    return ContentText(
      id: id,
      createdAt: createdAt,
      authorName: authorName,
      flowName: flowName,
      bounces: bounces,
      title: title,
      text: text,
    );
  }
}
