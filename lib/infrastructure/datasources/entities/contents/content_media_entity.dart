import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_media.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ContentMediaEntity {
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

  String path;
  String description;

  ContentMediaEntity({
    required this.id,
    required this.createdAt,
    required this.receivedAt,
    required this.storageMode,
    required this.shippingMode,
    required this.authorName,
    required this.flowName,
    required this.bounces,
    required this.title,

    required this.path,
    required this.description,
  });

  static ContentMediaEntity fromModel(ContentMedia contentMedia) {
    return ContentMediaEntity(
      id: contentMedia.id,
      createdAt: contentMedia.createdAt,
      receivedAt: contentMedia.receivedAt,
      storageMode: contentMedia.storageMode.value,
      shippingMode: contentMedia.shippingMode.value,
      authorName: contentMedia.authorName,
      flowName: contentMedia.flowName,
      bounces: contentMedia.bounces,
      title: contentMedia.title,

      path: contentMedia.path,
      description: contentMedia.description,
    );
  }

  ContentMedia toModel() {
    return ContentMedia(
      id: id,
      createdAt: createdAt,
      receivedAt: receivedAt,
      storageMode: StorageMode.fromValue(storageMode),
      shippingMode: ShippingMode.fromValue(shippingMode),
      authorName: authorName,
      flowName: flowName,
      bounces: bounces,
      title: title,

      path: path,
      description: description,
    );
  }
}
