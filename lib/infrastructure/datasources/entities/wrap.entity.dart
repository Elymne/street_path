import 'package:objectbox/objectbox.dart';

@Entity()
class WrapEntity {
  @Id()
  int obId = 0;

  @Unique()
  String id;

  @Unique()
  String contentId;

  int createdAt;
  int storageMode;
  int shippingMode;

  WrapEntity({required this.id, required this.createdAt, required this.contentId, required this.storageMode, required this.shippingMode});
}
