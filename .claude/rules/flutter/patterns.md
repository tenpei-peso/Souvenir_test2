---
paths:
  - "**/*.dart"
---

# Flutter パターン（汎用）

> [common/patterns.md](../common/patterns.md) を拡張。
> プロジェクト固有のアーキテクチャ、実装パターン、命名規則は **PROJECT.md** を参照してください。

## PROJECT.md 参照ルール

Flutter コードを書く際は、必ず **PROJECT.md** の以下セクションを確認してください:

- アーキテクチャ（レイヤー構成、依存方向）
- 実装パターン（Entity、Repository、Usecase、状態管理、Widget 等）
- 命名規則
- テスト戦略

**PROJECT.md に記載されたパターンが、このファイルの汎用ガイドラインより優先されます。**

---

## Dart 3 パターン（言語レベル）

### sealed class + switch 式

型の列挙が必要な場合に sealed class を使用。switch 式で網羅的パターンマッチング。

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

`Future.wait` 等の複数値返却に使用。

```dart
final [user as User?, items as List<Item>] =
    await Future.wait<Object?>([userFuture, itemsFuture]);
```

### abstract interface class

インターフェース定義には Dart 3 の `abstract interface class` を使用。

---

## Widget 汎用ベストプラクティス

- Widget は可能な限り `const` で構築
- メソッドではなくクラスで分割（`Widget _buildX()` は禁止）
- 1つの `build` は 50 行以内を目安
- 過度なネスト（5 レベル以上）を避ける

## パフォーマンス汎用パターン

- `ListView.builder` で遅延ビルド
- `RepaintBoundary` で頻繁更新 Widget を分離
- `CachedNetworkImage` で画像キャッシュ
- `const` コンストラクタの積極的使用

## Extension パターン

- `DateTime` 等の表示フォーマットは Extension で定義
- Domain の Enum 自体には UI 情報を持たせない（Presentation 層の Extension で定義）
