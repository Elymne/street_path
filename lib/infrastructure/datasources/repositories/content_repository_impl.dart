import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
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

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final objectBox = ref.read(objectBoxGatewayProvider);
  return ContentRepositoryImpl(objectBox);
});

class ContentRepositoryImpl implements ContentRepository {
  late final Box<ContentTextEntity> _boxContentText;
  late final Box<ContentLinkEntity> _boxContentLink;
  late final Box<ContentMediaEntity> _boxContentMedia;

  ContentRepositoryImpl(DatabaseGateway objectboxGateway) {
    _boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    _boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();
  }

  @override
  Future<void> insert(Content content) async {
    if (content is ContentText) {
      _boxContentText.put(ContentTextEntity.fromModel(content), mode: PutMode.insert);
      return;
    }
    if (content is ContentLink) {
      _boxContentLink.put(ContentLinkEntity.fromModel(content), mode: PutMode.insert);
      return;
    }
    if (content is ContentMedia) {
      _boxContentMedia.put(ContentMediaEntity.fromModel(content), mode: PutMode.insert);
      return;
    }

    throw FormatException(
      'Content type not recognized: should be either a ContentText, a ContentLink or a ContentMedia.',
      content,
    );
  }

  @override
  Future<void> update(Content content) async {
    if (content is ContentText) {
      final contentEntity = _boxContentText.query(ContentTextEntity_.id.equals(content.id)).build().findFirst();
      _boxContentText.put(ContentTextEntity.fromModel(content)..obId = contentEntity!.obId, mode: PutMode.update);
      return;
    }
    if (content is ContentLink) {
      final contentEntity = _boxContentLink.query(ContentLinkEntity_.id.equals(content.id)).build().findFirst();
      _boxContentLink.put(ContentLinkEntity.fromModel(content)..obId = contentEntity!.obId, mode: PutMode.update);
      return;
    }
    if (content is ContentMedia) {
      final contentEntity = _boxContentMedia.query(ContentMediaEntity_.id.equals(content.id)).build().findFirst();
      _boxContentMedia.put(ContentMediaEntity.fromModel(content)..obId = contentEntity!.obId, mode: PutMode.update);
      return;
    }

    throw FormatException(
      'Content type not recognized: should be either a ContentText, a ContentLink or a ContentMedia.',
      content,
    );
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
    int chunkIndex,
    int chunkSize, {
    int? createdWhile,
    int? createdAfter,
    List<String>? flows,
    List<StorageMode>? storageModes,
    List<ShippingMode>? shippingModes,
    List<ContentOrderBy>? orderByList,
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

    var contentTextQueryBuilder = _boxContentText.query(contentTextCondition);
    var contentLinkQueryBuilder = _boxContentLink.query(contentLinkCondition);
    var contentMediaQueryBuilder = _boxContentMedia.query(contentMediaCondition);

    contentTextQueryBuilder = contentTextQueryBuilder.order(ContentTextEntity_.createdAt);
    contentLinkQueryBuilder = contentLinkQueryBuilder.order(ContentLinkEntity_.createdAt);
    contentMediaQueryBuilder = contentMediaQueryBuilder.order(ContentMediaEntity_.createdAt);

    // * Fetch order by some values.
    if (orderByList != null) {
      for (final orderBy in orderByList) {
        if (orderBy == ContentOrderBy.oldest) {
          contentTextQueryBuilder = contentTextQueryBuilder.order(
            ContentTextEntity_.createdAt,
            flags: Order.descending,
          );
          contentLinkQueryBuilder = contentLinkQueryBuilder.order(
            ContentLinkEntity_.createdAt,
            flags: Order.descending,
          );
          contentMediaQueryBuilder = contentMediaQueryBuilder.order(
            ContentMediaEntity_.createdAt,
            flags: Order.descending,
          );
        }
      }
    }

    final contentTextQuery = contentTextQueryBuilder.build();
    contentTextQuery.offset = chunkIndex * chunkSize;
    contentTextQuery.limit = chunkSize;

    final contentLinkQuery = contentLinkQueryBuilder.build();
    contentLinkQuery.offset = chunkIndex * chunkSize;
    contentLinkQuery.limit = chunkSize;

    final contentMediaQuery = contentMediaQueryBuilder.build();
    contentMediaQuery.offset = chunkIndex * chunkSize;
    contentMediaQuery.limit = chunkSize;

    final List<List<Object>> bigFetch = await Future.wait([
      contentTextQuery.findAsync(),
      contentLinkQuery.findAsync(),
      contentMediaQuery.findAsync(),
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

    contents.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // * Reorder the last part after merging all.
    if (orderByList != null) {
      for (final orderBy in orderByList) {
        if (orderBy == ContentOrderBy.oldest) {
          contents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      }
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
