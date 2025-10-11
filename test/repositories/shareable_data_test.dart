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
import '../gateways/object_box_test.dart';

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

    boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    boxWrap = objectboxGateway.getConnector()!.box<WrapEntity>();
    boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
    boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
    boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  });

  tearDownAll(() async {
    await objectboxGateway.disconnect();
  });

  setUp(() {
    boxRawData.removeAll();
    boxWrap.removeAll();
    boxContentText.removeAll();
    boxComment.removeAll();
    boxReaction.removeAll();
  });

  test("Aucune données de cache RawData. La sync se passe sans problèmes. Table de contenu toujours vide.", () async {
    await rawDataRepositoryImpl.syncData();

    expect(3, 3);
  });
}
