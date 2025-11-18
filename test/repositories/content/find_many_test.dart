import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/content_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'data/entities.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final PathGateway pathGateway;
  late final ObjectBoxGateway objectboxGateway;
  late final ContentRepository contentRepository;

  // * Accès direct aux tables pour les tests.
  late final Box<ContentTextEntity> boxContentText;
  late final Box<ContentLinkEntity> boxContentLink;
  late final Box<ContentMediaEntity> boxContentMedia;

  setUpAll(() async {
    pathGateway = _MockPathGateway();
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();

    contentRepository = ContentRepositoryImpl(objectboxGateway);
    boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();

    boxContentText.putMany(contentTextEntities);
    boxContentLink.putMany(contentLinkEntities);
    boxContentMedia.putMany(contentMediaEntities);
  });

  tearDownAll(() async {
    boxContentText.removeAll();
    boxContentLink.removeAll();
    boxContentMedia.removeAll();
    await objectboxGateway.disconnect();
  });

  test('ContentRepository.findMany(): Full data', () async {
    final contents = await contentRepository.findMany(0, 0);
    expect(contents.length, 13);
  });

  test('ContentRepository.findMany(): 2 elements of each data type', () async {
    final contents = await contentRepository.findMany(0, 2);
    expect(contents.length, 6);
  });

  test('ContentRepository.findMany(): 2 elements of each data type page 2', () async {
    final contents = await contentRepository.findMany(1, 2);
    expect(contents.length, 6);
  });

  test('ContentRepository.findMany(): 2 elements of each data type page 3', () async {
    final contents = await contentRepository.findMany(2, 2);
    expect(contents.length, 1);
  });

  test('ContentRepository.findMany(): Flow = resources', () async {
    final contents = await contentRepository.findMany(0, 0, flows: ['resources']);
    expect(contents.length, 1);
  });

  test('ContentRepository.findMany(): Flow = updates, resources', () async {
    final contents = await contentRepository.findMany(0, 0, flows: ['updates', 'resources']);
    expect(contents.length, 2);
  });

  test('ContentRepository.findMany(): Flow = updates, resources', () async {
    final contents = await contentRepository.findMany(0, 0, shippingModes: [ShippingMode.creator]);
    expect(contents.length, 1);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
