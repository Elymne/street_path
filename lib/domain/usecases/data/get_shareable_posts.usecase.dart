import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/post/post.model.dart';

class GetShareablePostsParams {}

class GetShareablePosts extends Usecase<GetShareablePostsParams, List<Post>> {
  @override
  Future<Result<List<Post>>> execute(GetShareablePostsParams params) async {
    try {
      return Success([]);
    } catch (err, stack) {
      SpLog.instance.e("AddRawData: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de l'ajout d'une donnée brute…");
    }
  }
}
