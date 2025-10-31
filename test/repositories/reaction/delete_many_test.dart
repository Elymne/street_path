import 'package:poc_street_path/domain/models/content/reaction.model.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/reaction_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
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

  test('CommentRepository.commentRepository.deleteMany()', () async {
    final id = Uuid().v4();
    final id2 = Uuid().v4();
    await reactionRepository.insert(
      Reaction(
        id: id,
        contentId: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: 'Michel Michel',
        flag: ReactionType.like,
      ),
    );

    await reactionRepository.insert(
      Reaction(
        id: id2,
        contentId: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: 'Michel Michel',
        flag: ReactionType.like,
      ),
    );

    await reactionRepository.insert(
      Reaction(
        id: Uuid().v4(),
        contentId: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: 'Michel Michel',
        flag: ReactionType.like,
      ),
    );

    await reactionRepository.deleteMany([id, id2]);

    final reactions = boxReaction.getAll();
    expect(reactions, isNotEmpty);
    expect(reactions.length, 1);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
