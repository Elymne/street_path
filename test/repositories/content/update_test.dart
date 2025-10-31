import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_media.model.dart';
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

  test('ContentRepository.update() ContentMedia', () async {
    final content = ContentMedia(
      id: Uuid().v4(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      receivedAt: DateTime.now().millisecondsSinceEpoch,
      authorName: 'Link Author',
      bounces: 0,
      flowName: 'promo_flow',
      title: 'Visit example',
      storageMode: StorageMode.normal,
      shippingMode: ShippingMode.normal,
      path: 'path/to/dir',
      description: 'description',
    );
    await contentRepository.insert(content);

    final contentEntity = boxContentMedia.query(ContentMediaEntity_.id.equals(content.id)).build().findFirst();
    expect(contentEntity, isNotNull);
    expect(contentEntity!.flowName, content.flowName);

    final updatedContent = content.clone(flowName: 'new_promo_flow');
    await contentRepository.update(updatedContent);
    final updatedContentEntity = boxContentMedia.query(ContentMediaEntity_.id.equals(content.id)).build().findFirst();
    expect(updatedContentEntity, isNotNull);
    expect(updatedContentEntity!.flowName, updatedContent.flowName);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
