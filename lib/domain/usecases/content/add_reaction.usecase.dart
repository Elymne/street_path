import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/content/reaction.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';
import 'package:uuid/uuid.dart';

class AddReaction extends Usecase<AddReactionParams, bool> {
  final ContentRepository _contentRepository;
  final ReactionRepository _reactionRepository;

  AddReaction(this._reactionRepository, this._contentRepository);

  @override
  Future<Result<bool>> execute(AddReactionParams params) async {
    try {
      if (await _contentRepository.exists(params.contentId) == false) {
        return Success(false);
      }
      final newReaction = Reaction(
        contentId: params.contentId,
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: params.authorName,
        flag: params.flag,
      );
      await _reactionRepository.upsert(newReaction);
      return Success(true);
    } catch (err, stack) {
      SpLog().e('FindContents: Une exception a été levée.', err, stack: stack);
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
