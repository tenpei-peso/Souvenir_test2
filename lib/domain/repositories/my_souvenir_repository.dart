import '../entities/my_souvenir.dart';

/// お土産管理 Repository インターフェース
abstract interface class MySouvenirRepository {
  /// すべてのお土産を取得
  Future<List<MySouvenir>> fetchAll(String userId);

  /// IDでお土産を取得
  Future<MySouvenir?> fetchById(String userId, String souvenirId);

  /// 新規お土産を作成
  Future<MySouvenir> create(String userId, MySouvenir souvenir);

  /// お土産を更新
  Future<void> update(String userId, MySouvenir souvenir);

  /// お土産を削除
  Future<void> delete(String userId, String souvenirId);

  /// リアルタイム購読（ストリーム）
  Stream<List<MySouvenir>> watchAll(String userId);
}
