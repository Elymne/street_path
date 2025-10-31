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
        return Failure("Le contenu ${params.id} n'existe pas. La modification est impossible.");
      }

      if (content is ContentText) {
        await _contentRepository.update(content.clone(shippingMode: params.shippingMode, storageMode: params.storageMode));
        return Success(null);
      }

      if (content is ContentText) {
        await _contentRepository.update(content.clone(shippingMode: params.shippingMode, storageMode: params.storageMode));
        return Success(null);
      }

      if (content is ContentText) {
        await _contentRepository.update(content.clone(shippingMode: params.shippingMode, storageMode: params.storageMode));
        return Success(null);
      }

      return Failure("Le type du contenu en cours de modification n'est pas prit en charge par le usecase.");
    } catch (err, stack) {
      SpLog().e('FindContents: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite lors de la récupération de la liste de contenu classique.");
    }
  }
}

class UpdateContentParams {
  final String id;

  final ShippingMode? shippingMode;
  final StorageMode? storageMode;
  UpdateContentParams(this.id, {this.shippingMode, this.storageMode});
}
