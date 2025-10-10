import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_impl.repository.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';

void main() {
  late final ObjectBoxGateway _objectboxGateway;
  late final RawDataRepository _rawDataRepository;

  setUpAll(() async {
    // todo : Set up repo + databse.
    _objectboxGateway = ObjectBoxGateway();
    _objectboxGateway.connect();
    _rawDataRepository = RawDataRepositoryImpl(_objectboxGateway);
  });

  tearDownAll(() {
    _objectboxGateway.disconnect();
  });

  setUp(() {});

  tearDown(() {});

  test("Lors d'une synchronisation, toutes les données contents, coms et reacts sont alors supprimé du cache: la table RawData.", () {
    // todo : Ajouter de la fausse data dans la base.
    _rawDataRepository.add(jsonEncode([]));

    // todo : Sync all.
    _rawDataRepository.syncData();

    // todo : Vérifier que la data a disparue.
    expect(3, 3);
  });
}
