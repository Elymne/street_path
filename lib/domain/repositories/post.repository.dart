import 'package:poc_street_path/domain/models/post/post.model.dart';

abstract class PostRepository {
  Future<Post> add(Post post);
  Future<List<Post>> findShareables();
}
