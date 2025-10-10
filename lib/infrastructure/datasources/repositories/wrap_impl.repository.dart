import 'package:poc_street_path/domain/repositories/wrap.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/content.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class WrapRepositoryImpl implements WrapRepository {
  late final Box<ContentTextEntity> _boxContent;

  WrapRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxContent = objectboxGateway.getConnector()!.box<ContentTextEntity>();
  }
}
