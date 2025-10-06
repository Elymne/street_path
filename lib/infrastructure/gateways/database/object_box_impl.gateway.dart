import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class ObjectBoxGateway implements DatabaseGateway<Store?> {
  Store? store;

  @override
  Future init() async {
    if (store != null) {
      if (kDebugMode) print("Attempt to create another ObjectBox store.");
      return;
    }
    if (kDebugMode) print("Starting initialisation of ObjectBox…");
    final dir = await getApplicationCacheDirectory();
    store = await openStore(directory: p.join(dir.path, "object_box_database"));
    if (kDebugMode) print("Connexion to ObjectBox.");
  }

  @override
  Future close() async {
    if (store == null) {
      if (kDebugMode) print("Attempt to closing an non existant ObjectBox store.");
      return;
    }
  }

  @override
  Future<Store?> getConnector() async {
    if (store == null) {
      if (kDebugMode) print("Attempt to access Store without init it. Creating it on the fly.");
      await init();
    }
    return store;
  }
}
