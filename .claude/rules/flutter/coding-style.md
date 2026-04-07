---
paths:
  - "**/*.dart"
---

# Flutter/Dart コーディングスタイル（汎用）

> [common/coding-style.md](../common/coding-style.md) を拡張。
> プロジェクト固有のアーキテクチャ、命名規則、実装パターンは **PROJECT.md** を参照してください。

## Dart 命名規則

- クラス/Enum/Typedef: `UpperCamelCase`
- 変数/関数/パラメータ: `lowerCamelCase`
- ファイル/ライブラリ: `snake_case`
- 定数: `lowerCamelCase`
- プライベート: `_` プレフィックス

## 不変性

- Widget は可能な限り `const` で構築
- `final` を積極的に使用
- データクラスはイミュータブルに定義する

## Widget の分割

- メソッドではなくクラスで分割（`Widget _buildX()` は禁止）
- 1つの `build` は 50 行以内を目安

## Null Safety

- `!` 演算子は最小限。`?.`、`??`、パターンマッチングを優先
- Dart 3 の `if (x case Type(:final field))` パターンを活用

## Dart 3 必須パターン

- **switch 式**: if-else チェーンの代わりに使用。Enum/sealed class は網羅的に
- **sealed class**: 状態の列挙が必要な場合に使用。パターンマッチングで網羅チェック
- **Record + 分割代入**: `Future.wait` 結果等の複数値返却に使用
- **abstract interface class**: インターフェース定義に使用（Dart 3）

## ファイル構成

- 1ファイル1クラス、200-400 行目安、最大 800 行
- `final` を積極的に使用
- Domain 層は外部依存を持たない（プロジェクトのレイヤー構成に従う）
