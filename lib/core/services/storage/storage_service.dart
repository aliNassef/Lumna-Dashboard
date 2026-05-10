import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../exceptions/server_exception.dart';

abstract interface class StorageService {
  Future<String> uploadImage({
    required String bucket,
    required String folder,
    required String fileName,
    required Uint8List bytes,
    bool upsert = false,
  });
}

class SupabaseStorageService implements StorageService {
  SupabaseStorageService({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  static const _contentTypes = {
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
  };

  static const _fallbackContentType = 'image/jpeg';

  @override
  Future<String> uploadImage({
    required String bucket,
    required String folder,
    required String fileName,
    required Uint8List bytes,
    bool upsert = false,
  }) async {
    try {
      final extension = _extractExtension(fileName);
      final uniqueName =
          '${DateTime.now().microsecondsSinceEpoch}'
          '${extension.isEmpty ? '' : '.$extension'}';
      final objectPath = _buildObjectPath(folder, uniqueName);

      await _supabaseClient.storage
          .from(bucket)
          .uploadBinary(
            objectPath,
            bytes,
            fileOptions: FileOptions(
              upsert: upsert,
              contentType: _contentTypes[extension] ?? _fallbackContentType,
            ),
          );

      return _supabaseClient.storage.from(bucket).getPublicUrl(objectPath);
    } on StorageException catch (e) {
      throw ServerException('${e.message} (code: ${e.error}}');
    } catch (e) {
      throw ServerException('Unexpected storage error: $e');
    }
  }

  String _buildObjectPath(String folder, String fileName) {
    final sanitized = folder
        .replaceAll(RegExp(r'^/+|/+$'), '')
        .replaceAll(RegExp(r'/+'), '/');
    return sanitized.isEmpty ? fileName : '$sanitized/$fileName';
  }

  String _extractExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) return '';
    return fileName.substring(dotIndex + 1).toLowerCase();
  }
}
