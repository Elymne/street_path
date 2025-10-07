import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';

class DisconnectToDatabaseParams {}

class DisconnectToDatabase extends Usecase<DisconnectToDatabaseParams, void> {
  final DatabaseGateway _databaseGateway;

  DisconnectToDatabase(this._databaseGateway);

  @override
  Future<Result<void>> execute(DisconnectToDatabaseParams params) async {
    try {
      await _databaseGateway.connect();
      return Success(null);
    } catch (err, stack) {
      SpLog().e("DisconnectToDatabase: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la déconnexion à la base de données.");
    }
  }
}
