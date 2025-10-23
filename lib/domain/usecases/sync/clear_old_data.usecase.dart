import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';

class ClearOldData extends Usecase<ClearOldDataParams, int> {
  final DatabaseGateway _databaseGateway;
  final WrapRepository _wrapRepository;

  ClearOldData(this._databaseGateway, this._wrapRepository);

  @override
  Future<Result<int>> execute(ClearOldDataParams params) async {
    try {
      int deleteCount = 0;

      // // * Vérification de la date de créations des contenu les plus vieux.
      // final timeLimit = params.timeLimit ?? defaultDbDataTime;
      // final idsDeleteTime = (await _contentRepository.findMany(maxTime: timeLimit)).map((elem) => elem.id).toList();
      // if (idsDeleteTime.isNotEmpty) {
      //   // * Suppression par date de création max.
      //   final deletedByTimeRes = await Future.wait([_wrapRepository.deleteMany(idsDeleteTime)]);
      //   deleteCount = deleteCount + deletedByTimeRes[0];
      // }

      // // * Check selon le poid total.
      // final baseLimit = params.sizeLimit ?? defaultDbLimitSize;
      // while (baseLimit >= await _databaseGateway.getCurrentSize()) {
      //   final idsDeleteSize = (await _contentRepository.findForAutoSuppresion(chunkDeleteCount)).map((elem) => elem.id).toList();
      //   final deletedBySizeRes = await Future.wait([_wrapRepository.deleteMany(idsDeleteSize)]);
      //   deleteCount = deleteCount + deletedBySizeRes[0];
      // }

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
