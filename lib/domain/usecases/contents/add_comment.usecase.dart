import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';

class AddComment extends Usecase<AddCommentParams, bool> {
  final CommentRepository _commentRepository;
  final ContentRepository _contentRepository;

  AddComment(this._commentRepository, this._contentRepository);

  @override
  Future<Result<bool>> execute(AddCommentParams params) async {
    try {
      if (await _contentRepository.exists(params.contentId) == false) {
        return Success(false);
      }
      await _commentRepository.add(params.contentId, params.authorName, params.text);
      return Success(true);
    } catch (err, stack) {
      SpLog().e("FindContents: Une exception a été levée.", err, stack: stack);
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
