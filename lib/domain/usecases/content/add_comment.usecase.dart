import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/content/comment.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:uuid/uuid.dart';

class AddComment extends Usecase<AddCommentParams, bool> {
  final ContentRepository _contentRepository;
  final CommentRepository _commentRepository;

  AddComment(this._contentRepository, this._commentRepository);

  @override
  Future<Result<bool>> execute(AddCommentParams params) async {
    try {
      if (await _contentRepository.exists(params.contentId) == false) {
        return Success(false);
      }

      final newComment = Comment(
        id: Uuid().v4(),
        contentId: params.contentId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: params.authorName,
        text: params.text,
      );

      await _commentRepository.insert(newComment);

      return Success(true);
    } catch (err, stack) {
      SpLog().e('AddComment: Une erreur a été levée.', err, stack: stack);
      return Failure(FailureCode.databaseFailure);
    }
  }
}

class AddCommentParams {
  final String contentId;
  final String authorName;
  final String text;
  AddCommentParams(this.contentId, this.authorName, this.text);
}
