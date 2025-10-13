import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final pathGateway = _MockPathGateway();
  late final ObjectBoxGateway objectboxGateway;

  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('object_box_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((maleficumInvocationDelaMuerteJeSaisPasAQuoiSertCeTruc) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
  });

  test("Connexion à la base de données. On doit avoir accès au connector.", () async {
    await objectboxGateway.connect();
    expect(objectboxGateway.getConnector(), isNotNull);
  });

  test("Connexion puis déconnexion à la base de donnée. On ne doit plus avoir au connector.", () async {
    await objectboxGateway.connect();
    await objectboxGateway.disconnect();
    expect(objectboxGateway.getConnector(), isNull);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
