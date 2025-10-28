import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';
import 'package:uuid/uuid.dart';

class AddComment extends Usecase<AddCommentParams, bool> {
  final CommentRepository _commentRepository;
  final WrapRepository _wrapRepository;

  AddComment(this._commentRepository, this._wrapRepository);

  @override
  Future<Result<bool>> execute(AddCommentParams params) async {
    try {
      if (await _wrapRepository.exists(params.contentId) == false) {
        return Success(false);
      }

      final newComment = Comment(
        id: Uuid().v4(),
        contentId: params.contentId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: params.authorName,
        text: params.text,
      );
      await _commentRepository.upsert(newComment);

      return Success(true);
    } catch (err, stack) {
      SpLog().e('FindContents: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite lors de la récupération de la liste de contenu classique.");
    }
  }
}

class AddCommentParams {
  final String contentId;
  final String authorName;
  final String text;
  AddCommentParams(this.contentId, this.authorName, this.text);
}
