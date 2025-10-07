import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/post/post.model.dart';
import 'package:poc_street_path/domain/repositories/post.repository.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';

class SyncPostParams {}

class SyncPost extends Usecase<SyncPostParams, List<Post>> {
  final RawDataRepository _rawDataRepository;
  final PostRepository _postRepository;

  SyncPost(this._rawDataRepository, this._postRepository);

  @override
  Future<Result<List<Post>>> execute(SyncPostParams params) async {
    try {
      final rawData = await _rawDataRepository.find();
      final List<Post> postsSync = [];

      for (final data in rawData) {
        final post = await _rawDataRepository.transformToPost(data);
        if (post == null) continue; // * La donnée n'est pas un post, on passe à la suivante.

        await Future.wait([_postRepository.add(post), _rawDataRepository.delete(data.id)]);
        postsSync.add(post);
      }

      return Success(postsSync);
    } catch (err, stack) {
      SpLog().e("SyncPost: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la synchronisation des données BLE/WIFI…");
    }
  }
}
