import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_link.model.dart';
import 'package:poc_street_path/domain/models/content/content_media.model.dart';
import 'package:poc_street_path/domain/models/content/content_text.model.dart';
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
import 'package:uuid/uuid.dart';
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
  });

  tearDownAll(() async {
    boxContentText.removeAll();
    boxContentLink.removeAll();
    boxContentMedia.removeAll();
    await objectboxGateway.disconnect();
  });

  setUp(() {
    boxContentText.removeAll();
    boxContentLink.removeAll();
    boxContentMedia.removeAll();

    expect(boxContentText.getAll().isEmpty, true, reason: 'Empty on start');
    expect(boxContentLink.getAll().isEmpty, true, reason: 'Empty on start');
    expect(boxContentMedia.getAll().isEmpty, true, reason: 'Empty on start');
  });

  test('ContentRepository.insert() Erreur Type Content inconnu', () async {
    expect(() async {
      await contentRepository.insert(
        _FakeContent(
          id: Uuid().v4(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          authorName: 'Test Author',
          bounces: 0,
          flowName: 'onboarding_flow',
          title: 'Test content title',
          shippingMode: ShippingMode.normal,
          storageMode: StorageMode.normal,
        ),
      );
    }, throwsException);
  });

  test('ContentRepository.insert() Erreur Duplication ID', () async {
    final id = Uuid().v4();
    await contentRepository.insert(
      ContentText(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        authorName: 'Test Author',
        bounces: 0,
        flowName: 'onboarding_flow',
        title: 'Test content title',
        storageMode: StorageMode.normal,
        shippingMode: ShippingMode.normal,
        text: 'This is a sample ContentText body used for unit testing purposes.',
      ),
    );

    expect(() async {
      await contentRepository.insert(
        ContentText(
          id: id,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          authorName: 'Test Author',
          bounces: 0,
          flowName: 'onboarding_flow',
          title: 'Test content title',
          storageMode: StorageMode.normal,
          shippingMode: ShippingMode.normal,
          text: 'This is a sample ContentText body used for unit testing purposes.',
        ),
      );
    }, throwsException);
  });

  test('ContentRepository.insert() ContentText', () async {
    final id = Uuid().v4();
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    final receivedAt = DateTime.now().millisecondsSinceEpoch;
    final authorName = 'Test Author';
    final bounces = 0;
    final flowName = 'onboarding_flow';
    final title = 'Test content title';
    final storageMode = StorageMode.normal;
    final shippingMode = ShippingMode.normal;
    final text = 'This is a sample ContentText body used for unit testing purposes.';
    await contentRepository.insert(
      ContentText(
        id: id,
        createdAt: createdAt,
        receivedAt: receivedAt,
        authorName: authorName,
        bounces: bounces,
        flowName: flowName,
        title: title,
        storageMode: storageMode,
        shippingMode: shippingMode,
        text: text,
      ),
    );

    final contentEntity = boxContentText.query(ContentTextEntity_.id.equals(id)).build().findFirst();
    expect(contentEntity, isNotNull);
    expect(contentEntity!.bounces, 0);
    expect(contentEntity.title, title);
    expect(contentEntity.text, text);
    expect(contentEntity.authorName, authorName);
    expect(contentEntity.flowName, flowName);
  });

  test('ContentRepository.insert() ContentLink', () async {
    final id = Uuid().v4();
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    final receivedAt = DateTime.now().millisecondsSinceEpoch;
    final authorName = 'Link Author';
    final bounces = 1;
    final flowName = 'promo_flow';
    final title = 'Visit example';
    final storageMode = StorageMode.normal;
    final shippingMode = ShippingMode.normal;
    final ref = 'https://example.com';
    final description = 'description';
    await contentRepository.insert(
      ContentLink(
        id: id,
        createdAt: createdAt,
        receivedAt: receivedAt,
        authorName: authorName,
        bounces: bounces,
        flowName: flowName,
        title: title,
        storageMode: storageMode,
        shippingMode: shippingMode,
        ref: ref,
        description: description,
      ),
    );

    final contentEntity = boxContentLink.query(ContentLinkEntity_.id.equals(id)).build().findFirst();
    expect(contentEntity, isNotNull);
    expect(contentEntity!.bounces, bounces);
    expect(contentEntity.title, title);
    expect(contentEntity.authorName, authorName);
    expect(contentEntity.flowName, flowName);
    expect(contentEntity.ref, ref);
    expect(contentEntity.description, description);
  });

  test('ContentRepository.insert() ContentMedia', () async {
    final id = Uuid().v4();
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    final receivedAt = DateTime.now().millisecondsSinceEpoch;
    final authorName = 'Link Author';
    final bounces = 1;
    final flowName = 'promo_flow';
    final title = 'Visit example';
    final storageMode = StorageMode.normal;
    final shippingMode = ShippingMode.normal;
    final path = 'path/to/dir';
    final description = 'description';

    await contentRepository.insert(
      ContentMedia(
        id: id,
        createdAt: createdAt,
        receivedAt: receivedAt,
        authorName: authorName,
        bounces: bounces,
        flowName: flowName,
        title: title,
        storageMode: storageMode,
        shippingMode: shippingMode,
        path: path,
        description: description,
      ),
    );

    final contentEntity = boxContentMedia.query(ContentMediaEntity_.id.equals(id)).build().findFirst();
    expect(contentEntity, isNotNull);
    expect(contentEntity!.bounces, bounces);
    expect(contentEntity.title, title);
    expect(contentEntity.authorName, authorName);
    expect(contentEntity.flowName, flowName);
    expect(contentEntity.path, path);
    expect(contentEntity.description, description);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}

class _FakeContent extends Content {
  _FakeContent({
    required super.id,
    required super.createdAt,
    required super.receivedAt,
    required super.authorName,
    required super.bounces,
    required super.flowName,
    required super.title,
    required super.shippingMode,
    required super.storageMode,
  });

  @override
  Map<String, Object> toRaw() {
    // TODO: implement toRaw
    throw UnimplementedError();
  }
}
