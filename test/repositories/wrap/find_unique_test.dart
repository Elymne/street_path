import 'package:poc_street_path/domain/models/contents/content_link.model.dart';
import 'package:poc_street_path/domain/models/contents/content_media.model.dart';
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

  test(
    "Wrap Repository: Un wrap est ajouté à partir d'une sync. On doit retrouver ce wrap avec le repository. Exemple avec un ContentText.",
    () async {
      final contentId = Uuid().v4();
      final authorName = 'Alice Dupont';
      final flowName = 'Marketing';
      final title = 'Nouvelle campagne automnale';
      final text = 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.';
      final bounce = 11;

      rawDataRepository.add(
        jsonEncode([
          {
            'id': contentId,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'authorName': authorName,
            'bounces': bounce,
            'flowName': flowName,
            'title': title,
            'text': text,
          },
        ]),
      );
      rawDataRepository.syncData();

      final wrap = await wrapRepository.findUnique(contentId);
      expect(wrap, isNotNull);
      expect(wrap!.content is ContentText, true);

      final contentText = (wrap.content as ContentText);
      expect(contentText.authorName, authorName);
      expect(contentText.flowName, flowName);
      expect(contentText.title, title);
      expect(contentText.bounces, bounce + 1);
      expect(contentText.text, text);
    },
  );

  test(
    "Wrap Repository: Un wrap est ajouté à partir d'une sync. On doit retrouver ce wrap avec le repository. Exemple avec un ContentLink.",
    () async {
      final contentId = Uuid().v4();
      final authorName = 'Alice Dupont';
      final flowName = 'Marketing';
      final bounce = 11;
      final title = 'Nouvelle campagne automnale';
      final ref = 'h_ttps://mdr.com';
      final description = 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.';

      rawDataRepository.add(
        jsonEncode([
          {
            'id': contentId,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'authorName': authorName,
            'bounces': bounce,
            'flowName': flowName,
            'title': title,
            'ref': ref,
            'description': description,
          },
        ]),
      );
      rawDataRepository.syncData();

      final wrap = await wrapRepository.findUnique(contentId);
      expect(wrap, isNotNull);
      expect(wrap!.content is ContentLink, true);

      final contentText = (wrap.content as ContentLink);
      expect(contentText.authorName, authorName);
      expect(contentText.bounces, bounce + 1);
      expect(contentText.flowName, flowName);
      expect(contentText.title, title);
      expect(contentText.ref, ref);
      expect(contentText.description, description);
    },
  );

  test(
    "Wrap Repository: Un wrap est ajouté à partir d'une sync. On doit retrouver ce wrap avec le repository. Exemple avec un ContentMedia.",
    () async {
      final contentId = Uuid().v4();
      final authorName = 'Alice Dupont';
      final flowName = 'Marketing';
      final bounce = 11;
      final title = 'Nouvelle campagne automnale';
      final path = 'dir/to/image';
      final description = 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.';

      rawDataRepository.add(
        jsonEncode([
          {
            'id': contentId,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'authorName': authorName,
            'bounces': bounce,
            'flowName': flowName,
            'title': title,
            'path': path,
            'description': description,
          },
        ]),
      );
      rawDataRepository.syncData();

      final wrap = await wrapRepository.findUnique(contentId);
      expect(wrap, isNotNull);
      expect(wrap!.content is ContentMedia, true);

      final contentText = (wrap.content as ContentMedia);
      expect(contentText.authorName, authorName);
      expect(contentText.bounces, bounce + 1);
      expect(contentText.flowName, flowName);
      expect(contentText.title, title);
      expect(contentText.path, path);
      expect(contentText.description, description);
    },
  );
}

class _MockPathGateway extends Mock implements PathGateway {}
