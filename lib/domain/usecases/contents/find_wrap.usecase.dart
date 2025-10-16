import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';

class FindWrap extends Usecase<FindWrapParams, Wrap> {
  final WrapRepository _wrapRepository;

  FindWrap(this._wrapRepository);

  @override
  Future<Result<Wrap>> execute(FindWrapParams params) async {
    try {
      final wrap = await _wrapRepository.findOneFromContent(params.id);
      if (wrap == null) {
        return Failure("Impossible de retourver le contenu en question");
      }
      return Success(wrap);
    } catch (err, stack) {
      SpLog().e("FindWrapByID: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la récupération d'un contenu Wrapé.");
    }
  }
}

class FindWrapParams {
  final String id;
  FindWrapParams({required this.id});
}
