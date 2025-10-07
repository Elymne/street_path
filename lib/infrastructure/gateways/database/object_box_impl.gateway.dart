import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

/// Implémentation du [DatabaseGateway] en utilisant la librairie objectbox.
class ObjectBoxGateway implements DatabaseGateway<Store> {
  @override
  Future connect() async {
    if (_SingletonStore().store != null) {
      SpLog().w("ObjectBoxGateway.connect: Instance de Store déjà existant.");
      return;
    }
    SpLog().i("ObjectBoxGateway.connect: Tentative d'accès au Store…");
    _SingletonStore().init();
    SpLog().i("ObjectBoxGateway.connect: Store instancié.");
  }

  @override
  Future disconnect() async {
    _SingletonStore().close();
    SpLog().i("ObjectBoxGateway.connect: Store détruit.");
  }

  @override
  Store? getConnector() {
    if (_SingletonStore().store == null) {
      SpLog().w("ObjectBoxGateway.getConnector: Il n'y a aucun Store d'instancié.");
      return null;
    }
    return _SingletonStore().store!;
  }

  @override
  Future<int> getCurrentSize() {
    // TODO: implement getCurrentSize
    throw UnimplementedError();
  }
}

class _SingletonStore {
  _SingletonStore._internal();
  static final _SingletonStore _instance = _SingletonStore._internal();
  factory _SingletonStore() {
    return _instance;
  }

  Store? _store;
  Store? get store => _store;

  Future<void> init() async {
    if (_store != null) return;
    final dir = await getApplicationCacheDirectory();
    _store = await openStore(directory: p.join(dir.path, "object_box_database"));
  }

  void close() {
    store?.close();
    _store = null;
  }
}
