import 'package:poc_street_path/core/globals.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/domain/models/content/content.model.dart';
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

      // * Récupération des contenus "périmés".
      final expiredContents = await _contentRepository.findMany(0, 0, createdAfter: defaultDbDataTime, storageModes: [StorageMode.normal]);
      final expiredIds = expiredContents.map((content) => content.id).toList();

      final deletedRes = await Future.wait([
        _contentRepository.deleteMany(expiredIds),
        _commentRepository.deleteMany(expiredIds),
        _reactionRepository.deleteMany(expiredIds),
      ]);
      deleteCount += deletedRes[0] + deletedRes[1] + deletedRes[2];

      int safeCheckIncr = 0;
      while (defaultDbLimitSize <= await _databaseGateway.getCurrentSize() || safeCheckIncr < 10) {
        final expiredContents = await _contentRepository.findMany(20, 1, orderBy: [ContentOrderBy.oldest]);
        final expiredIds = expiredContents.map((content) => content.id).toList();
        final deletedRes = await Future.wait([
          _contentRepository.deleteMany(expiredIds),
          _commentRepository.deleteMany(expiredIds),
          _reactionRepository.deleteMany(expiredIds),
        ]);
        deleteCount += deletedRes[0] + deletedRes[1] + deletedRes[2];
        safeCheckIncr++;
      }

      return Success(deleteCount);
    } catch (err, stack) {
      SpLog().e('ClearOldData: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite lors la suppression automatique des contenus…");
    }
  }
}

class ClearOldDataParams {
  ClearOldDataParams();
}
