import 'package:poc_street_path/core/globals.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';

class ClearOldData extends Usecase<ClearOldDataParams, int> {
  final DatabaseGateway _databaseGateway;
  final ContentRepository _contentRepository;
  final CommentRepository _commentRepository;
  final ReactionRepository _reactionRepository;

  ClearOldData(this._databaseGateway, this._contentRepository, this._commentRepository, this._reactionRepository);

  @override
  Future<Result<int>> execute(ClearOldDataParams params) async {
    try {
      int deleteCount = 0;

      final firstBatch = await _contentRepository.findMany(0, 0, createdAfter: defaultDbDataTime);

      // deleteCount = await _wrapRepository.deleteMany(firstBatch);

      // // TODO: Mettre un garde fou pour cycle infini.
      // while (defaultDbLimitSize <= await _databaseGateway.getCurrentSize()) {
      //   final newBatch = await _wrapRepository.getOldestIds(20);
      //   deleteCount = await _wrapRepository.deleteMany(newBatch) + deleteCount;
      // }

      return Success(deleteCount);
    } catch (err, stack) {
      SpLog().e('ClearOldData: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite lors la suppression automatique des contenus…");
    }
  }
}

class ClearOldDataParams {
  // todo: Sera géré plus tard par des options utilisateus.
  final int? timeLimit;
  final int? sizeLimit;
  ClearOldDataParams({this.sizeLimit, this.timeLimit});
}
