import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/cache/raw_data.model.dart';
import 'package:poc_street_path/domain/models/content/wrap.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:uuid/uuid.dart';

class AddRawData extends Usecase<FindUniqueContentParams, Wrap?> {
  final RawDataRepository _rawDataRepository;

  AddRawData(this._rawDataRepository);

  @override
  Future<Result<Wrap?>> execute(FindUniqueContentParams params) async {
    try {
      await _rawDataRepository.add(RawData(id: Uuid().v4(), createdAt: DateTime.now().millisecondsSinceEpoch, data: params.stringyData));
      return Success(null);
    } catch (err, stack) {
      SpLog().e('AddRawData: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite lors de l'ajout d'une données brute en base de données.");
    }
  }
}

class FindUniqueContentParams {
  final String stringyData;
  FindUniqueContentParams(this.stringyData);
}
