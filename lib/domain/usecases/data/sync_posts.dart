import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';

class SyncPost extends Usecase<SyncPostParams, int> {
  final RawDataRepository _rawDataRepository;

  SyncPost(this._rawDataRepository);

  @override
  Future<Result<int>> execute(SyncPostParams params) async {
    try {
      return Success(await _rawDataRepository.syncData());
    } catch (err, stack) {
      SpLog().e("SyncPost: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la synchronisation des données BLE/WIFI…");
    }
  }
}

class SyncPostParams {}
