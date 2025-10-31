bool isValidJson(Map<String, dynamic> json, Map<String, Type> allowed) {
  final allowedKey = allowed.keys.toSet();
  final jsonKeys = json.keys.toSet();
  if (allowedKey.length != jsonKeys.length) {
    return false;
  }
  final extraKeys = jsonKeys.difference(allowedKey);
  if (extraKeys.isNotEmpty) {
    return false;
  }
  for (final key in allowedKey.intersection(jsonKeys)) {
    final expectedType = allowed[key];
    final value = json[key];

    if (value != null && value.runtimeType != expectedType) {
      return false;
    }
  }
  return true;
}
