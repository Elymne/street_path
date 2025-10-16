import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
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
  Future<List<Content>> findMany({int? createdWhile, List<String>? flows}) async {
    final List<Content> contents = [];

    // * Préparation des queries en fonction des paramètres.
    final List<Condition<ContentTextEntity>> contentTextQueries = [];
    final List<Condition<ContentLinkEntity>> contentLinkQueries = [];
    final List<Condition<ContentMediaEntity>> contentMediaQueries = [];

    // * Date queries.
    if (createdWhile != null) {
      contentTextQueries.add(ContentTextEntity_.createdAt.greaterOrEqual(createdWhile));
      contentLinkQueries.add(ContentLinkEntity_.createdAt.greaterOrEqual(createdWhile));
      contentMediaQueries.add(ContentMediaEntity_.createdAt.greaterOrEqual(createdWhile));
    }

    // * Flows name queries.
    if (flows != null) {
      contentTextQueries.add(ContentTextEntity_.flowName.oneOf(flows));
      contentLinkQueries.add(ContentLinkEntity_.flowName.oneOf(flows));
      contentMediaQueries.add(ContentMediaEntity_.flowName.oneOf(flows));
    }

    // * final merde = _boxContentText.query()

    return [];
  }
}
