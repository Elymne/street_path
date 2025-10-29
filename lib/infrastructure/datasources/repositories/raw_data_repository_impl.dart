import 'package:poc_street_path/domain/models/cache/raw_data.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/caches/raw_data_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class RawDataRepositoryImpl implements RawDataRepository {
  late final Box<RawDataEntity> _boxRawData;

  RawDataRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxRawData = objectboxGateway.getConnector()!.box<RawDataEntity>();
  }

  @override
  Future<void> add(RawData rawData) async {
    _boxRawData.put(RawDataEntity.fromModel(rawData), mode: PutMode.insert);
  }

  @override
  Future<List<RawData>> findAll() async {
    return _boxRawData.getAll().map((elem) => elem.toModel()).toList();
  }

  // @override
  // Future<String> findShareableData(int dataLimit, int dayLimit) async {
  //   final List<String> ids = [];
  //   final List<Object> data = [];

  //   final query = WrapEntity_.shippingMode.equals(ShippingMode.creator.value);
  //   final contents = (_boxWrap.query(query).order(WrapEntity_.createdAt).build()..limit = 10).find();
  //   ids.addAll(contents.map((elem) => elem.contentId));

  //   if (ids.length < dataLimit) {
  //     final query = WrapEntity_.shippingMode.equals(ShippingMode.important.value);
  //     final contents = (_boxWrap.query(query).build()..limit = 10 - ids.length).find();
  //     ids.addAll(contents.map((elem) => elem.contentId));
  //   }

  //   if (ids.length < dataLimit) {
  //     final query = WrapEntity_.shippingMode.equals(ShippingMode.normal.value);
  //     final contents = (_boxWrap.query(query).build()..limit = 10 - ids.length).find();
  //     ids.addAll(contents.map((elem) => elem.contentId));
  //   }

  //   final textContents = _boxContentText.query(ContentTextEntity_.id.oneOf(ids)).build().find().map((elem) => elem.toModel());
  //   data.addAll(textContents);
  //   final linkContents = _boxContentLink.query(ContentLinkEntity_.id.oneOf(ids)).build().find().map((elem) => elem.toModel());
  //   data.addAll(linkContents);
  //   final mediaContents = _boxContentMedia.query(ContentMediaEntity_.id.oneOf(ids)).build().find().map((elem) => elem.toModel());
  //   data.addAll(mediaContents);

  //   final reactions = _boxReaction.query(ReactionEntity_.contentId.oneOf(ids)).build().find().map((elem) => elem.toModel());
  //   data.addAll(reactions);

  //   final comments = _boxComment.query(CommentEntity_.contentId.oneOf(ids)).build().find().map((elem) => elem.toModel());
  //   data.addAll(comments);

  //   return jsonEncode(data);
  // }

  // @override
  // Future<int> syncData() async {
  //   var added = 0;
  //   final rawDataList = _boxRawData.getAll();
  //   for (final rawData in rawDataList) {
  //     final dataList = jsonDecode(rawData.data);
  //     if (dataList is! List) {
  //       continue;
  //     }

  //     for (final data in dataList) {
  //       // * CHECKER : ContentText.
  //       if (ContentText.isValidJson(data)) {
  //         final content = ContentText.fromJson(data);
  //         if (_boxContentText.query(ContentTextEntity_.id.equals(content.id)).build().find().isNotEmpty) {
  //           continue;
  //         }
  //         final model = ContentTextEntity.fromModel(content);
  //         model.bounces++;
  //         _boxContentText.put(model);
  //         final wrap = _boxWrap.query(WrapEntity_.contentId.equals(content.id)).build().findFirst();
  //         if (wrap != null) {
  //           _boxWrap.remove(wrap.obId);
  //         }
  //         _boxWrap.put(
  //           WrapEntity(
  //             id: Uuid().v4(),
  //             createdAt: DateTime.now().millisecondsSinceEpoch,
  //             contentId: content.id,
  //             storageMode: StorageMode.normal.value,
  //             shippingMode: ShippingMode.normal.value,
  //           ),
  //         );
  //         added++;
  //       }

  //       // * CHECKER : ContentLink.
  //       if (ContentLink.isValidJson(data)) {
  //         final content = ContentLink.fromJson(data);
  //         if (_boxContentLink.query(ContentLinkEntity_.id.equals(content.id)).build().find().isNotEmpty) {
  //           continue;
  //         }
  //         final model = ContentLinkEntity.fromModel(content);

  //         // todo: Check path validity.

  //         model.bounces++;
  //         _boxContentLink.put(model);
  //         final wrap = _boxWrap.query(WrapEntity_.contentId.equals(content.id)).build().findFirst();
  //         if (wrap != null) {
  //           _boxWrap.remove(wrap.obId);
  //         }
  //         _boxWrap.put(
  //           WrapEntity(
  //             id: Uuid().v4(),
  //             createdAt: DateTime.now().millisecondsSinceEpoch,
  //             contentId: content.id,
  //             storageMode: StorageMode.normal.value,
  //             shippingMode: ShippingMode.normal.value,
  //           ),
  //         );
  //         added++;
  //       }

  //       // * CHECKER : ContentMedia.
  //       if (ContentMedia.isValidJson(data)) {
  //         final content = ContentMedia.fromJson(data);
  //         if (_boxContentMedia.query(ContentMediaEntity_.id.equals(content.id)).build().find().isNotEmpty) {
  //           continue;
  //         }
  //         final model = ContentMediaEntity.fromModel(content);
  //         model.bounces++;
  //         _boxContentMedia.put(model);
  //         final wrap = _boxWrap.query(WrapEntity_.contentId.equals(content.id)).build().findFirst();
  //         if (wrap != null) {
  //           _boxWrap.remove(wrap.obId);
  //         }
  //         _boxWrap.put(
  //           WrapEntity(
  //             id: Uuid().v4(),
  //             createdAt: DateTime.now().millisecondsSinceEpoch,
  //             contentId: content.id,
  //             storageMode: StorageMode.normal.value,
  //             shippingMode: ShippingMode.normal.value,
  //           ),
  //         );
  //         added++;
  //       }

  //       // * CHECKER : Comment.
  //       if (Comment.isValidJson(data)) {
  //         final comment = Comment.fromJson(data);
  //         if (_boxComment.query(CommentEntity_.id.equals(comment.id)).build().find().isNotEmpty) {
  //           continue;
  //         }
  //         if (_boxContentText.query(ContentTextEntity_.id.equals(comment.contentId)).build().find().isEmpty) {
  //           continue;
  //         }
  //         _boxComment.put(CommentEntity.fromModel(comment));
  //         added++;
  //       }

  //       // * CHECKER : Reaction.
  //       if (Reaction.isValidJson(data)) {
  //         final reaction = Reaction.fromJson(data);
  //         if (_boxReaction.query(ReactionEntity_.id.equals(reaction.id)).build().find().isNotEmpty) {
  //           continue;
  //         }
  //         if (_boxContentText.query(ContentTextEntity_.id.equals(reaction.contentId)).build().find().isEmpty) {
  //           continue;
  //         }
  //         _boxReaction.put(ReactionEntity.fromModel(reaction));
  //         added++;
  //       }
  //     }
  //   }
  //   _boxRawData.removeAll(); // * Clear du cache.
  //   return added;
  // }
}
