import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';

class GetShareablePosts extends Usecase<GetShareablePostsParams, List<Content>> {
  final ContentRepository _postRepository;

  GetShareablePosts(this._postRepository);

  @override
  Future<Result<List<Content>>> execute(GetShareablePostsParams params) async {
    try {
      return Success(await _postRepository.findShareables());
    } catch (err, stack) {
      SpLog().e("GetShareablePosts: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite en voulant récupérer les posts partageables…");
    }
  }
}

class GetShareablePostsParams {}
