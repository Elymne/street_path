import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';

class ConnectToDatabaseParams {}

class ConnectToDatabase extends Usecase<ConnectToDatabaseParams, void> {
  final DatabaseGateway _databaseGateway;

  ConnectToDatabase(this._databaseGateway);

  @override
  Future<Result<void>> execute(ConnectToDatabaseParams params) async {
    try {
      await _databaseGateway.connect();
      return Success(null);
    } catch (err, stack) {
      SpLog.instance.e("ConnectToDatabase: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la connexion à la base de données.");
    }
  }
}
