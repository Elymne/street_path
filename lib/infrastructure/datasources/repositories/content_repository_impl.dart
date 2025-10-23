import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/wrap_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class ContentRepositoryImpl implements ContentRepository {
  final int globalLimit = 100;

  late final Box<WrapEntity> _boxWrap;
  late final Box<ContentTextEntity> _boxContentText;
  late final Box<ContentLinkEntity> _boxContentLink;
  late final Box<ContentMediaEntity> _boxContentMedia;

  ContentRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxWrap = objectboxGateway.getConnector()!.box<WrapEntity>();
    _boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    _boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();
  }

  @override
  Future<List<Content>> findMany({int? minTime, int? maxTime, List<String>? flows, int? limit}) async {
    // todo : Ne gère pas le minTime + maxTime en même temps (parce que pas d'utilité pour l'instant). Je préfère retourner une exception directement juste au cas où.
    // todo : Dans tous les cas, j'implémenterais ce truc plus tard.
    if (minTime != null && maxTime != null) {
      throw Exception("MinTime and MaxTime combination not supported yet by ContentReposutory ObjectBox implementation.");
    }

    final List<Content> contents = [];

    // * Date queries.
    Condition<ContentTextEntity> contentTextQueryDate = ContentTextEntity_.id.notEquals("");
    Condition<ContentLinkEntity> contentLinkQueryDate = ContentLinkEntity_.id.notEquals("");
    Condition<ContentMediaEntity> contentMediaQueryDate = ContentMediaEntity_.id.notEquals("");
    if (minTime != null) {
      final comparator = DateTime.now().millisecondsSinceEpoch - minTime;
      contentTextQueryDate = ContentTextEntity_.createdAt.greaterOrEqual(comparator);
      contentLinkQueryDate = ContentLinkEntity_.createdAt.greaterOrEqual(comparator);
      contentMediaQueryDate = ContentMediaEntity_.createdAt.greaterOrEqual(comparator);
    }

    if (maxTime != null) {
      final comparator = DateTime.now().millisecondsSinceEpoch - maxTime;
      contentTextQueryDate = ContentTextEntity_.createdAt.lessOrEqual(comparator);
      contentLinkQueryDate = ContentLinkEntity_.createdAt.lessOrEqual(comparator);
      contentMediaQueryDate = ContentMediaEntity_.createdAt.lessOrEqual(comparator);
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
}
