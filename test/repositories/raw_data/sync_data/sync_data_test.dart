import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/content_text.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/raw_data.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/reaction.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_impl.repository.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

/// Jeux de tests de véfication du transferts des données entre deux appareils et du fonctionnement du cache (table raw_data).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final pathGateway = _MockPathGateway();
  late final ObjectBoxGateway objectboxGateway;
  late final RawDataRepositoryImpl rawDataRepositoryImpl;

  // * Accès direct aux tables pour les tests.
  late final Box<RawDataEntity> boxRawData;
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
    when(() => pathGateway.getBaseDir()).thenAnswer((maleficumInvocationDelaMuerteJeSaisPasAQuoiSertCeTruc) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();
    rawDataRepositoryImpl = RawDataRepositoryImpl(objectboxGateway);

    boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
    boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
    boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  });

  setUp(() {
    boxRawData.removeAll();
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
    boxContentText.removeAll();
    boxComment.removeAll();
    boxReaction.removeAll();
    await objectboxGateway.disconnect();
  });

  test("Sync: Le cache est vide.", () async {
    List<RawDataEntity> currentCache = [];
    List<ContentTextEntity> currentTextContent = [];

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 0, reason: "Sync +0");

    currentCache = boxRawData.getAll();
    currentTextContent = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentTextContent.isEmpty, true, reason: "content_text = 0");
  });

  test("Sync: La donnée dans le json dans le cache est une liste contenant une valeur content_text.", () async {
    boxRawData.put(
      RawDataEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
        ]),
      ),
    );

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 1, reason: "Sync +1");

    currentCache = boxRawData.getAll();
    currentTextContents = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentTextContents.length, 1, reason: "content_text = 1");
  });

  test("Sync: La donnée dans le json dans le cache est une liste contenant plusieurs valeurs content_text.", () async {
    boxRawData.put(
      RawDataEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
        ]),
      ),
    );

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 5, reason: "Sync +5");

    currentCache = boxRawData.getAll();
    currentTextContents = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentTextContents.length, 5, reason: "content_text = 5");
  });

  test("Sync: La donnée json dans le cache n'est pas une liste.", () async {
    boxRawData.put(
      RawDataEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode({
          "id": Uuid().v4(),
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "authorName": "Alice Dupont",
          "bounces": 12,
          "flowName": "MarketingFlow",
          "title": "Nouvelle campagne automnale",
          "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
        }),
      ),
    );

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 0, reason: "Sync +0");

    currentCache = boxRawData.getAll();
    currentTextContents = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentTextContents.isEmpty, true, reason: "content_text = 0");
  });

  test("Sync: Une data dans le cache de type content_text mais mal formé.", () async {
    boxRawData.put(
      RawDataEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorNameOups": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
        ]),
      ),
    );

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 1, reason: "Sync +1");

    currentCache = boxRawData.getAll();
    currentTextContents = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentTextContents.length, 1, reason: "content_text = 1");
  });

  test("Sync: Une data dans le cache de type content_text. Data content_text déjà existant.", () async {
    boxContentText.put(
      ContentTextEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "Bidule",
        bounces: 2,
        flowName: "Flow",
        title: "title",
        text: "Test",
      ),
    );

    boxRawData.put(
      RawDataEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 12,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
        ]),
      ),
    );

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 1, reason: "Sync +1");

    currentCache = boxRawData.getAll();
    currentTextContents = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentTextContents.length, 2, reason: "content_text = 2");
  });

  test("Sync: Le nombre de rebons augmente après une sync.", () async {
    final id = Uuid().v4();
    final initialBounce = 24;

    boxRawData.put(
      RawDataEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": id,
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": initialBounce,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
        ]),
      ),
    );

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 1, reason: "Sync +1");

    final contentText = boxContentText.query(ContentTextEntity_.id.equals(id)).build().findFirst();
    expect(contentText!.bounces, initialBounce + 1, reason: "content_text.bounce = 25");
  });

  test("Sync: 2 content_text avec la même ID.", () async {
    final id = Uuid().v4();

    boxContentText.put(
      ContentTextEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: "Alice Dupont",
        bounces: 2,
        flowName: "MarketingFlow",
        title: "Nouvelle campagne automnale",
        text: "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
      ),
    );

    boxRawData.put(
      RawDataEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": id,
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 2,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
        ]),
      ),
    );

    final result = await rawDataRepositoryImpl.syncData();
    expect(result, 0, reason: "Sync +0");

    currentCache = boxRawData.getAll();
    currentTextContents = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentTextContents.length, 1, reason: "content_text = 1");
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
