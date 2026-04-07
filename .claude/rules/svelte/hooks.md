---
paths:
  - "**/*.svelte"
  - "**/*.svelte.ts"
  - "**/*.svelte.js"
---

# Svelte Hooks

> [common/hooks.md](../common/hooks.md) を拡張。

## PostToolUse Hooks

`~/.claude/settings.json` で設定:

- **Prettier/eslint**: `.svelte` ファイル編集後に自動フォーマット
- **svelte-check**: `.svelte` / `.svelte.ts` 編集後に型チェック実行
- **console.log 警告**: 編集ファイル内の `console.log` を警告

## Stop Hooks

- **svelte-check 監査**: セッション終了時に変更ファイルの型エラーチェック
- **未使用インポート**: 変更ファイルの未使用インポートを検出
