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

  @override
  Future<void> clear() async {
    _boxRawData.removeAll();
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
}
