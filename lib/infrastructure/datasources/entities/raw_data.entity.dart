import 'package:objectbox/objectbox.dart';

@Entity()
class RawData {
  @Id()
  int obId = 0;

  int? createdAt;
  String? data;
}
