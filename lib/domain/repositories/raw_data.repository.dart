import 'package:poc_street_path/domain/models/post/raw_post_data.model.dart';

abstract class RawDataRepository {
  Future<List<RawData>> find();
  Future<RawData> add(String data);
}
