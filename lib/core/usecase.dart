import 'package:poc_street_path/core/result.dart';

abstract class Usecase<P, D> {
  Future<Result<D>> execute(P? params);
}
