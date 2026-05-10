import 'package:supabase_flutter/supabase_flutter.dart';

import '../exceptions/server_exception.dart';
import 'database.dart';

class SupabaseDpImpl implements Database {
  final SupabaseClient _client;

  SupabaseDpImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<List<Map<String, dynamic>>> get({
    required String path,
    String columns = '*',
    String? filterColumn,
    dynamic filterValue,
    String? orderBy,
    bool ascending = true,
    bool filterNotNull = false,
    int? limit,
    FilterMode filterMode = FilterMode.exact,
  }) async {
    try {
      PostgrestFilterBuilder<PostgrestList> filterQuery = _client
          .from(path)
          .select(columns);

      if (filterColumn != null && filterNotNull) {
        filterQuery = filterQuery.not(filterColumn, 'is', null);
      } else if (filterColumn != null && filterValue != null) {
        switch (filterMode) {
          case FilterMode.exact:
            filterQuery = filterQuery.eq(filterColumn, filterValue);
          case FilterMode.containsInsensitive:
            filterQuery = filterQuery.ilike(
              filterColumn,
              '%$filterValue%',
            );
        }
      }
      PostgrestTransformBuilder<PostgrestList>? transformQuery;
      if (orderBy != null) {
        transformQuery = filterQuery.order(orderBy, ascending: ascending);
      }
      if (limit != null) {
        transformQuery = transformQuery?.limit(limit);
      }

      final data = await (transformQuery ?? filterQuery);
      return List<Map<String, dynamic>>.from(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> update({
    required String path,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _client.from(path).update(data).eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> delete({required String path, required String id}) async {
    try {
      await _client.from(path).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteWhere({
    required String path,
    required List<Map<String, dynamic>> filters,
  }) async {
    try {
      var query = _client.from(path).delete();

      for (final filter in filters) {
        query = query.eq(filter['column'] as String, filter['value']);
      }

      await query;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> add({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _client.from(path).insert(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> addAndReturn({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client.from(path).insert(data).select().single();
      return Map<String, dynamic>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> upsert({
    required String path,
    required Map<String, dynamic> data,
    String? onConflict,
  }) async {
    try {
      await _client
          .from(path)
          .upsert(
            data,
            onConflict: onConflict,
          );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateWhere({
    required String path,
    required Map<String, dynamic> data,
    required List<Map<String, dynamic>> filters,
  }) async {
    try {
      var query = _client.from(path).update(data);

      for (var filter in filters) {
        query = query.eq(filter['column'] as String, filter['value']);
      }

      await query;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<T> rpc<T>({
    required String function,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final response = await _client.rpc(function, params: params);
      return response as T;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}

//! old get method
//   var query = _client.from(path).select(columns);
//   if (filterColumn != null && filterNotNull) {
//     query.not(filterColumn, 'is', null);
//   } else if (filterColumn != null && filterValue != null) {
//     query.eq(filterColumn, filterValue);
//   }

//   if (orderBy != null) {
//  query.order(orderBy, ascending: ascending);
//   }

//   if (limit != null) {
//     query.limit(limit);
//   }

//   final data = await query;
//   return List<Map<String, dynamic>>.from(data);
