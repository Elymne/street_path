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

  test("Sync: La donnée dans le json dans le cache est une liste contenant une valeur comment.", () async {
    final id = Uuid().v4();
    boxRawData.put(
      RawDataEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "authorName": "Alice Dupont",
            "bounces": 2,
            "flowName": "MarketingFlow",
            "title": "Nouvelle campagne automnale",
            "text": "Lancement de la campagne automne 2025 avec focus sur les réseaux sociaux.",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "contentId": id,
            "authorName": "Alice Dupont",
            "text": "Un commentaire oui",
          },
          {
            "id": Uuid().v4(),
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
    expect(result, 3, reason: "Sync +3");

    currentCache = boxRawData.getAll();
    currentComments = boxComment.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentComments.length, 1, reason: "comment = 1");
  });

  test("Sync: La donnée json est un commentaire affilié à aucun contenu.", () async {
    boxRawData.put(
      RawDataEntity(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        data: jsonEncode([
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "contentId": Uuid().v4(),
            "authorName": "Alice Dupont",
            "text": "Un commentaire oui",
          },
          {
            "id": Uuid().v4(),
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
    expect(result, 1, reason: "Sync +1");

    currentCache = boxRawData.getAll();
    currentComments = boxComment.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty cache");
    expect(currentComments.length, 0, reason: "comment = 0");
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
