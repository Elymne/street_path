import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/models/contents/content_text.model.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/content_text.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/raw_data.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/reaction.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/wrap.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class RawDataRepositoryImpl implements RawDataRepository {
  late final Box<RawDataEntity> _boxRawData;
  late final Box<WrapEntity> _boxWrap;
  late final Box<ContentTextEntity> _boxContentText;
  late final Box<CommentEntity> _boxComment;
  late final Box<ReactionEntity> _boxReaction;

  RawDataRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxWrap = objectboxGateway.getConnector()!.box<WrapEntity>();
    _boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
    _boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
    _boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  }

  @override
  Future<String> add(String data) async {
    final id = Uuid().v4();
    _boxRawData.put(RawDataEntity(id: id, createdAt: DateTime.now().millisecondsSinceEpoch, data: data), mode: PutMode.insert);
    return id;
  }

  @override
  Future<String> findShareableData() async {
    final List<String> ids = [];

    final condition1 = WrapEntity_.shippingMode.equals(ShippingMode.creator.value);
    ids.addAll((_boxWrap.query(condition1).order(WrapEntity_.createdAt).build()..limit = 10).find().map((elem) => elem.id));
    if (ids.length >= 10) {
      final contentTextEntities = _boxContentText.query(ContentTextEntity_.id.oneOf(ids)).build().find();
      return jsonEncode([...contentTextEntities.map((elem) => elem.toModel())]);
    }

    final condition2 = WrapEntity_.shippingMode.equals(ShippingMode.important.value);
    ids.addAll((_boxWrap.query(condition2).build()..limit = 10 - ids.length).find().map((elem) => elem.id));
    if (ids.length >= 10) {
      final contentTextEntities = _boxContentText.query(ContentTextEntity_.id.oneOf(ids)).build().find();
      return jsonEncode([...contentTextEntities.map((elem) => elem.toModel())]);
    }

    final condition3 = WrapEntity_.shippingMode.equals(ShippingMode.normal.value);
    ids.addAll((_boxWrap.query(condition3).build()..limit = 10 - ids.length).find().map((elem) => elem.id).toList());
    final contentTextEntities = _boxContentText.query(ContentTextEntity_.id.oneOf(ids)).build().find();
    return jsonEncode([...contentTextEntities.map((elem) => elem.toModel())]);
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
          if (_boxContentText.query(ContentTextEntity_.id.equals(content.id)).build().find().isNotEmpty) {
            continue;
          }
          _boxContentText.put(ContentTextEntity.fromModel(content));
          _boxWrap.put(
            WrapEntity(
              id: Uuid().v4(),
              createdAt: DateTime.now().millisecondsSinceEpoch,
              contentId: content.id,
              storageMode: StorageMode.normal.value,
              shippingMode: ShippingMode.normal.value,
            ),
          );
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
