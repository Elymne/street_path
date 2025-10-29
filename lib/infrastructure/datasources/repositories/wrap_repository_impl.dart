class WrapRepositoryImpl {
  // @override
  // Future<List<String>> getIdsByDateLimit(int createdAfter) async {
  //   final dateQuery = WrapEntity_.createdAt.lessOrEqual(DateTime.now().millisecondsSinceEpoch - createdAfter);
  //   final storageQuery = WrapEntity_.storageMode.equals(StorageMode.normal.value);
  //   final wrapEntities = _boxWrap.query(dateQuery.and(storageQuery)).build().find();
  //   return wrapEntities.map((elem) => elem.contentId).toList();
  // }

  // @override
  // Future<List<String>> getOldestIds(int number) async {
  //   final storageQuery = WrapEntity_.storageMode.equals(StorageMode.normal.value);
  //   final wrapEntities = (_boxWrap.query(storageQuery).order(WrapEntity_.createdAt).build()..limit = number).find();
  //   return wrapEntities.map((elem) => elem.contentId).toList();
  // }
}
