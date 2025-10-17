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

    // * Préparation des queries en fonction des paramètres.
    final Condition<ContentTextEntity> contentTextQuery = ContentTextEntity_.id.notEquals("");
    final Condition<ContentLinkEntity> contentLinkQuery = ContentLinkEntity_.id.notEquals("");
    final Condition<ContentMediaEntity> contentMediaQuery = ContentMediaEntity_.id.notEquals("");

    // * Date queries.
    if (createdWhile != null) {
      contentTextQuery.and(ContentTextEntity_.createdAt.greaterOrEqual(createdWhile));
      contentLinkQuery.and(ContentLinkEntity_.createdAt.greaterOrEqual(createdWhile));
      contentMediaQuery.and(ContentMediaEntity_.createdAt.greaterOrEqual(createdWhile));
    }

    // * Flows name queries.
    if (flows != null) {
      contentTextQuery.and(ContentTextEntity_.flowName.oneOf(flows));
      contentLinkQuery.and(ContentLinkEntity_.flowName.oneOf(flows));
      contentMediaQuery.and(ContentMediaEntity_.flowName.oneOf(flows));
    }

    // * Big fetching
    final List<List<Object>> bigFetch = await Future.wait([
      (_boxContentText.query(contentTextQuery).build()..limit = limit ?? globalLimit).findAsync(),
      (_boxContentLink.query(contentLinkQuery).build()..limit = limit ?? globalLimit).findAsync(),
      (_boxContentMedia.query(contentMediaQuery).build()..limit = limit ?? globalLimit).findAsync(),
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
