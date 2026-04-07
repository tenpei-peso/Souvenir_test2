---
description: SvelteKit/Svelte のビルドエラー、svelte-check の型エラー、ESLint 問題を段階的に修正します。svelte-build-resolver を主担当とし、必要に応じて build-error-resolver と連携します。
agents: [svelte-build-resolver, svelte-file-editor, build-error-resolver]
rules: [svelte/coding-style.md, svelte/hooks.md]
skills:
  [
    svelte-patterns,
    svelte-core-bestpractices,
    svelte-code-writer,
    svelte-testing,
  ]
---

# Svelte Build and Fix

**svelte-build-resolver** を主担当として最小限の変更でビルドエラーを段階的に修正し、共通的なビルド問題は **build-error-resolver** と連携して切り分けます。

## 機能

1. **診断の実行**: `svelte-check`、`tsc`、`eslint`、`vite build` を実行
2. **エラーの解析**: ファイル別にグループ化し、重要度順にソート
3. **段階的修正**: 一度に1つのエラーを修正
4. **各修正の検証**: 各変更後にチェックを再実行
5. **サマリーの報告**: 修正されたものと残っているものを表示

## 使用するタイミング

- `svelte-check` が型エラーを報告する場合
- `vite build` が失敗する場合
- ESLint が `.svelte` ファイルでエラーを表示する場合
- SvelteKit の `load` 関数で型不一致がある場合
- Svelte 5 Runes への移行で問題が生じた場合

## 実行される診断コマンド

```bash
# 型チェック
npx svelte-check --tsconfig ./tsconfig.json

# TypeScript コンパイル
npx tsc --noEmit

# リンティング
npx eslint . --ext .svelte,.ts,.js

# ビルド検証
npx vite build
```

## セッション例

```text
User: /svelte-build

Agent:
# Svelte ビルド解決

## 初期診断

$ npx svelte-check
src/routes/+page.svelte:15:3 - error: Type 'string' is not assignable to type 'number'
src/lib/components/Modal.svelte:8:2 - error: Property 'open' is missing in type

## エラー 1/2: 型不一致
File: src/routes/+page.svelte:15

修正: count の型を number に変更
```

## 他のコマンドとの統合

- `/svelte-test` でテスト駆動開発を適用してから実装
- ビルド修正後に `/svelte-review` でコードレビュー
- `/code-review` で全体的な品質チェック
- `/test-coverage` でカバレッジを検証

## 関連エージェント

このコマンドは以下のエージェントを呼び出します:

- `~/.claude/agents/svelte-build-resolver.md` - ビルドエラー解決
- `~/.claude/agents/svelte-file-editor.md` - MCP ツールによるコード検証

また、以下のスキルを参照できます:

- `~/.claude/skills/svelte-patterns/` - Svelte 5 / SvelteKit 実装パターン
- `~/.claude/skills/svelte-core-bestpractices/` - Svelte 5 公式ベストプラクティス
- `~/.claude/skills/svelte-code-writer/` - Svelte MCP CLI ツール
- `~/.claude/skills/svelte-testing/` - テスト戦略
