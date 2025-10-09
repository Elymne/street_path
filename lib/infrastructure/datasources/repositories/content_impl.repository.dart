import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/models/contents/content_text.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/content.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';
import 'package:uuid/uuid.dart';

class ContentRepositoryImpl implements ContentRepository {
  late final Box<ContentTextEntity> _boxContent;

  ContentRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxContent = objectboxGateway.getConnector()!.box<ContentTextEntity>();
  }

  @override
  Future<String> add(Content content) async {
    if (content is ContentText) {
      final id = Uuid().v4();
      _boxContent.put(
        ContentTextEntity(
          id: id,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          authorName: content.authorName,
          bounces: 0,
          flowName: content.flowName,
          title: content.title,
          text: content.text,
        ),
        mode: PutMode.insert,
      );
      return id;
    }

    throw Exception("ContentRepositoryImpl"); // TODO: exception nulle genre, TypeDebinusCarnigusAnalus.
  }

  @override
  Future<List<Content>> findShareables() {
    // TODO: implement findShareables
    throw UnimplementedError();
  }
}
