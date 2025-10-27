import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/wrap.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/reaction_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/wrap_entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class WrapRepositoryImpl extends WrapRepository {
  late final Box<WrapEntity> _boxWrap;
  late final Box<ContentTextEntity> _boxContentText;
  late final Box<ContentLinkEntity> _boxContentLink;
  late final Box<ContentMediaEntity> _boxContentMedia;
  late final Box<CommentEntity> _boxComment;
  late final Box<ReactionEntity> _boxReaction;

  WrapRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxWrap = objectboxGateway.getConnector()!.box<WrapEntity>();
    _boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    _boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    _boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();
    _boxReaction = objectboxGateway.getConnector()!.box<ReactionEntity>();
    _boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  }

  @override
  Future<Wrap?> findUnique(String contentId) async {
    final List<Object?> contentsRes = await Future.wait([
      _boxContentText.query(ContentTextEntity_.id.equals(contentId)).build().findFirstAsync(),
      _boxContentLink.query(ContentLinkEntity_.id.equals(contentId)).build().findFirstAsync(),
      _boxContentMedia.query(ContentMediaEntity_.id.equals(contentId)).build().findFirstAsync(),
    ]);

    // * Find if content exists.
    Content? content;
    for (final elem in contentsRes) {
      if (elem == null) continue;
      if (elem is ContentTextEntity) content = elem.toModel();
      if (elem is ContentLinkEntity) content = elem.toModel();
      if (elem is ContentMediaEntity) content = elem.toModel();
    }
    if (content == null) {
      return null;
    }

    // * Then find the rest.
    final wrapEntity = _boxWrap.query(WrapEntity_.contentId.equals(contentId)).build().findFirst();
    if (wrapEntity == null) {
      // todo: Si il n'y a pas de Wrap, je devrais soit supprimer les données associés au wrap (message, contenu et reaction) ou alors créer le wrap.
      return null;
    }
    final reactionEntities = _boxReaction.query(ReactionEntity_.contentId.equals(contentId)).build().find();
    final commentEntities = _boxComment.query(CommentEntity_.contentId.equals(contentId)).build().find();

    return Wrap(
      id: wrapEntity.id,
      createdAt: wrapEntity.createdAt,
      content: content,
      reaction: reactionEntities.map((elem) => elem.toModel()).toList(),
      comments: commentEntities.map((elem) => elem.toModel()).toList(),
      storageMode: StorageMode.fromValue(wrapEntity.storageMode),
      shippingMode: ShippingMode.fromValue(wrapEntity.shippingMode),
    );
  }

  @override
  Future<List<Wrap>> findMany(
    int chunk,
    int chunkSize, {
    List<String>? flows,
    int? createWhile,
    StorageMode? storageMode,
    ShippingMode? shippingMode,
  }) {
    // TODO: implement findMany
    throw UnimplementedError();
  }

  @override
  Future<bool> exists(String contentId) async {
    final wrap = _boxWrap.query(WrapEntity_.contentId.equals(contentId)).build().findFirst();
    return wrap != null;
  }

  @override
  Future<bool> changeShippingMode(String contentId, ShippingMode shippingMode) async {
    final wrap = _boxWrap.query(WrapEntity_.id.equals(contentId)).build().findFirst();
    if (wrap == null) {
      return false;
    }

    _boxWrap.put(wrap..shippingMode = shippingMode.value);
    return true;
  }

  @override
  Future<bool> changeStorageMode(String contentId, StorageMode storageMode) async {
    final wrap = _boxWrap.query(WrapEntity_.id.equals(contentId)).build().findFirst();
    if (wrap == null) {
      return false;
    }

    _boxWrap.put(wrap..storageMode = storageMode.value);
    return true;
  }

  @override
  Future<int> deleteMany(List<String> contentIds) async {
    final wraps = _boxWrap.query(WrapEntity_.contentId.oneOf(contentIds)).build().find();
    _boxReaction.removeMany(wraps.map((elem) => elem.obId).toList());

    final comments = _boxComment.query(CommentEntity_.contentId.oneOf(contentIds)).build().find();
    _boxComment.removeMany(comments.map((elem) => elem.obId).toList());

    final reactions = _boxReaction.query(ReactionEntity_.contentId.oneOf(contentIds)).build().find();
    _boxReaction.removeMany(reactions.map((elem) => elem.obId).toList());

    final idsRes = await Future.wait([
      _boxContentText.query(ContentTextEntity_.id.oneOf(contentIds)).build().findAsync(),
      _boxContentLink.query(ContentLinkEntity_.id.oneOf(contentIds)).build().findAsync(),
      _boxContentMedia.query(ContentMediaEntity_.id.oneOf(contentIds)).build().findAsync(),
    ]);

    final contentTextObid = (idsRes[0] as List<ContentTextEntity>).map((elem) => elem.obId).toList();
    final contentLinkObid = (idsRes[0] as List<ContentLinkEntity>).map((elem) => elem.obId).toList();
    final contentMediaObid = (idsRes[0] as List<ContentMediaEntity>).map((elem) => elem.obId).toList();

    final deleteRes = await Future.wait([
      _boxContentText.removeManyAsync(contentTextObid),
      _boxContentLink.removeManyAsync(contentLinkObid),
      _boxContentMedia.removeManyAsync(contentMediaObid),
    ]);

    return deleteRes[0] + deleteRes[1] + deleteRes[2];
  }

  @override
  Future<List<String>> getIdsByDateLimit(int createdAfter) async {
    final dateQuery = WrapEntity_.createdAt.lessOrEqual(DateTime.now().millisecondsSinceEpoch - createdAfter);
    final storageQuery = WrapEntity_.storageMode.equals(StorageMode.normal.value);
    final wrapEntities = _boxWrap.query(dateQuery.and(storageQuery)).build().find();
    return wrapEntities.map((elem) => elem.contentId).toList();
  }

  @override
  Future<List<String>> getOldestIds(int number) async {
    final storageQuery = WrapEntity_.storageMode.equals(StorageMode.normal.value);
    final wrapEntities = (_boxWrap.query(storageQuery).order(WrapEntity_.createdAt).build()..limit = number).find();
    return wrapEntities.map((elem) => elem.contentId).toList();
  }
}
