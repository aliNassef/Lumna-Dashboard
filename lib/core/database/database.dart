enum FilterMode {
  exact,
  containsInsensitive,
}

abstract interface class Database {
  Future<List<Map<String, dynamic>>> get({
    required String path,
    String columns = '*',
    String? filterColumn,
    dynamic filterValue,
    bool filterNotNull = false,
    String? orderBy,
    bool ascending = true,
    FilterMode filterMode = FilterMode.exact,
    int? limit,
  });

  Future<void> add({required String path, required Map<String, dynamic> data});
  Future<Map<String, dynamic>> addAndReturn({
    required String path,
    required Map<String, dynamic> data,
  });
  Future<void> update({
    required String path,
    required String id,
    required Map<String, dynamic> data,
  });

  Future<void> upsert({
    required String path,
    required Map<String, dynamic> data,
    String? onConflict,
  });
  Future<void> updateWhere({
    required String path,
    required Map<String, dynamic> data,
    required List<Map<String, dynamic>> filters,
  });
  Future<void> delete({required String path, required String id});
  Future<void> deleteWhere({
    required String path,
    required List<Map<String, dynamic>> filters,
  });

  Future<T> rpc<T>({
    required String function,
    Map<String, dynamic> params = const {},
  });

 
  Stream<List<Map<String, dynamic>>> stream({
    required String path,
    List<String> primaryKey = const ['id'],
    String columns = '*',
    String? filterColumn,
    dynamic filterValue,
    String? orderBy,
    bool ascending = false,
  });
}
