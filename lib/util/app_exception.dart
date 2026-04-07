// アプリケーション全体の共通例外基底クラス

/// ユーザー向けエラー詳細インターフェース
abstract interface class ErrorDetail {
  String get message;
  String? get code;
}

/// アプリケーション例外基底クラス
class AppException implements Exception {
  AppException({
    required this.message,
    this.detail,
    this.originalError,
    this.stackTrace,
  });

  final String message;
  final ErrorDetail? detail;
  final Object? originalError;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message';
}

/// ネットワーク関連例外
class NetworkException extends AppException {
  NetworkException({
    required String message,
    ErrorDetail? detail,
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         detail: detail,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Firestore 関連例外
class FirestoreException extends AppException {
  FirestoreException({
    required String message,
    ErrorDetail? detail,
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         detail: detail,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Firebase Storage 関連例外
class StorageException extends AppException {
  StorageException({
    required String message,
    ErrorDetail? detail,
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         detail: detail,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// バリデーション例外
class ValidationException extends AppException {
  ValidationException({
    required String message,
    ErrorDetail? detail,
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         detail: detail,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}
