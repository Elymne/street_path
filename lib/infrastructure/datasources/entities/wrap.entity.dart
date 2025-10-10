import 'package:objectbox/objectbox.dart';

@Entity()
class WrapEntity {
  @Id()
  int obId = 0;

  @Unique()
  String id;

  int createdAt;
  String contentId;

  int storageMode;
  int shippingMode;

  WrapEntity({required this.id, required this.createdAt, required this.contentId, required this.storageMode, required this.shippingMode});
}
