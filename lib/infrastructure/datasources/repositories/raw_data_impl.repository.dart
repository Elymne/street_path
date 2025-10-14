import 'package:poc_street_path/domain/models/subcontents/comment.model.dart';
import 'package:poc_street_path/domain/models/contents/content_text.model.dart';
import 'package:poc_street_path/domain/models/subcontents/reaction.model.dart';
import 'package:poc_street_path/domain/models/subcontents/wrap.model.dart';
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
    _boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
    _boxWrap = objectboxGateway.getConnector()!.box<WrapEntity>();
    _boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
    _boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  }

  @override
  Future<String> add(String data) async {
    final id = Uuid().v4();
    _boxRawData.put(RawDataEntity(id: id, createdAt: DateTime.now().millisecondsSinceEpoch, data: data), mode: PutMode.insert);
    return id;
  }

  @override
  Future<String> findShareableData(int dataLimit, int dayLimit) async {
    final List<String> ids = [];
    final List<Object> data = [];

    final query = WrapEntity_.shippingMode.equals(ShippingMode.creator.value);
    final contents = (_boxWrap.query(query).order(WrapEntity_.createdAt).build()..limit = 10).find();
    ids.addAll(contents.map((elem) => elem.contentId));

    if (ids.length < dataLimit) {
      final query = WrapEntity_.shippingMode.equals(ShippingMode.important.value);
      final contents = (_boxWrap.query(query).build()..limit = 10 - ids.length).find();
      ids.addAll(contents.map((elem) => elem.contentId));
    }

    if (ids.length < dataLimit) {
      final query = WrapEntity_.shippingMode.equals(ShippingMode.normal.value);
      final contents = (_boxWrap.query(query).build()..limit = 10 - ids.length).find();
      ids.addAll(contents.map((elem) => elem.contentId));
    }

    final textContents = _boxContentText.query(ContentTextEntity_.id.oneOf(ids)).build().find().map((elem) => elem.toModel());
    data.addAll(textContents);
    // todo : Ajouter tous les types de contenus.

    final reactions = _boxReaction.query(ReactionEntity_.contentId.oneOf(ids)).build().find().map((elem) => elem.toModel());
    data.addAll(reactions);

    final comments = _boxComment.query(CommentEntity_.contentId.oneOf(ids)).build().find().map((elem) => elem.toModel());
    data.addAll(comments);

    return jsonEncode(data);
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
          final model = ContentTextEntity.fromModel(content);
          model.bounces++;
          _boxContentText.put(model);
          final wrap = _boxWrap.query(WrapEntity_.contentId.equals(content.id)).build().findFirst();
          if (wrap != null) {
            _boxWrap.remove(wrap.obId);
          }
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
          if (_boxContentText.query(ContentTextEntity_.id.equals(comment.contentId)).build().find().isEmpty) {
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
          if (_boxContentText.query(ContentTextEntity_.id.equals(reaction.contentId)).build().find().isEmpty) {
            continue;
          }
          _boxReaction.put(ReactionEntity.fromModel(reaction));
          added++;
        }
      }
    }
    _boxRawData.removeAll(); // * Cler du cache.
    return added;
  }
}
