import 'package:poc_street_path/domain/gateways/path.gateway.dart';

import 'package:path_provider/path_provider.dart';

class PathProviderGatewayImpl implements PathGateway {
  @override
  Future<String> getBaseDir() async {
    final dir = await getApplicationCacheDirectory();
    return dir.path;
  }
}
