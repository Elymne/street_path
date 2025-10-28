import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  late final Box<ReactionEntity> _boxReaction;

  ReactionRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
  }

  @override
  Future<void> upsert(Reaction reaction) async {
    _boxReaction.put(ReactionEntity.fromModel(reaction));
  }

  @override
  Future<List<Reaction>> findFromContent(String contentId) async {
    final condition = ReactionEntity_.contentId.equals(contentId);
    return _boxReaction.query(condition).build().find().map((elem) => elem.toModel()).toList();
  }
}
