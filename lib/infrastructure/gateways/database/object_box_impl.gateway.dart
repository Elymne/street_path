import 'package:poc_street_path/domain/gateways/database.gateway.dart';

class ObjectBoxGateway implements DatabaseGateway<int> {
  @override
  Future init() async {}

  @override
  Future close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<int> getConnector() {
    // TODO: implement getConnector
    throw UnimplementedError();
  }
}
