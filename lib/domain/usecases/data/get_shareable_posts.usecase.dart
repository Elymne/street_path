import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';

class GetShareableContents extends Usecase<GetShareableContentsParams, String> {
  final RawDataRepository _rawDataRepository;

  GetShareableContents(this._rawDataRepository);

  @override
  Future<Result<String>> execute(GetShareableContentsParams params) async {
    try {
      return Success(await _rawDataRepository.findShareableData());
    } catch (err, stack) {
      SpLog().e("GetShareablePosts: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite en voulant récupérer les posts partageables…");
    }
  }
}

class GetShareableContentsParams {}
