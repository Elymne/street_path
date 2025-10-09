import 'package:poc_street_path/core/model.dart';

class RawData extends Model {
  final String data;
  RawData({required super.id, required super.createdAt, required this.data});
}
