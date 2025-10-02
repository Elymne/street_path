import 'package:poc_street_path/core/model.dart';
import 'package:poc_street_path/domain/models/post/post.model.dart';

class PostWrap extends Model {
  final Post post;
  final int storageMode;
  final int shippingMode;

  PostWrap({required super.id, required super.createdAt, required this.post, required this.storageMode, required this.shippingMode});
}
