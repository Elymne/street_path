import 'package:poc_street_path/domain/models/post/post.model.dart';
import 'package:poc_street_path/domain/models/post/raw_post_data.model.dart';

abstract class RawDataRepository {
  Future<List<RawData>> find();
  Future<RawData> add(String data);
  Future<void> delete(String id);

  Future<Post?> transformToPost(RawData rawData);
}
