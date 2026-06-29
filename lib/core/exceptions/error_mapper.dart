import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lumna_admin/core/exceptions/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../translation/locale_keys.g.dart';

/// Maps any thrown [Object] to a user-facing, localized message.
extension ErrorToMessage on Object {
  String toMessage() => ErrorMapper.toMessage(this);
}

abstract final class ErrorMapper {
  static String toMessage(Object error) {
    return switch (error) {
      ServerException e => e.message,
      PostgrestException e => _fromPostgrest(e),
      AuthException e => _fromAuth(e),
      StorageException _ => LocaleKeys.error_generic.tr(),
      SocketException _ => LocaleKeys.error_network.tr(),
      TimeoutException _ => LocaleKeys.error_timeout.tr(),
      DioException e => _fromDio(e),
      _ => _fromUnknown(error),
    };
  }

  static String _fromDio(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => LocaleKeys.error_timeout.tr(),
      DioExceptionType.connectionError => LocaleKeys.error_network.tr(),
      DioExceptionType.unknown when e.error is SocketException =>
        LocaleKeys.error_network.tr(),
      _ => LocaleKeys.error_generic.tr(),
    };
  }

  static String _fromPostgrest(PostgrestException e) {
    return switch (e.code) {
      '23505' => LocaleKeys.error_duplicate.tr(), // unique_violation
      'PGRST116' => LocaleKeys.error_not_found.tr(), // no rows returned
      '42501' => LocaleKeys.error_permission.tr(), // insufficient_privilege
      _ => LocaleKeys.error_generic.tr(),
    };
  }

  static String _fromAuth(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return LocaleKeys.error_invalid_credentials.tr();
    }
    if (message.contains('already registered') ||
        message.contains('already exists') ||
        message.contains('user already')) {
      return LocaleKeys.error_email_in_use.tr();
    }
    if (e.statusCode == '401' || message.contains('jwt')) {
      return LocaleKeys.error_unauthorized.tr();
    }
    return LocaleKeys.error_generic.tr();
  }

  static String _fromUnknown(Object error) {
    // Network failures often surface as ClientException / host-lookup errors
    // rather than a SocketException.
    final text = error.toString().toLowerCase();
    if (text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('clientexception') ||
        text.contains('connection')) {
      return LocaleKeys.error_network.tr();
    }
    return LocaleKeys.error_generic.tr();
  }
}
