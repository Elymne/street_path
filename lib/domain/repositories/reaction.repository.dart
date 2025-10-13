import 'package:poc_street_path/domain/models/contents/reaction.model.dart';

abstract class ReactionRepository {
  Future<List<Reaction>> findFromContent(String id);
}
