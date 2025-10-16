import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';

class ChangeShippingMode extends Usecase<ChangeShippingModeParams, bool> {
  final WrapRepository _wrapRepository;

  ChangeShippingMode(this._wrapRepository);

  @override
  Future<Result<bool>> execute(ChangeShippingModeParams params) async {
    try {
      return Success(await _wrapRepository.changeShippingMode(params.contentId, params.shippingMode));
    } catch (err, stack) {
      SpLog().e("FindContents: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la récupération de la liste de contenu classique.");
    }
  }
}

class ChangeShippingModeParams {
  final String contentId;
  final ShippingMode shippingMode;
  ChangeShippingModeParams(this.contentId, this.shippingMode);
}
