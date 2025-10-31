import 'package:poc_street_path/domain/models/content/comment.model.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/comment_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
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
  late final CommentRepository commentRepository;
  late final Box<CommentEntity> boxComment;

  setUpAll(() async {
    pathGateway = _MockPathGateway();
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();

    commentRepository = CommentRepositoryImpl(objectboxGateway);
    boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  });

  setUp(() {
    boxComment.removeAll();
    expect(boxComment.getAll().isEmpty, true, reason: 'Empty on start');
  });

  tearDownAll(() async {
    boxComment.removeAll();
    await objectboxGateway.disconnect();
  });

  test('CommentRepository.commentRepository.deleteMany(): Suppression de plusieurs commentaires.', () async {
    final id = Uuid().v4();
    final id2 = Uuid().v4();
    await commentRepository.insert(
      Comment(
        id: id,
        contentId: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: 'Michel Michel',
        text: "Pas d'accord avec ce post",
      ),
    );

    await commentRepository.insert(
      Comment(
        id: id2,
        contentId: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: 'Michel Michel',
        text: "Pas d'accord avec ce post",
      ),
    );

    await commentRepository.insert(
      Comment(
        id: Uuid().v4(),
        contentId: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: 'Michel Michel',
        text: "Pas d'accord avec ce post",
      ),
    );

    await commentRepository.deleteMany([id, id2]);

    final comments = boxComment.getAll();
    expect(comments, isNotEmpty);
    expect(comments.length, 1);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
