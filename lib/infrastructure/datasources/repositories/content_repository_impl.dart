import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_link.model.dart';
import 'package:poc_street_path/domain/models/content/content_media.model.dart';
import 'package:poc_street_path/domain/models/content/content_text.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/objectbox.g.dart';

class ContentRepositoryImpl implements ContentRepository {
  late final Box<ContentTextEntity> _boxContentText;
  late final Box<ContentLinkEntity> _boxContentLink;
  late final Box<ContentMediaEntity> _boxContentMedia;

  ContentRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    _boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();
  }

  @override
  Future<void> upsert(Content content) async {
    if (content is ContentText) {
      _boxContentText.put(ContentTextEntity.fromModel(content));
      return;
    }
    if (content is ContentLink) {
      _boxContentLink.put(ContentLinkEntity.fromModel(content));
      return;
    }
    if (content is ContentMedia) {
      _boxContentMedia.put(ContentMediaEntity.fromModel(content));
      return;
    }

    throw FormatException('Content type not recognized: should be either a ContentText, a ContentLink or a ContentMedia.', content);
  }

  @override
  Future<bool> exists(String id) async {
    final res = await Future.wait([
      _boxContentText.query(ContentTextEntity_.id.equals(id)).build().findFirstAsync(),
      _boxContentLink.query(ContentLinkEntity_.id.equals(id)).build().findFirstAsync(),
      _boxContentMedia.query(ContentMediaEntity_.id.equals(id)).build().findFirstAsync(),
    ]);

    for (final content in res) {
      if (content != null) {
        return true;
      }
    }

    return false;
  }

  @override
  Future<Content?> findUnique(String id) async {
    final res = await Future.wait([
      _boxContentText.query(ContentTextEntity_.id.equals(id)).build().findFirstAsync(),
      _boxContentLink.query(ContentLinkEntity_.id.equals(id)).build().findFirstAsync(),
      _boxContentMedia.query(ContentMediaEntity_.id.equals(id)).build().findFirstAsync(),
    ]);

    for (final content in res) {
      if (content != null) {
        continue;
      }
      if (content is ContentTextEntity) {
        return content.toModel();
      }
      if (content is ContentLinkEntity) {
        return content.toModel();
      }
      if (content is ContentMediaEntity) {
        return content.toModel();
      }
    }
    return null;
  }

  @override
  Future<List<Content>> findMany(
    int chunk,
    int chunkSize, {
    int? createdWhile,
    int? createdAfter,
    List<String>? flows,
    List<StorageMode>? storageModes,
    List<ShippingMode>? shippingModes,
  }) async {
    final List<Content> contents = [];

    var contentTextCondition = ContentTextEntity_.id.notEquals('');
    var contentLinkCondition = ContentLinkEntity_.id.notEquals('');
    var contentMediaCondition = ContentMediaEntity_.id.notEquals('');

    if (createdWhile != null) {
      final comparator = DateTime.now().millisecondsSinceEpoch - createdWhile;
      contentTextCondition = contentTextCondition.and(ContentTextEntity_.createdAt.greaterOrEqual(comparator));
      contentLinkCondition = contentLinkCondition.and(ContentLinkEntity_.createdAt.greaterOrEqual(comparator));
      contentMediaCondition = contentMediaCondition.and(ContentMediaEntity_.createdAt.greaterOrEqual(comparator));
    }

    if (createdAfter != null) {
      final comparator = DateTime.now().millisecondsSinceEpoch - createdAfter;
      contentTextCondition = contentTextCondition.and(ContentTextEntity_.createdAt.lessOrEqual(comparator));
      contentLinkCondition = contentLinkCondition.and(ContentLinkEntity_.createdAt.lessOrEqual(comparator));
      contentMediaCondition = contentMediaCondition.and(ContentMediaEntity_.createdAt.lessOrEqual(comparator));
    }

    if (flows != null) {
      contentTextCondition = contentTextCondition.and(ContentTextEntity_.flowName.oneOf(flows));
      contentLinkCondition = contentLinkCondition.and(ContentLinkEntity_.flowName.oneOf(flows));
      contentMediaCondition = contentMediaCondition.and(ContentMediaEntity_.flowName.oneOf(flows));
    }

    if (storageModes != null) {
      final comparator = storageModes.map((elem) => elem.value).toList();
      contentTextCondition = contentTextCondition.and(ContentTextEntity_.storageMode.oneOf(comparator));
      contentLinkCondition = contentLinkCondition.and(ContentLinkEntity_.storageMode.oneOf(comparator));
      contentMediaCondition = contentMediaCondition.and(ContentMediaEntity_.storageMode.oneOf(comparator));
    }

    if (shippingModes != null) {
      final comparator = shippingModes.map((elem) => elem.value).toList();
      contentTextCondition = contentTextCondition.and(ContentTextEntity_.shippingMode.oneOf(comparator));
      contentLinkCondition = contentLinkCondition.and(ContentLinkEntity_.shippingMode.oneOf(comparator));
      contentMediaCondition = contentMediaCondition.and(ContentMediaEntity_.shippingMode.oneOf(comparator));
    }

    final List<List<Object>> bigFetch = await Future.wait([
      (_boxContentText.query(contentTextCondition).build()
            ..offset = chunk
            ..limit = chunkSize)
          .findAsync(),
      (_boxContentLink.query(contentLinkCondition).build()
            ..offset = chunk
            ..limit = chunkSize)
          .findAsync(),
      (_boxContentMedia.query(contentMediaCondition).build()
            ..offset = chunk
            ..limit = chunkSize)
          .findAsync(),
    ]);

    for (final element in bigFetch[0] as List<ContentTextEntity>) {
      contents.add(element.toModel());
    }

    for (final element in bigFetch[1] as List<ContentLinkEntity>) {
      contents.add(element.toModel());
    }

    for (final element in bigFetch[2] as List<ContentMediaEntity>) {
      contents.add(element.toModel());
    }

    return contents;
  }

  @override
  Future<int> deleteMany(List<String> ids) async {
    final res = await Future.wait([
      _boxContentText.query(ContentTextEntity_.id.oneOf(ids)).build().findAsync(),
      _boxContentLink.query(ContentLinkEntity_.id.oneOf(ids)).build().findAsync(),
      _boxContentMedia.query(ContentMediaEntity_.id.oneOf(ids)).build().findAsync(),
    ]);

    final resCount = await Future.wait([
      _boxContentText.removeManyAsync((res[0] as List<ContentTextEntity>).map((elem) => elem.obId).toList()),
      _boxContentLink.removeManyAsync((res[0] as List<ContentLinkEntity>).map((elem) => elem.obId).toList()),
      _boxContentMedia.removeManyAsync((res[0] as List<ContentMediaEntity>).map((elem) => elem.obId).toList()),
    ]);

    return resCount[0] + resCount[1] + resCount[2];
  }
}
