import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:path_provider/path_provider.dart';

final pathProviderGatewayProvider = Provider<PathGateway>((ref) => PathProviderGatewayImpl());

class PathProviderGatewayImpl implements PathGateway {
  @override
  Future<String> getBaseDir() async {
    final dir = await getApplicationCacheDirectory();
    return dir.path;
  }
}
