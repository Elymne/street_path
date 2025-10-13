import 'package:objectbox/objectbox.dart';

@Entity()
class RawDataEntity {
  @Id()
  int obId = 0;

  String id;
  int createdAt;
  String data;

  RawDataEntity({required this.id, required this.createdAt, required this.data});
}
