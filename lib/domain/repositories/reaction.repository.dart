import 'package:poc_street_path/domain/models/subcontents/reaction.model.dart';

abstract class ReactionRepository {
  Future<List<Reaction>> findFromContent(String id);
}
