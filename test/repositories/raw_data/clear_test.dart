import 'package:poc_street_path/domain/models/cache/raw_data.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

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

  test('RawDataRepository.clear()', () async {
    final data = jsonEncode('Text tout nul');
    final data2 = jsonEncode('Un autre texte');
    final data3 = jsonEncode('Un autre texte');

    await rawDataRepository.insert(
      RawData(id: Uuid().v4(), createdAt: DateTime.now().millisecondsSinceEpoch, data: data),
    );
    await rawDataRepository.insert(
      RawData(id: Uuid().v4(), createdAt: DateTime.now().millisecondsSinceEpoch, data: data2),
    );
    await rawDataRepository.insert(
      RawData(id: Uuid().v4(), createdAt: DateTime.now().millisecondsSinceEpoch, data: data3),
    );

    final result = await rawDataRepository.findAll();
    expect(result, isNotEmpty);
    expect(result.length, 3);

    await rawDataRepository.clear();
    final emptyness = await rawDataRepository.findAll();
    expect(emptyness, isEmpty);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
