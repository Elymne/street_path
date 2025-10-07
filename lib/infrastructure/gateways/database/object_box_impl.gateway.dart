import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

/// Implémentation du [DatabaseGateway] en utilisant la librairie objectbox.
/// TODO : Y a un truc qui va pas là. Il me faut une nouvelle classe singleton pour gérer le store sinon on va juste recréer des instances dans le vents. Débile mec qui a écrit ça (c'est moi hein).
class ObjectBoxGateway implements DatabaseGateway<Store> {
  Store? _store;

  @override
  Future connect() async {
    if (_store != null) {
      SpLog.instance.w("ObjectBoxGateway.connect: Instance de Store déjà existant.");
      return;
    }

    SpLog.instance.i("ObjectBoxGateway.connect: Tentative d'accès au Store…");
    final dir = await getApplicationCacheDirectory();
    _store = await openStore(directory: p.join(dir.path, "object_box_database"));
    SpLog.instance.i("ObjectBoxGateway.connect: Store instancié.");
  }

  @override
  Future disconnect() async {
    if (_store == null) {
      SpLog.instance.w("ObjectBoxGateway.disconnect: Il n'y a aucun Store d'instancié.");
      return;
    }
    _store = null;
  }

  @override
  Store? getConnector() {
    if (_store == null) {
      SpLog.instance.w("ObjectBoxGateway.getConnector: Il n'y a aucun Store d'instancié.");
      return null;
    }
    return _store!;
  }
}
