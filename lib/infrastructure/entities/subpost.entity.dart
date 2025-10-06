import 'package:objectbox/objectbox.dart';

@Entity()
class SubpostEntity {
  @Id()
  int obId = 0;

  @Unique()
  String? id;

  int? createdAt;

  String? userId;

  String? comment;
}
