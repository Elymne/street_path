import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';

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

  static WrapEntity fromModel(Wrap wrap) {
    return WrapEntity(
      id: wrap.id,
      contentId: wrap.content.id,
      createdAt: wrap.createdAt,
      shippingMode: wrap.shippingMode.value,
      storageMode: wrap.storageMode.value,
    );
  }
}
