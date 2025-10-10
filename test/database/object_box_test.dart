import 'package:flutter_test/flutter_test.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // setUpAll(() async {});

  // tearDownAll(() {});

  // setUp(() {});

  // tearDown(() {});

  test("Connexion à la base de données. On doit avoir accès au connector.", () async {
    final ObjectBoxGateway objectboxGateway = ObjectBoxGateway();
    await objectboxGateway.connect();
    expect(objectboxGateway.getConnector(), isNotNull);
  });

  test("Connexion puis déconnexion à la base de donnée. On ne doit plus avoir au connector.", () async {
    final ObjectBoxGateway objectboxGateway = ObjectBoxGateway();
    await objectboxGateway.connect();
    await objectboxGateway.disconnect();
    expect(objectboxGateway.getConnector(), isNull);
  });
}
