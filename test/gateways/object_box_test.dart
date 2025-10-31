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
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
  });

  test('Le connector disponible suite à une connexion.', () async {
    await objectboxGateway.connect();
    expect(objectboxGateway.getConnector(), isNotNull);
  });

  test('Le connector indisponible suite à une deconnexion.', () async {
    await objectboxGateway.connect();
    await objectboxGateway.disconnect();
    expect(objectboxGateway.getConnector(), isNull);
  });
}

class _MockPathGateway extends Mock implements PathGateway {}
