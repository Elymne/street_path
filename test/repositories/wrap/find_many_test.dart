import 'package:poc_street_path/domain/models/contents/content_text.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/wrap_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/wrap_repository_impl.dart';
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
  late final WrapRepository wrapRepository;
  late final RawDataRepository rawDataRepository;
  late final Box<WrapEntity> boxWrap;
  late final Box<RawDataEntity> boxRawData;

  setUpAll(() async {
    pathGateway = _MockPathGateway();
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();

    wrapRepository = WrapRepositoryImpl(objectboxGateway);
    rawDataRepository = RawDataRepositoryImpl(objectboxGateway);
    boxWrap = objectboxGateway.getConnector()!.box<WrapEntity>();
    boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
  });

  setUp(() {
    boxWrap.removeAll();
    boxRawData.removeAll();
    expect(boxWrap.getAll().isEmpty, true, reason: 'Empty on start');
    expect(boxRawData.getAll().isEmpty, true, reason: 'Empty on start');
  });

  tearDownAll(() async {
    boxWrap.removeAll();
    boxRawData.removeAll();
    await objectboxGateway.disconnect();
  });

  test('Wrap Repository: Plusieurs contenus sur une sync. On veut récupérer quelques wraps en fonction de quelques paramètres.', () async {
    final content1 = {
      'id': Uuid().v4(),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'authorName': 'Alice Dupont',
      'flowName': 'Marketing',
      'bounces': 12,
      'title': 'Nouvelle campagne automnale',
      'text': 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.',
    };

    final content2 = {
      'id': Uuid().v4(),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'authorName': 'Marc Dupont',
      'flowName': 'Marketing',
      'bounces': 21,
      'title': 'Nouvelle campagne étrange',
      'text': 'Lancement de la campagne étrange 2025 avec focus sur les réseaux des égouts.',
    };

    final content3 = {
      'id': Uuid().v4(),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'authorName': 'Jean Dupont',
      'flowName': 'Voleur',
      'bounces': 1,
      'title': 'Nouvelle campagne de vol',
      'path': 'dir/to/image',
      'description': "Lancement de la campagne de vol 2025 avec focus sur les réseaux c'est tout.",
    };

    final content4 = {
      'id': Uuid().v4(),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'authorName': 'Jean Dupont',
      'flowName': 'Voleur',
      'bounces': 3,
      'title': 'Nouvelle campagne de vol v2',
      'ref': 'h_ttps://mdr.com',
      'description': 'Lancement de la campagne de vol v2 2025 avec focus sur les réseaux.',
    };

    rawDataRepository.add(jsonEncode([content1, content2, content3, content4]));
    rawDataRepository.syncData();

    final wraps = await wrapRepository.findMany(1, 10);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
