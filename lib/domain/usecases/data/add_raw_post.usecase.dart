import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/post/raw_post_data.model.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';

class AddRawDataParams {
  final String data;
  AddRawDataParams({required this.data});
}

class AddRawData extends Usecase<AddRawDataParams, RawData> {
  final RawDataRepository _rawDataRepository;

  AddRawData(this._rawDataRepository);

  @override
  Future<Result<RawData>> execute(AddRawDataParams params) async {
    try {
      return Success(await _rawDataRepository.add(params.data));
    } catch (err, stack) {
      SpLog().e("AddRawData: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de l'ajout d'une donnée brute…");
    }
  }
}
