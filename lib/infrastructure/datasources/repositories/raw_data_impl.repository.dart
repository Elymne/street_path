import 'dart:convert';
import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/models/contents/content_text.model.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/content.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/raw_data.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/reaction.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';

class RawDataRepositoryImpl implements RawDataRepository {
  late final Box<RawDataEntity> _boxRawData;
  late final Box<ContentTextEntity> _boxContent;
  late final Box<CommentEntity> _boxComment;
  late final Box<ReactionEntity> _boxReaction;

  RawDataRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
    _boxContent = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
    _boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
  }

  @override
  Future<String> add(String data) async {
    final id = Uuid().v4();
    _boxRawData.put(RawDataEntity(id: id, createdAt: DateTime.now().millisecondsSinceEpoch, data: data), mode: PutMode.insert);
    return id;
  }

  @override
  Future<int> syncData() async {
    var added = 0;
    final rawDataList = _boxRawData.getAll();
    for (final rawData in rawDataList) {
      final dataList = jsonDecode(rawData.data);
      if (dataList is! List) {
        continue;
      }

      for (final data in dataList) {
        if (ContentText.isValidJson(data)) {
          final content = ContentText.fromJson(data);
          if (_boxContent.query(ContentTextEntity_.id.equals(content.id)).build().find().isNotEmpty) {
            continue;
          }
          _boxContent.put(ContentTextEntity.fromModel(content));
          added++;
        }

        if (Comment.isValidJson(data)) {
          final comment = Comment.fromJson(data);
          if (_boxComment.query(CommentEntity_.id.equals(comment.id)).build().find().isNotEmpty) {
            continue;
          }
          _boxComment.put(CommentEntity.fromModel(comment));
          added++;
        }

        if (Reaction.isValidJson(data)) {
          final reaction = Reaction.fromJson(data);
          if (_boxReaction.query(ReactionEntity_.id.equals(reaction.id)).build().find().isNotEmpty) {
            continue;
          }
          _boxReaction.put(ReactionEntity.fromModel(reaction));
          added++;
        }
      }
      _boxRawData.remove(rawData.obId);
    }

    return added;
  }
}
