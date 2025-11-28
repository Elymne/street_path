import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/domain/models/cache/raw_data.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

final rawDataRepositoryProvider = Provider<RawDataRepository>((ref) {
  final objectBox = ref.read(objectBoxGatewayProvider);
  return RawDataRepositoryImpl(objectBox);
});

class RawDataRepositoryImpl implements RawDataRepository {
  late final Box<RawDataEntity> _boxRawData;

  RawDataRepositoryImpl(DatabaseGateway objectboxGateway) {
    _boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
  }

  @override
  Future<void> insert(RawData rawData) async {
    _boxRawData.put(RawDataEntity.fromModel(rawData), mode: PutMode.insert);
  }

  @override
  Future<List<RawData>> findAll() async {
    return _boxRawData.getAll().map((elem) => elem.toModel()).toList();
  }

  @override
  Future<void> clear() async {
    _boxRawData.removeAll();
  }
}
