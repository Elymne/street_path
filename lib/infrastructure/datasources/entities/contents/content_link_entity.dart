import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_link.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ContentLinkEntity {
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

  String ref;
  String description;

  ContentLinkEntity({
    required this.id,
    required this.createdAt,
    required this.receivedAt,
    required this.storageMode,
    required this.shippingMode,
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
      receivedAt: contentLink.receivedAt,
      storageMode: contentLink.storageMode.value,
      shippingMode: contentLink.shippingMode.value,
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
      receivedAt: receivedAt,
      storageMode: StorageMode.fromValue(storageMode),
      shippingMode: ShippingMode.fromValue(shippingMode),
      authorName: authorName,
      flowName: flowName,
      bounces: bounces,
      title: title,

      ref: ref,
      description: description,
    );
  }
}
