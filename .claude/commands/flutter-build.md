---
description: Flutter のビルドエラー、FVM 経由の dart analyze の警告、依存関係の問題を段階的に修正します。flutter-build-resolver を主担当とし、必要に応じて build-error-resolver と連携します。
agents: [flutter-build-resolver, build-error-resolver]
rules: [flutter/coding-style.md, flutter/hooks.md]
skills: [flutter-patterns, flutter-testing]
---

# Flutter Build and Fix

**flutter-build-resolver** を主担当として最小限の変更でビルドエラーを段階的に修正し、共通的なビルド問題は **build-error-resolver** と連携して切り分けます。

## 機能

1. **診断の実行**: `fvm dart analyze`、`fvm flutter build`、依存関係チェックを実行
2. **エラーの解析**: ファイル別にグループ化し、重要度順にソート
3. **段階的修正**: 一度に1つのエラーを修正
4. **各修正の検証**: 各変更後にチェックを再実行
5. **サマリーの報告**: 修正されたものと残っているものを表示

## 使用するタイミング

- `fvm flutter build` が失敗する場合
- `fvm dart analyze` がエラーを報告する場合
- `fvm flutter pub get` で依存関係解決に失敗する場合
- コード生成 (`build_runner`) が失敗する場合
- Dart バージョンアップ後の互換性問題

## 実行される診断コマンド

```bash
# 静的解析
fvm dart analyze

# ビルドチェック
fvm flutter build apk --debug --dry-run 2>&1 || fvm flutter build web

# 依存関係
fvm flutter pub get
fvm flutter pub outdated

# コード生成
fvm dart run build_runner build --delete-conflicting-outputs

# フォーマット
fvm dart format --set-exit-if-changed .
```

## セッション例

```text
User: /flutter-build

Agent:
# Flutter ビルド解決

## 初期診断

$ fvm dart analyze
  info - lib/models/user.dart:12:3 - Unused import - unnecessary_import
  error - lib/features/auth/login_screen.dart:45:15 - The argument type 'String' can't be assigned to the parameter type 'int'
  error - lib/providers/user_provider.dart:8:1 - Missing concrete implementation of 'UserRepository.delete'

## エラー 1/2: 型不一致
File: lib/features/auth/login_screen.dart:45

修正: int.parse() で文字列を変換
```

## 他のコマンドとの統合

- `/flutter-test` でテスト駆動開発を適用してから実装
- ビルド修正後に `/flutter-review` でコードレビュー
- `/code-review` で全体的な品質チェック
- `/test-coverage` でカバレッジを検証

## 関連エージェント

このコマンドは以下の場所にある `flutter-build-resolver` エージェントを呼び出します:
`~/.claude/agents/flutter-build-resolver.md`

また、以下のスキルを参照できます:

- `~/.claude/skills/flutter-patterns/` - Flutter / Dart 3 パターン
- `~/.claude/skills/flutter-testing/` - テスト戦略
