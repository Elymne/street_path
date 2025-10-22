import 'package:poc_street_path/core/globals.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';

class ClearOldData extends Usecase<ClearOldDataParams, int> {
  final DatabaseGateway _databaseGateway;

  final WrapRepository _wrapRepository;
  final ContentRepository _contentRepository;
  final CommentRepository _commentRepository;
  final ReactionRepository _reactionRepository;

  ClearOldData(this._databaseGateway, this._wrapRepository, this._contentRepository, this._commentRepository, this._reactionRepository);

  @override
  Future<Result<int>> execute(ClearOldDataParams params) async {
    try {
      int deleteCount = 0;

      final timeLimit = params.timeLimit ?? defaultDbDataTime;
      final idsDeleteTime = (await _contentRepository.findMany(maxTime: timeLimit)).map((elem) => elem.id).toList();

      if (idsDeleteTime.isNotEmpty) {
        final deletedByTimeRes = await Future.wait([
          _contentRepository.deleteMany(idsDeleteTime),
          _wrapRepository.deleteByContents(idsDeleteTime),
          _commentRepository.deleteByContents(idsDeleteTime),
          _reactionRepository.deleteByContents(idsDeleteTime),
        ]);
        deleteCount = deleteCount + deletedByTimeRes[0];
      }

      final baseLimit = params.sizeLimit ?? defaultDbLimitSize;
      while (baseLimit >= await _databaseGateway.getCurrentSize()) {
        final idsDeleteSize = (await _contentRepository.findForSizeDeletion(chunkDeleteCount)).map((elem) => elem.id).toList();
        final deletedBySizeRes = await Future.wait([
          _contentRepository.deleteMany(idsDeleteSize),
          _wrapRepository.deleteByContents(idsDeleteSize),
          _commentRepository.deleteByContents(idsDeleteSize),
          _reactionRepository.deleteByContents(idsDeleteSize),
        ]);
        deleteCount = deleteCount + deletedBySizeRes[0];
      }

      return Success(deleteCount);
    } catch (err, stack) {
      SpLog().e("ClearOldData: Une exception a été levée.", err, stack: stack);
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
