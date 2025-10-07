import 'package:poc_street_path/domain/models/post/post.model.dart';

abstract class RawDataRepository {
  Future<String> add(String data);
  Future<bool> delete(String id);
  Future<int> syncPosts();
}
