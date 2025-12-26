import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/content/comment.model.dart';
import 'package:poc_street_path/domain/models/content/reaction.model.dart';
import 'package:poc_street_path/domain/models/content/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';

class FindUniqueContent extends Usecase<FindUniqueContentParams, Wrap?> {
  final ContentRepository _contentRepository;
  final CommentRepository _commentRepository;
  final ReactionRepository _reactionRepository;

  FindUniqueContent(this._contentRepository, this._commentRepository, this._reactionRepository);

  @override
  Future<Result<Wrap?>> execute(FindUniqueContentParams params) async {
    try {
      final content = await _contentRepository.findUnique(params.id);
      if (content == null) {
        return Success(null);
      }
      final res = await Future.wait([
        _reactionRepository.findFromContent(params.id),
        _commentRepository.findFromContent(params.id),
      ]);

      return Success(Wrap(content: content, reactions: res[0] as List<Reaction>, comments: res[1] as List<Comment>));
    } catch (err, stack) {
      SpLog().e('FindUniqueContent: Une exception a été levée.', err, stack: stack);
      return Failure(FailureCode.databaseFailure);
    }
  }
}

class FindUniqueContentParams {
  final String id;
  FindUniqueContentParams(this.id);
}
