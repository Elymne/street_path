import 'dart:convert';

import 'package:poc_street_path/domain/models/cache/raw_data.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/models/content/reaction.model.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final PathGateway pathGateway;
  late final ObjectBoxGateway objectboxGateway;
  late final RawDataRepository rawDataRepository;
  late final Box<RawDataEntity> boxRawData;

  setUpAll(() async {
    pathGateway = _MockPathGateway();
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();

    rawDataRepository = RawDataRepositoryImpl(objectboxGateway);
    boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
  });

  setUp(() {
    boxRawData.removeAll();
    expect(boxRawData.getAll().isEmpty, true, reason: 'Empty on start');
  });

  tearDownAll(() async {
    boxRawData.removeAll();
    await objectboxGateway.disconnect();
  });

  test('RawDataRepository.insert()', () async {
    final id = Uuid().v4();
    final data = jsonEncode('Text tout nul');
    await rawDataRepository.insert(RawData(id: id, createdAt: DateTime.now().millisecondsSinceEpoch, data: data));

    final reactionEntity = boxRawData.query(RawDataEntity_.id.equals(id)).build().findFirst();
    expect(reactionEntity, isNotNull);
    expect(reactionEntity!.data, data);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
