import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/comment_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
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

  test(
    'Comment Repository: On ajoute un commentaire avec le repository. On doit retrouver ce commentaire dans la base de données.',
    () async {
      final id = Uuid().v4();
      final authorName = 'Michel Michel';
      final text = "Pas d'accord avec ce post";
      final contentId = Uuid().v4();

      await commentRepository.upsert(
        Comment(id: id, contentId: contentId, createdAt: DateTime.now().millisecondsSinceEpoch, authorName: authorName, text: text),
      );

      final commentEntity = boxComment.query(CommentEntity_.id.equals(id)).build().findFirst();
      expect(commentEntity, isNotNull);
      expect(commentEntity!.authorName, authorName);
      expect(commentEntity.text, text);
      expect(commentEntity.contentId, contentId);
    },
  );
}

class _MockPathGateway extends Mock implements PathGateway {}
