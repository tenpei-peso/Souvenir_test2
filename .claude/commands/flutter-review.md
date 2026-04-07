---
description: Flutter/Dart コードの包括的レビュー。Widget 設計、状態管理、パフォーマンス、Dart 3 パターンをチェックします。flutter-reviewer を主担当とし、必要に応じて code-reviewer と連携します。
agents: [flutter-reviewer, code-reviewer]
rules: [flutter/coding-style.md, flutter/patterns.md, flutter/security.md]
skills: [flutter-patterns, flutter-testing, security-review]
---

# Flutter Code Review

**flutter-reviewer** を主担当として Flutter 固有のコードレビューを実施し、必要に応じて **code-reviewer** の共通品質観点も併用します。

## 機能

1. **Flutter 変更の特定**: `git diff` で変更された `.dart` ファイルを検出
2. **静的解析の実行**: `fvm dart analyze`、`fvm dart format` を実行
3. **Widget 設計チェック**: 適切な分割、const 使用、リビルド最適化を確認
4. **状態管理レビュー**: Riverpod パターンの適切な使用を検証
5. **セキュリティスキャン**: ハードコードされたシークレット、安全でない通信をチェック
6. **レポート生成**: 問題を重要度別に分類

## 使用するタイミング

- Flutter/Dart コードを作成・変更した後
- コミット前のレビュー
- PR レビュー時
- パフォーマンス改善時

## レビューカテゴリ

### CRITICAL (必須修正)

- ハードコードされた API キー/シークレット
- 安全でない HTTP 通信
- ユーザー入力の未検証
- メモリリーク (dispose 忘れ)

### HIGH (修正推奨)

- `const` コンストラクタの未使用
- `build()` 内での重い処理
- `setState()` の過度な使用（Riverpod 推奨）
- `!` 演算子の乱用
- Stream/Controller の dispose 忘れ
- Widget ツリーの過度なネスト

### MEDIUM (検討)

- ヘルパーメソッドでの Widget 返却（別 Widget に分離推奨）
- マジックナンバー
- 過度に大きいファイル (>400行)
- 非効率な `ListView`（`ListView.builder` 推奨）
- 未使用インポート

## 実行される自動チェック

```bash
# 静的解析
fvm dart analyze

# フォーマット
fvm dart format --set-exit-if-changed .

# 未使用コード検出
fvm dart fix --dry-run
```

## 他のコマンドとの統合

- まず `/flutter-test` でテスト駆動開発を適用
- `/flutter-build` でビルドエラーを事前に修正
- レビュー後に `/test-coverage` でカバレッジを検証
- `/refactor-clean` で未使用コードをクリーンアップ

## 関連エージェント

このコマンドは以下の場所にある `flutter-reviewer` エージェントを呼び出します:
`~/.claude/agents/flutter-reviewer.md`

また、以下のスキルを参照できます:

- `~/.claude/skills/flutter-patterns/` - Flutter / Dart 3 パターン
- `~/.claude/skills/flutter-testing/` - テスト戦略
- `~/.claude/skills/security-review/` - セキュリティレビュー
