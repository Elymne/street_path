import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/wrap_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';

/// Jeux de tests de véfication du transferts des données entre deux appareils et du fonctionnement du cache (table raw_data).
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
  List<WrapEntity> currentWraps = [];
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
    currentWraps = boxWrap.getAll();
    currentTextContents = boxContentText.getAll();
    currentComments = boxComment.getAll();
    currentReactions = boxReaction.getAll();
    expect(currentCache.isEmpty, true, reason: "Empty on start");
    expect(currentWraps.isEmpty, true, reason: "Empty on start");
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

  test("Sync: Vérification de la création d'un Wrap avec les bonnes données par défaut pour une contamination.", () async {
    final id = Uuid().v4();
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
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "contentId": id,
            "authorName": "Alice Dupont Machin bidule",
            "text": "Petit commentaire",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "contentId": id,
            "authorName": "Alice Dupont Machin bidule",
            "flag": 1000,
          },
        ]),
      ),
    );

    await rawDataRepositoryImpl.syncData();

    currentTextContents = boxContentText.query(ContentTextEntity_.id.equals(id)).build().find();
    currentWraps = boxWrap.query(WrapEntity_.contentId.equals(id)).build().find();
    currentComments = boxComment.query(CommentEntity_.contentId.equals(id)).build().find();
    currentReactions = boxReaction.query(ReactionEntity_.contentId.equals(id)).build().find();

    expect(currentTextContents.length, 1);
    expect(currentWraps.length, 1);
    expect(currentComments.length, 1);
    expect(currentReactions.length, 1);
    expect(currentWraps[0].shippingMode, ShippingMode.normal.value);
    expect(currentWraps[0].storageMode, StorageMode.normal.value);
  });

  test("Sync: Aucune collusion de Wrap résiduel (no exception)", () async {
    final id = Uuid().v4();
    boxWrap.put(
      WrapEntity(id: Uuid().v4(), createdAt: DateTime.now().millisecondsSinceEpoch, contentId: id, storageMode: 0, shippingMode: 0),
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
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "contentId": id,
            "authorName": "Alice Dupont Machin bidule",
            "text": "Petit commentaire",
          },
          {
            "id": Uuid().v4(),
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "contentId": id,
            "authorName": "Alice Dupont Machin bidule",
            "flag": 1000,
          },
        ]),
      ),
    );
    await rawDataRepositoryImpl.syncData();
    currentWraps = boxWrap.getAll();
    expect(currentWraps.length, 1);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
