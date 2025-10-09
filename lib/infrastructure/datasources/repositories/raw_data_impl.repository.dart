import 'dart:convert';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/content.entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/raw_data.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';

class RawDataRepositoryImpl implements RawDataRepository {
  final ObjectBoxGateway _objectBoxGateway;

  RawDataRepositoryImpl(this._objectBoxGateway);

  @override
  Future<String> add(String data) async {
    final box = _objectBoxGateway.getConnector()!.box<RawDataEntity>();
    final id = Uuid().v4();
    box.put(RawDataEntity(id: id, createdAt: DateTime.now().millisecondsSinceEpoch, data: data), mode: PutMode.insert);
    return id;
  }

  @override
  Future<bool> delete(String id) async {
    final box = _objectBoxGateway.getConnector()!.box<RawDataEntity>();
    final rawDataEntity = box.query(RawDataEntity_.id.equals(id)).build().findUnique();
    if (rawDataEntity == null) {
      return false;
    }
    return box.remove(rawDataEntity.obId);
  }

  @override
  Future<int> syncPosts() async {
    final boxRawData = _objectBoxGateway.getConnector()!.box<RawDataEntity>();
    final boxPost = _objectBoxGateway.getConnector()!.box<PostEntity>();

    var added = 0;
    final rawDataList = boxRawData.getAll();
    for (final rawData in rawDataList) {
      final jsonData = jsonDecode(rawData.data);
      if (jsonData is! List) {
        continue;
      }

      for (final rawPost in jsonData) {
        if (!Content.isValidJson(rawPost)) {
          continue;
        }

        final postTrans = Content.fromJson(rawPost);
        final postFromDB = boxPost.query(PostEntity_.id.equals(postTrans.id)).build().findFirst();
        if (postFromDB != null) {
          // todo : delete raw data.
          continue; // * Data exists.
        }

        // TODO : Puis ajouter tout ça en DB.
        added++;
      }
    }

    return added;
  }
}
