import 'package:poc_street_path/core/data_model.dart';

class DomainFilter extends DataModel {
  final String url;
  DomainFilter({required super.id, required super.createdAt, required this.url});
}
