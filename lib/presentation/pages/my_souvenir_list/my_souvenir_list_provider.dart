import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test2/domain/repositories/my_souvenir_repository.dart';
import 'package:test2/infrastructure/repositories/my_souvenir_repository_impl.dart';
import 'package:test2/infrastructure/providers/firebase_firestore_provider.dart';
import 'my_souvenir_list_state.dart';

/// 一覧ページ Provider
final mySouvenirListProvider =
    StateNotifierProvider.autoDispose<
      MySouvenirListNotifier,
      MySouvenirListState
    >((ref) {
      final firestore = ref.watch(firebaseFirestoreProvider);
      final repository = MySouvenirRepositoryImpl(firestore);
      return MySouvenirListNotifier(repository: repository, userId: 'user123');
    });

/// 一覧ページ状態管理
class MySouvenirListNotifier extends StateNotifier<MySouvenirListState> {
  MySouvenirListNotifier({
    required MySouvenirRepository repository,
    required String userId,
  }) : _repository = repository,
       _userId = userId,
       super(const MySouvenirListState(souvenirs: [])) {
    _loadSouvenirs();
  }

  final MySouvenirRepository _repository;
  final String _userId;

  /// 一覧読み込み
  Future<void> _loadSouvenirs() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final souvenirs = await _repository.fetchAll(_userId);
      state = state.copyWith(souvenirs: souvenirs, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// リロード
  Future<void> reload() async {
    await _loadSouvenirs();
  }

  /// お土産削除
  Future<void> deleteSouvenir(String souvenirId) async {
    try {
      // 楽観的更新：UI即反映
      final updated = state.souvenirs.where((s) => s.id != souvenirId).toList();
      state = state.copyWith(souvenirs: updated);

      // 非同期削除
      await _repository.delete(_userId, souvenirId);
    } catch (e) {
      // エラー時はリロード
      await reload();
      rethrow;
    }
  }
}
