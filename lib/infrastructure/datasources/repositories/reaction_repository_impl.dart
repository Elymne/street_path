import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  late final Box<ReactionEntity> _boxReaction;

  ReactionRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
  }

  @override
  Future<String> add(String contentId, String authorName, ReactionType flag) async {
    final id = Uuid().v4();
    _boxReaction.put(
      ReactionEntity(
        id: id,
        contentId: contentId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: authorName,
        flag: flag.value,
      ),
    );
    return id;
  }

  @override
  Future<List<Reaction>> findFromContent(String contentId) async {
    final condition = ReactionEntity_.contentId.equals(contentId);
    return _boxReaction.query(condition).build().find().map((elem) => elem.toModel()).toList();
  }
}
