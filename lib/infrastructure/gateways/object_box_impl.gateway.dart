import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/path_provider_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

final objectBoxGatewayProvider = Provider<DatabaseGateway<Store>>((ref) {
  final pathGateway = ref.read(pathProviderGatewayProvider);
  return ObjectBoxGateway(pathGateway);
});

class ObjectBoxGateway implements DatabaseGateway<Store> {
  late final PathGateway _pathGateway;

  ObjectBoxGateway(this._pathGateway);

  @override
  Future connect() async {
    if (_SingletonStore().store != null) {
      SpLog().w('ObjectBoxGateway.connect: Instance de Store déjà existant.');
      return;
    }
    SpLog().i("ObjectBoxGateway.connect: Tentative d'accès au Store…");
    await _SingletonStore().init(await _pathGateway.getBaseDir());
    SpLog().i('ObjectBoxGateway.connect: Store instancié.');
  }

  @override
  Future disconnect() async {
    _SingletonStore().close();
    SpLog().i('ObjectBoxGateway.connect: Store détruit.');
  }

  @override
  Store? getConnector() {
    if (_SingletonStore().store == null) {
      SpLog().w("ObjectBoxGateway.getConnector: Tentative d'accès au Store alors qu'il n'est pas initialisé.");
      return null;
    }
    return _SingletonStore().store!;
  }

  @override
  Future<int> getCurrentSize() async {
    final objectBoxDir = Directory(p.join(await _pathGateway.getBaseDir(), 'object_box_database'));
    if (!await objectBoxDir.exists()) {
      return 0;
    }
    int totalBytes = 0;
    await for (final entity in objectBoxDir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        totalBytes += await entity.length();
      }
    }
    return totalBytes;
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

  Future<void> init(String path) async {
    if (_store != null) return;
    _store = await openStore(directory: p.join(path, 'object_box_database'));
  }

  void close() {
    store?.close();
    _store = null;
  }
}
