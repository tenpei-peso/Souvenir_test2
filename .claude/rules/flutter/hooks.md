---
paths:
  - "**/*.dart"
---

# Flutter Hooks

> [common/hooks.md](../common/hooks.md) を拡張。

## PostToolUse Hooks

`~/.claude/settings.json` で設定:

- **fvm dart format**: `.dart` ファイル編集後に自動フォーマット
- **fvm dart analyze**: `.dart` ファイル編集後に静的解析実行
- **print 警告**: 編集ファイル内の `print()` を警告

## Stop Hooks

- **fvm dart analyze 監査**: セッション終了時に変更ファイルの解析チェック
- **未使用インポート**: 変更ファイルの未使用インポートを検出
