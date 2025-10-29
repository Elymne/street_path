import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_text.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ContentTextEntity {
  @Id()
  int obId = 0;

  @Unique()
  String id;

  int createdAt;
  int receivedAt;
  int storageMode;
  int shippingMode;
  String authorName;
  String flowName;
  int bounces;
  String title;

  String text;

  ContentTextEntity({
    required this.id,
    required this.createdAt,
    required this.receivedAt,
    required this.storageMode,
    required this.shippingMode,
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
      receivedAt: contentText.receivedAt,
      storageMode: contentText.storageMode.value,
      shippingMode: contentText.shippingMode.value,
      authorName: contentText.authorName,
      flowName: contentText.flowName,
      bounces: contentText.bounces,
      title: contentText.title,

      text: contentText.text,
    );
  }

  ContentText toModel() {
    return ContentText(
      id: id,
      createdAt: createdAt,
      receivedAt: receivedAt,
      storageMode: StorageMode.fromValue(storageMode),
      shippingMode: ShippingMode.fromValue(shippingMode),
      authorName: authorName,
      flowName: flowName,
      bounces: bounces,
      title: title,

      text: text,
    );
  }
}
