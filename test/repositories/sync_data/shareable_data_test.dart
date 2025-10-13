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
import '../../gateways/object_box_test.dart';

/// Jeux de rests des différents comportements de l'applications avec des jeux de données étranges, valides ou non.
///
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

  test("OMG LE TEST DE BAISé WESH", () async {
    await rawDataRepositoryImpl.syncData();
    // * Enorme la blague.
    expect("caca", "pipi");
  });
}
