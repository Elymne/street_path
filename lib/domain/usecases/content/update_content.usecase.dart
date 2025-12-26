import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_text.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';

class UpdateContent extends Usecase<UpdateContentParams, void> {
  final ContentRepository _contentRepository;

  UpdateContent(this._contentRepository);

  @override
  Future<Result<void>> execute(UpdateContentParams params) async {
    try {
      final content = await _contentRepository.findUnique(params.id);

      if (content == null) {
        SpLog().w("UpdateContent: Le contenu à modifier n'existe pas.");
        return Failure(FailureCode.notFound);
      }

      if (content is ContentText) {
        await _contentRepository.update(
          content.clone(shippingMode: params.shippingMode, storageMode: params.storageMode),
        );
        return Success(null);
      }

      if (content is ContentText) {
        await _contentRepository.update(
          content.clone(shippingMode: params.shippingMode, storageMode: params.storageMode),
        );
        return Success(null);
      }

      if (content is ContentText) {
        await _contentRepository.update(
          content.clone(shippingMode: params.shippingMode, storageMode: params.storageMode),
        );
        return Success(null);
      }

      SpLog().w("UpdateContent: Le type contenu à modifier n'est pas prit en compte.");
      return Failure(FailureCode.invalidData);
    } catch (err, stack) {
      SpLog().e('UpdateContent: Une exception a été levée.', err, stack: stack);
      return Failure(FailureCode.databaseFailure);
    }
  }
}

class UpdateContentParams {
  final String id;

  final ShippingMode? shippingMode;
  final StorageMode? storageMode;
  UpdateContentParams(this.id, {this.shippingMode, this.storageMode});
}
