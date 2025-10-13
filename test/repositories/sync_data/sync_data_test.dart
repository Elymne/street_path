import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/content_text.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/raw_data.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/reaction.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/wrap.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_impl.repository.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';
import '../../gateways/object_box_test.dart';

/// Jeux de tests de véfication du transferts des données entre deux appareils et du fonctionnement du cache (table raw_data).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final pathGateway = MockPathGateway();
  late final ObjectBoxGateway objectboxGateway;
  late final RawDataRepositoryImpl rawDataRepositoryImpl;

  // * Accès direct aux tables pour les tests.
  late final Box<RawDataEntity> boxRawData;
  late final Box<WrapEntity> boxWrap;
  late final Box<ContentTextEntity> boxContentText;
  late final Box<CommentEntity> boxComment;
  late final Box<ReactionEntity> boxReaction;

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
  });

  tearDownAll(() async {
    boxRawData.removeAll();
    boxWrap.removeAll();
    boxContentText.removeAll();
    boxComment.removeAll();
    boxReaction.removeAll();
    await objectboxGateway.disconnect();
  });

  test("Aucune données de cache. La sync se passe sans problèmes. Table de contenu toujours vide.", () async {
    List<RawDataEntity> currentCache = [];
    List<ContentTextEntity> currentTextContent = [];

    currentCache = boxRawData.getAll();
    currentTextContent = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Cache vide au début du test.");
    expect(currentTextContent.isEmpty, true, reason: "Contenu vide au début du test.");

    await rawDataRepositoryImpl.syncData();
    currentCache = boxRawData.getAll();
    currentTextContent = boxContentText.getAll();
    expect(currentCache.isEmpty, true, reason: "Le cache est toujours vide");
    expect(currentTextContent.isEmpty, true, reason: "Il n'y a toujours pas de contenu.");
  });

  test(
    "Une données en cache qui correspond à la structure d'un contenu de texte. La sync se passe sans problèmes. Table de contenu non vide.",
    () async {
      List<RawDataEntity> currentCache = [];
      List<ContentTextEntity> currentTextContent = [];

      currentCache = boxRawData.getAll();
      currentTextContent = boxContentText.getAll();
      expect(currentCache.isEmpty, true, reason: "Cache vide au début du test.");
      expect(currentTextContent.isEmpty, true, reason: "Contenu vide au début du test.");

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
      currentCache = boxRawData.getAll();
      expect(currentCache.length, 1, reason: "Une nouvelle donnée dans le cache.");

      final result = await rawDataRepositoryImpl.syncData();
      expect(result, 1, reason: "La fonction de sync retourne le bon nombre d'éléments sync dans la DB.");

      currentCache = boxRawData.getAll();
      currentTextContent = boxContentText.getAll();
      expect(currentCache.isEmpty, true, reason: "Le cache est a présent vide.");
      expect(currentTextContent.length, 1, reason: "Une nouvelle entrée de contenu sync.");
    },
  );
}
