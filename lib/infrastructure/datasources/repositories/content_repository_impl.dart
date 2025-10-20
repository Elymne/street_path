import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class ContentRepositoryImpl implements ContentRepository {
  final int globalLimit = 100;

  late final Box<ContentTextEntity> _boxContentText;
  late final Box<ContentLinkEntity> _boxContentLink;
  late final Box<ContentMediaEntity> _boxContentMedia;

  ContentRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    _boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();
  }

  @override
  Future<List<Content>> findMany({int? limit, int? createdWhile, List<String>? flows}) async {
    final List<Content> contents = [];

    // * Date queries.
    Condition<ContentTextEntity> contentTextQueryDate = ContentTextEntity_.id.notEquals("");
    Condition<ContentLinkEntity> contentLinkQueryDate = ContentLinkEntity_.id.notEquals("");
    Condition<ContentMediaEntity> contentMediaQueryDate = ContentMediaEntity_.id.notEquals("");
    if (createdWhile != null) {
      final comparator = DateTime.now().millisecondsSinceEpoch - createdWhile;
      contentTextQueryDate = ContentTextEntity_.createdAt.greaterOrEqual(comparator);
      contentLinkQueryDate = ContentLinkEntity_.createdAt.greaterOrEqual(comparator);
      contentMediaQueryDate = ContentMediaEntity_.createdAt.greaterOrEqual(comparator);
    }

    // * Flows name queries.
    Condition<ContentTextEntity> contentTextQueryFlows = ContentTextEntity_.id.notEquals("");
    Condition<ContentLinkEntity> contentLinkQueryFlows = ContentLinkEntity_.id.notEquals("");
    Condition<ContentMediaEntity> contentMediaQueryFlows = ContentMediaEntity_.id.notEquals("");
    if (flows != null) {
      contentTextQueryFlows = ContentTextEntity_.flowName.oneOf(flows);
      contentLinkQueryFlows = ContentLinkEntity_.flowName.oneOf(flows);
      contentMediaQueryFlows = ContentMediaEntity_.flowName.oneOf(flows);
    }

    // * Big fetching
    final List<List<Object>> bigFetch = await Future.wait([
      (_boxContentText.query(contentTextQueryDate.and(contentTextQueryFlows)).build()..limit = limit ?? globalLimit).findAsync(),
      (_boxContentLink.query(contentLinkQueryDate.and(contentLinkQueryFlows)).build()..limit = limit ?? globalLimit).findAsync(),
      (_boxContentMedia.query(contentMediaQueryDate.and(contentMediaQueryFlows)).build()..limit = limit ?? globalLimit).findAsync(),
    ]);

    // * Big parsing.
    for (final element in bigFetch[0] as List<ContentTextEntity>) {
      contents.add(element.toModel());
    }
    for (final element in bigFetch[1] as List<ContentLinkEntity>) {
      contents.add(element.toModel());
    }
    for (final element in bigFetch[2] as List<ContentMediaEntity>) {
      contents.add(element.toModel());
    }

    // * Return data
    return contents;
  }

  @override
  Future<Content?> findUnique(String id) async {
    final res = await Future.wait([
      _boxContentText.query().build().findFirstAsync(),
      _boxContentLink.query().build().findFirstAsync(),
      _boxContentMedia.query().build().findFirstAsync(),
    ]);

    if (res[0] != null) return (res[0] as ContentTextEntity).toModel();
    if (res[1] != null) return (res[0] as ContentLinkEntity).toModel();
    if (res[2] != null) return (res[0] as ContentMediaEntity).toModel();
    return null;
  }

  @override
  Future<bool> exists(String id) async {
    final res = await Future.wait([
      _boxContentText.query().build().findFirstAsync(),
      _boxContentLink.query().build().findFirstAsync(),
      _boxContentMedia.query().build().findFirstAsync(),
    ]);

    for (var content in res as List<Content?>) {
      if (content == null) continue;
      return true;
    }
    return false;
  }
}
