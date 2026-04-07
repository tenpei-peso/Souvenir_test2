import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:test2/util/app_exception.dart';

/// Firebase Storage 画像リポジトリ
abstract interface class ImageStorageRepository {
  /// 画像ファイルをアップロード
  Future<String> uploadImage({
    required String userId,
    required String souvenirId,
    required File imageFile,
  });

  /// 画像を削除
  Future<void> deleteImage(String imageUrl);

  /// ユーザーのお土産フォルダを削除
  Future<void> deleteSouvenirFolder({
    required String userId,
    required String souvenirId,
  });
}

/// ImageStorageRepository の Firebase Storage 実装
class ImageStorageRepositoryImpl implements ImageStorageRepository {
  ImageStorageRepositoryImpl(this._storage);

  final FirebaseStorage _storage;

  /// ストレージパス: users/{userId}/souvenirs/{souvenirId}/{timestamp}_{filename}
  String _getStoragePath({
    required String userId,
    required String souvenirId,
    required String fileName,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'users/$userId/souvenirs/$souvenirId/${timestamp}_$fileName';
  }

  @override
  Future<String> uploadImage({
    required String userId,
    required String souvenirId,
    required File imageFile,
  }) async {
    try {
      // ファイルサイズの制限（5MB）
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw StorageException(message: 'ファイルサイズが大きすぎます（最大5MB）');
      }

      final fileName = imageFile.path.split('/').last;
      final storagePath = _getStoragePath(
        userId: userId,
        souvenirId: souvenirId,
        fileName: fileName,
      );

      final ref = _storage.ref().child(storagePath);
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e, st) {
      throw StorageException(
        message: 'ファイルのアップロードに失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Storage URL から参照パスを抽出
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e, st) {
      throw StorageException(
        message: '画像の削除に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> deleteSouvenirFolder({
    required String userId,
    required String souvenirId,
  }) async {
    try {
      final path = 'users/$userId/souvenirs/$souvenirId';
      final ref = _storage.ref().child(path);

      // フォルダ内のすべてのファイルを列挙して削除
      final listResult = await ref.listAll();
      for (final fileRef in listResult.items) {
        await fileRef.delete();
      }
    } on FirebaseException catch (e, st) {
      throw StorageException(
        message: 'フォルダの削除に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}
