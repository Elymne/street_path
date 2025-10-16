import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';

class AddReaction extends Usecase<AddReactionParams, bool> {
  final ReactionRepository _reactionRepository;
  final ContentRepository _contentRepository;

  AddReaction(this._reactionRepository, this._contentRepository);

  @override
  Future<Result<bool>> execute(AddReactionParams params) async {
    try {
      if (await _contentRepository.exists(params.contentId) == false) {
        return Success(false);
      }
      await _reactionRepository.add(params.contentId, params.authorName, params.flag);
      return Success(true);
    } catch (err, stack) {
      SpLog().e("FindContents: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la récupération de la liste de contenu classique.");
    }
  }
}

class AddReactionParams {
  final String contentId;
  final String authorName; // todo: Surement fait automatiquement par le usecase si le "authorname" est stocké et géré quelque part.
  final ReactionType flag;
  AddReactionParams(this.contentId, this.authorName, this.flag);
}
