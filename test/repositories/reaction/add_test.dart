import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/reaction_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/models/content/reaction.model.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final PathGateway pathGateway;
  late final ObjectBoxGateway objectboxGateway;
  late final ReactionRepositoryImpl reactionRepository;

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
    'Comment Repository: On ajoute une réaction avec le repository. On doit retrouver ce commentaire dans la base de données.',
    () async {
      final id = Uuid().v4();
      final authorName = 'Michel Michel';
      final reaction = ReactionType.like;
      final contentId = Uuid().v4();
      await reactionRepository.upsert(
        Reaction(contentId: contentId, id: id, createdAt: DateTime.now().millisecondsSinceEpoch, authorName: authorName, flag: reaction),
      );

      final reactionEntity = boxReaction.query(ReactionEntity_.id.equals(id)).build().findFirst();
      expect(reactionEntity, isNotNull);
      expect(reactionEntity!.authorName, authorName);
      expect(reactionEntity.flag, reaction.value);
      expect(reactionEntity.contentId, contentId);
    },
  );
}

class _MockPathGateway extends Mock implements PathGateway {}
