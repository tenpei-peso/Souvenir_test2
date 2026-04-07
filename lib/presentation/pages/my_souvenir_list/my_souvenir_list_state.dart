import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test2/domain/entities/my_souvenir.dart';

part 'my_souvenir_list_state.freezed.dart';

/// 一覧ページ状態
@freezed
class MySouvenirListState with _$MySouvenirListState {
  const factory MySouvenirListState({
    required List<MySouvenir> souvenirs,
    @Default(false) bool isLoading,
    String? error,
  }) = _MySouvenirListState;

  const MySouvenirListState._();
}
