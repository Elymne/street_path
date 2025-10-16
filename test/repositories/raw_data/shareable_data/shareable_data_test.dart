import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/wrap_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final pathGateway = _MockPathGateway();
  late final ObjectBoxGateway objectboxGateway;
  late final RawDataRepositoryImpl rawDataRepositoryImpl;

  // * Accès direct aux tables pour les tests.
  late final Box<RawDataEntity> boxRawData;
  late final Box<WrapEntity> boxWrap;
  late final Box<ContentTextEntity> boxContentText;
  late final Box<CommentEntity> boxComment;
  late final Box<ReactionEntity> boxReaction;

  // * Contenu de tests.
  List<RawDataEntity> currentCache = [];
  List<ContentTextEntity> currentTextContents = [];
  List<CommentEntity> currentComments = [];
  List<ReactionEntity> currentReactions = [];

  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();
    rawDataRepositoryImpl = RawDataRepositoryImpl(objectboxGateway);

    boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
    boxWrap = objectboxGateway.getConnector()!.box<WrapEntity>();
    boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
    boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  });

  setUp(() {
    boxRawData.removeAll();
    boxWrap.removeAll();
    boxContentText.removeAll();
    boxComment.removeAll();
    boxReaction.removeAll();

    currentCache = boxRawData.getAll();
    currentTextContents = boxContentText.getAll();
    currentComments = boxComment.getAll();
    currentReactions = boxReaction.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty on start");
    expect(currentTextContents.isEmpty, true, reason: "Empty on start");
    expect(currentComments.isEmpty, true, reason: "Empty on start");
    expect(currentReactions.isEmpty, true, reason: "Empty on start");
  });

  tearDownAll(() async {
    boxRawData.removeAll();
    boxWrap.removeAll();
    boxContentText.removeAll();
    boxComment.removeAll();
    boxReaction.removeAll();
    await objectboxGateway.disconnect();
  });

  test("Shareable: pas d'contenus, pas d'échanges.", () async {
    final json = await rawDataRepositoryImpl.findShareableData(10, 7);
    final data = jsonDecode(json);
    expect(data.length, 0);
  });

  test("Shareable: juste un contenu quelconque.", () async {
    final id = Uuid().v4();
    boxContentText.put(
      ContentTextEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "Author",
        flowName: "flowName",
        bounces: 0,
        title: "title",
        text: "text",
      ),
    );
    boxWrap.put(
      WrapEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        contentId: id,
        storageMode: StorageMode.normal.value,
        shippingMode: ShippingMode.normal.value,
      ),
    );

    final json = await rawDataRepositoryImpl.findShareableData(10, 7);
    final data = jsonDecode(json);
    expect(data.length, 1);
  });

  test("Shareable: juste un contenu quelconque + des coms et des reacts.", () async {
    final id = Uuid().v4();
    boxContentText.put(
      ContentTextEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "Author",
        flowName: "flowName",
        bounces: 0,
        title: "title",
        text: "text",
      ),
    );
    boxWrap.put(
      WrapEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        contentId: id,
        storageMode: StorageMode.normal.value,
        shippingMode: ShippingMode.normal.value,
      ),
    );
    boxReaction.put(
      ReactionEntity(
        id: Uuid().v4(),
        contentId: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "authorName long?",
        flag: 1,
      ),
    );
    boxComment.put(
      CommentEntity(
        id: Uuid().v4(),
        contentId: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "authorName long?",
        text: "text",
      ),
    );

    final json = await rawDataRepositoryImpl.findShareableData(10, 7);
    final data = jsonDecode(json);
    expect(data.length, 3);
  });

  test("Shareable: grosse limite sur le nombre de trucs partageable, on doit sélectionner pour de vrai.", () async {
    final id1 = Uuid().v4();
    final id2 = Uuid().v4();
    final id3 = Uuid().v4();
    boxContentText.putMany([
      ContentTextEntity(
        id: id1,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "Author",
        flowName: "flowName",
        bounces: 0,
        title: "title",
        text: "text",
      ),
      ContentTextEntity(
        id: id2,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "Author",
        flowName: "flowName",
        bounces: 0,
        title: "title",
        text: "text",
      ),
      ContentTextEntity(
        id: id3,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "Author",
        flowName: "flowName",
        bounces: 0,
        title: "title",
        text: "text",
      ),
    ]);

    boxWrap.putMany([
      WrapEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        contentId: id1,
        storageMode: StorageMode.normal.value,
        shippingMode: ShippingMode.creator.value,
      ),
      WrapEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        contentId: id2,
        storageMode: StorageMode.normal.value,
        shippingMode: ShippingMode.important.value,
      ),
      WrapEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        contentId: id3,
        storageMode: StorageMode.normal.value,
        shippingMode: ShippingMode.normal.value,
      ),
    ]);

    final json = await rawDataRepositoryImpl.findShareableData(2, 7);
    final data = jsonDecode(json);
    expect(data.length, 2);
    expect(data[0]["id"], id1);
    expect(data[1]["id"], id2);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
