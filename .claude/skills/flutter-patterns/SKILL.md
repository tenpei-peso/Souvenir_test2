---
name: flutter-patterns
description: lib/ 配下の Flutter/Dart 実装を追加・変更するときに使う汎用パターン。Widget 設計、Dart 3 言語機能、パフォーマンス最適化を扱い、テスト専用作業は flutter-testing に委ねる。
paths:
  - lib/**/*.dart
---

# Flutter 開発パターン（汎用）

Flutter + Dart 3 で高品質なアプリケーションを構築するための汎用ベストプラクティス。

**プロジェクト固有のアーキテクチャ（レイヤー構成、Entity パターン、状態管理、ルーティング等）は必ず PROJECT.md を参照してください。**

## いつ有効化するか

- Flutter/Dart コードを書くとき
- パフォーマンス最適化時
- テストのみが主目的ではない UI / 状態管理 / ドメイン実装を変更するとき

## PROJECT.md 参照ルール

Flutter コードの実装時は、必ず PROJECT.md の以下セクションを確認:

1. **アーキテクチャ** - レイヤー構成、依存方向
2. **実装パターン** - Entity、Repository、Usecase、状態管理、Widget 等
3. **命名規則** - ファイル名、クラス名、ルーティング名
4. **テスト戦略** - レイヤー別テスト方針
5. **アーキテクチャルール** - プロジェクト固有の制約

---

## Dart 3 パターン（言語レベル）

### Enhanced Enum

Dart 3 の Enhanced Enum はフィールド、メソッド、インターフェース実装を持てる。
具体的な使用パターン（value + fromString + JsonConverter 等）は PROJECT.md を参照。

### Sealed Class + switch 式

```dart
sealed class AuthState {}
class Authenticated extends AuthState { final String userId; ... }
class Unauthenticated extends AuthState {}

Widget build(AuthState state) => switch (state) {
  Authenticated(:final userId) => HomePage(userId: userId),
  Unauthenticated() => const LoginPage(),
};
```

### Record + 分割代入

```dart
final [user as User?, items as List<Item>] =
    await Future.wait<Object?>([userFuture, itemsFuture]);
```

### abstract interface class

```dart
abstract interface class Repository {
  Future<Entity> getById(String id);
}
```

---

## Widget 汎用ベストプラクティス

- `const` コンストラクタの積極的使用
- メソッドではなくクラスで Widget を分割（`Widget _buildX()` は禁止）
- 1つの `build` は 50 行以内を目安
- 過度なネスト（5 レベル以上）を避ける

## パフォーマンス

- `ListView.builder` で遅延ビルド
- `RepaintBoundary` で頻繁更新 Widget 分離
- `CachedNetworkImage` で画像キャッシュ
- `const` コンストラクタの積極的使用
- 状態管理ライブラリの select 機能で局所リビルド

## エラーハンドリング（汎用）

- 基底例外クラスで構造化
- 外部エラーをドメイン例外に変換
- Presentation 層でユーザー向けメッセージに変換
