import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/cache/raw_data.model.dart';

@Entity()
class RawDataEntity {
  @Id()
  int obId = 0;

  String id;
  int createdAt;
  String data;

  RawDataEntity({required this.id, required this.createdAt, required this.data});

  static RawDataEntity fromModel(RawData rawData) {
    return RawDataEntity(id: rawData.id, createdAt: rawData.createdAt, data: rawData.data);
  }

  RawData toModel() {
    return RawData(id: id, createdAt: createdAt, data: data);
  }
}
