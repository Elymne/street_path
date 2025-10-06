import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class ObjectBoxGateway implements DatabaseGateway<Store?> {
  Store? _store;

  @override
  Future init() async {
    if (_store != null) {
      SpLog.instance.w("Attempt to create another ObjectBox store.");
      return;
    }
    SpLog.instance.i("Starting initialisation of ObjectBox store…");
    final dir = await getApplicationCacheDirectory();
    _store = await openStore(directory: p.join(dir.path, "object_box_database"));
    SpLog.instance.i("Connection to ObjectBox store.");
  }

  @override
  Future close() async {
    if (_store == null) {
      SpLog.instance.w("Attempt to closing an non existant ObjectBox store.");
      return;
    }
  }

  @override
  Store? getConnector() {
    if (_store == null) {
      SpLog.instance.w("Attempt to access Store without init it. Creating it on the fly.");
      return null;
    }
    return _store!;
  }
}
