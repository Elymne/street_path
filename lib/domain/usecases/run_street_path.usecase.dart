import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';

class RunStreetPathParams {}

class RunStreetPath extends Usecase<RunStreetPathParams, int> {
  @override
  Future<Result<int>> execute(RunStreetPathParams? params) {
    // TODO: implement execute
    throw UnimplementedError();
  }
}
