import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';

class FindContents extends Usecase<FindContentParams, List<Content>> {
  final ContentRepository _contentRepository;

  FindContents(this._contentRepository);

  @override
  Future<Result<List<Content>>> execute(FindContentParams params) async {
    try {
      final contents = await _contentRepository.findMany();
      return Success(contents);
    } catch (err, stack) {
      SpLog().e("FindContents: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la récupération de la liste de contenu classique.");
    }
  }
}

class FindContentParams {}
