import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';

class ChangeStorageMode extends Usecase<ChangeStorageModeParams, bool> {
  final WrapRepository _wrapRepository;

  ChangeStorageMode(this._wrapRepository);

  @override
  Future<Result<bool>> execute(ChangeStorageModeParams params) async {
    try {
      return Success(await _wrapRepository.changeStorageMode(params.contentId, params.storageMode));
    } catch (err, stack) {
      SpLog().e("FindContents: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la récupération de la liste de contenu classique.");
    }
  }
}

class ChangeStorageModeParams {
  final String contentId;
  final StorageMode storageMode;
  ChangeStorageModeParams(this.contentId, this.storageMode);
}
