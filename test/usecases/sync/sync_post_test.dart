import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';
import 'package:poc_street_path/domain/usecases/sync/add_raw_data.usecase.dart';
import 'package:poc_street_path/domain/usecases/sync/sync_posts.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/comment_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/content_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/reaction_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

class _MockPathGateway extends Mock implements PathGateway {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final PathGateway pathGateway;
  late final ObjectBoxGateway objectboxGateway;

  late final RawDataRepository rawDataRepository;
  late final ContentRepository contentRepository;
  late final CommentRepository commentRepository;
  late final ReactionRepository reactionRepository;

  late final AddRawData addRawData;
  late final SyncPost syncPost;

  // * Accès direct aux tables pour les tests.
  late final Box<RawDataEntity> boxRawData;
  late final Box<ContentTextEntity> boxContentText;
  late final Box<ContentLinkEntity> boxContentLink;
  late final Box<ContentMediaEntity> boxContentMedia;
  late final Box<CommentEntity> boxComment;
  late final Box<ReactionEntity> boxReaction;

  setUpAll(() async {
    pathGateway = _MockPathGateway();
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();

    rawDataRepository = RawDataRepositoryImpl(objectboxGateway);
    contentRepository = ContentRepositoryImpl(objectboxGateway);
    commentRepository = CommentRepositoryImpl(objectboxGateway);
    reactionRepository = ReactionRepositoryImpl(objectboxGateway);

    addRawData = AddRawData(rawDataRepository);
    syncPost = SyncPost(rawDataRepository, contentRepository, commentRepository, reactionRepository);

    boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
    boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();
    boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
    boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
  });

  tearDownAll(() async {
    boxContentText.removeAll();
    boxContentLink.removeAll();
    boxContentMedia.removeAll();
    boxComment.removeAll();
    boxReaction.removeAll();
    await objectboxGateway.disconnect();
  });

  setUp(() {
    boxContentText.removeAll();
    boxContentLink.removeAll();
    boxContentMedia.removeAll();
    boxComment.removeAll();
    boxReaction.removeAll();

    expect(boxContentText.getAll().isEmpty, true, reason: 'Empty on start');
    expect(boxContentLink.getAll().isEmpty, true, reason: 'Empty on start');
    expect(boxContentMedia.getAll().isEmpty, true, reason: 'Empty on start');
    expect(boxComment.getAll().isEmpty, true, reason: 'Empty on start');
    expect(boxReaction.getAll().isEmpty, true, reason: 'Empty on start');
  });

  test('SyncPost.execute() Sync many and duplicated values.', () async {
    final idContent = Uuid().v4();
    final idMessage = Uuid().v4();
    final idReaction = Uuid().v4();
    await addRawData.execute(
      AddRawDataParams(
        jsonEncode([
          {
            'id': idContent,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'authorName': 'Alice Dupont',
            'bounces': 2,
            'flowName': 'MarketingFlow',
            'title': 'Nouvelle campagne automnale',
            'text': 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.',
          },
          {
            'id': idContent,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'authorName': 'Alice Dupont',
            'bounces': 2,
            'flowName': 'MarketingFlow',
            'title': 'Nouvelle campagne automnale (Doublon)',
            'text': 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.',
          },

          {
            'id': idMessage,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'contentId': idContent,
            'authorName': 'Alice Dupont Machin bidule',
            'text': 'Petit commentaire',
          },
          {
            'id': idMessage,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'contentId': idContent,
            'authorName': 'Alice Dupont Machin bidule',
            'text': 'Petit commentaire (doublon)',
          },

          {
            'id': idReaction,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'contentId': idContent,
            'authorName': 'Alice Dupont Machin bidule',
            'flag': 1000,
          },
          {
            'id': idReaction,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'contentId': idContent,
            'authorName': 'Alice Dupont Machin bidule',
            'flag': 1000,
          },

          {
            'id': Uuid().v4(),
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'authorName': 'Alice Dupont',
            'bounces': 2,
            'flowName': 'MarketingFlow',
            'title': 'Nouvelle campagne automnale',
            'ref': 'http://lolilol',
            'description': 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.',
          },

          {
            'id': Uuid().v4(),
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'authorName': 'Alice Dupont',
            'bounces': 2,
            'flowName': 'MarketingFlow',
            'title': 'Nouvelle campagne automnale',
            'path': 'path/to/dir',
            'description': 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.',
          },
        ]),
      ),
    );

    await syncPost.execute(SyncPostParams());

    final contentText = boxContentText.getAll();
    final contentLink = boxContentLink.getAll();
    final contentMedia = boxContentMedia.getAll();
    final contentComment = boxComment.getAll();
    final contentReaction = boxReaction.getAll();
    final rawData = boxRawData.getAll();

    expect(contentText.length, 1, reason: 'contentText');
    expect(contentLink.length, 1, reason: 'contentLink');
    expect(contentMedia.length, 1, reason: 'contentMedia');
    expect(contentComment.length, 1, reason: 'contentComment');
    expect(contentReaction.length, 1, reason: 'contentReaction');
    expect(rawData.length, 0, reason: 'rawData vidé');
  });

  test('SyncPost.execute() Sync many and duplicated values.', () async {
    final contentText = {
      'id': Uuid().v4(),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'authorName': 'Alice Dupont',
      'bounces': 5,
      'flowName': 'MarketingFlow',
      'title': 'Nouvelle campagne automnale',
      'text': 'Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.',
    };

    await addRawData.execute(AddRawDataParams(jsonEncode([contentText])));

    await syncPost.execute(SyncPostParams());

    expect(boxContentText.getAll()[0].bounces, 6);
  });
}
