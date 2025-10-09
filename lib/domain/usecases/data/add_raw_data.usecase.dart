import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';

class AddRawData extends Usecase<AddRawDataParams, String> {
  final RawDataRepository _rawDataRepository;

  AddRawData(this._rawDataRepository);

  @override
  Future<Result<String>> execute(AddRawDataParams params) async {
    try {
      return Success(await _rawDataRepository.add(params.data));
    } catch (err, stack) {
      SpLog().e("AddRawData: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de l'ajout d'une donnée brute…");
    }
  }
}

class AddRawDataParams {
  final String data;
  AddRawDataParams({required this.data});
}
