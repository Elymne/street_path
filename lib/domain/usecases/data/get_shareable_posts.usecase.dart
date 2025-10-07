import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/post/post.model.dart';
import 'package:poc_street_path/domain/repositories/post.repository.dart';

class GetShareablePostsParams {}

class GetShareablePosts extends Usecase<GetShareablePostsParams, List<Post>> {
  final PostRepository _postRepository;

  GetShareablePosts(this._postRepository);

  @override
  Future<Result<List<Post>>> execute(GetShareablePostsParams params) async {
    try {
      return Success(await _postRepository.findShareables());
    } catch (err, stack) {
      SpLog.instance.e("GetShareablePosts: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite en voulant récupérer les posts partageables…");
    }
  }
}
