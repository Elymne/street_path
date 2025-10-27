import 'package:poc_street_path/infrastructure/datasources/repositories/reaction_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
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
  late final ReactionRepository reactionRepository;

  late final Box<ReactionEntity> boxReaction;

  setUpAll(() async {
    pathGateway = _MockPathGateway();
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();

    reactionRepository = ReactionRepositoryImpl(objectboxGateway);
    boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
  });

  setUp(() {
    boxReaction.removeAll();
    expect(boxReaction.getAll().isEmpty, true, reason: 'Empty on start');
  });

  tearDownAll(() async {
    boxReaction.removeAll();
    await objectboxGateway.disconnect();
  });

  test(
    "Comment Repository: On ajoute un commentaire avec le repository. On doit retrouver le commentaire à partir de l'id du contenu qu'il représente.",
    () async {
      final authorName = 'Michel Michel';
      final reaction = ReactionType.like;
      final contentId = Uuid().v4();
      final idCreated = await reactionRepository.add(contentId, authorName, reaction);

      final comment = await reactionRepository.findFromContent(contentId);
      expect(comment, isNotEmpty);
      expect(comment.length, 1);
      expect(comment[0].id, idCreated);
      expect(comment[0].authorName, authorName);
      expect(comment[0].flag, reaction);
      expect(comment[0].contentId, contentId);
    },
  );
}

class _MockPathGateway extends Mock implements PathGateway {}
