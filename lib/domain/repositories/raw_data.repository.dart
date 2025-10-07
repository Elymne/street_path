abstract class RawDataRepository {
  Future<String> add(String data);
  Future<bool> delete(String id);
  Future<int> syncPosts();
}
