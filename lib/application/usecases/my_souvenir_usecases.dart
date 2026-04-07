import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/domain/repositories/my_souvenir_repository.dart';
import 'package:test2/util/app_exception.dart';

/// お土産管理の Usecase クラス
class MySouvenirUsecases {
  MySouvenirUsecases({required MySouvenirRepository repository})
    : _repository = repository;

  final MySouvenirRepository _repository;

  /// バリデーション：お土産名
  String? validateName(String name) {
    if (name.isEmpty) {
      return 'お土産名は必須項目です';
    }
    if (name.length > 100) {
      return 'お土産名は100文字以内で入力してください';
    }
    return null;
  }

  /// バリデーション：説明
  String? validateDescription(String description) {
    if (description.isEmpty) {
      return '説明は必須項目です';
    }
    if (description.length > 500) {
      return '説明は500文字以内で入力してください';
    }
    return null;
  }

  /// バリデーション：値段
  String? validatePrice(int price) {
    if (price <= 0) {
      return '値段は1円以上で入力してください';
    }
    if (price > 999999) {
      return '値段は999,999円以下で入力してください';
    }
    return null;
  }

  /// 新規お土産を作成
  Future<MySouvenir> createSouvenir({
    required String userId,
    required MySouvenir souvenir,
  }) async {
    // バリデーション
    final nameError = validateName(souvenir.name);
    if (nameError != null) {
      throw ValidationException(message: nameError);
    }

    final descriptionError = validateDescription(souvenir.description);
    if (descriptionError != null) {
      throw ValidationException(message: descriptionError);
    }

    final priceError = validatePrice(souvenir.price);
    if (priceError != null) {
      throw ValidationException(message: priceError);
    }

    // 作成
    return await _repository.create(userId, souvenir);
  }

  /// お土産を更新
  Future<void> updateSouvenir({
    required String userId,
    required MySouvenir souvenir,
  }) async {
    // バリデーション
    final nameError = validateName(souvenir.name);
    if (nameError != null) {
      throw ValidationException(message: nameError);
    }

    final descriptionError = validateDescription(souvenir.description);
    if (descriptionError != null) {
      throw ValidationException(message: descriptionError);
    }

    final priceError = validatePrice(souvenir.price);
    if (priceError != null) {
      throw ValidationException(message: priceError);
    }

    // 更新
    await _repository.update(userId, souvenir);
  }

  /// お土産を削除
  Future<void> deleteSouvenir({
    required String userId,
    required String souvenirId,
  }) async {
    await _repository.delete(userId, souvenirId);
  }

  /// すべてのお土産を取得
  Future<List<MySouvenir>> fetchAllSouvenirs(String userId) async {
    return await _repository.fetchAll(userId);
  }

  /// IDでお土産を取得
  Future<MySouvenir?> fetchSouvenirById({
    required String userId,
    required String souvenirId,
  }) async {
    return await _repository.fetchById(userId, souvenirId);
  }

  /// リアルタイムで購読
  Stream<List<MySouvenir>> watchSouvenirs(String userId) {
    return _repository.watchAll(userId);
  }
}
