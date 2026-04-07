---
description: Svelte/SvelteKit コードの包括的レビュー。Runes パターン、TypeScript 型安全、アクセシビリティ、セキュリティをチェックします。svelte-reviewer を主担当とし、必要に応じて code-reviewer と連携します。
agents: [svelte-reviewer, svelte-file-editor, code-reviewer]
rules: [svelte/coding-style.md, svelte/patterns.md, svelte/security.md]
skills:
  [
    svelte-patterns,
    svelte-core-bestpractices,
    svelte-code-writer,
    svelte-testing,
    security-review,
  ]
---

# Svelte Code Review

**svelte-reviewer** を主担当として Svelte 固有のコードレビューを実施し、必要に応じて **code-reviewer** の共通品質観点も併用します。

## 機能

1. **Svelte 変更の特定**: `git diff` で変更された `.svelte`、`.svelte.ts`、`.ts` ファイルを検出
2. **静的解析の実行**: `svelte-check`、`eslint`、`tsc` を実行
3. **Runes チェック**: Svelte 5 Runes の正しい使用を確認
4. **SvelteKit パターン**: Load 関数、フォームアクション、フックの適切な実装を検証
5. **セキュリティスキャン**: XSS、CSRF、環境変数漏洩をチェック
6. **レポート生成**: 問題を重要度別に分類

## 使用するタイミング

- Svelte/SvelteKit コードを作成・変更した後
- コミット前のレビュー
- PR レビュー時
- Svelte 5 への移行時

## レビューカテゴリ

### CRITICAL (必須修正)

- `{@html}` での未サニタイズ入力
- `$env/static/private` のクライアント側での使用
- フォームアクション外での CSRF 未対策
- ハードコードされたシークレット

### HIGH (修正推奨)

- レガシーな `$:` リアクティブ宣言（Svelte 5 移行）
- `$effect` 内のクリーンアップ関数の欠落
- Load 関数の型定義の欠落
- SSR/CSR の不適切な使い分け

### MEDIUM (検討)

- 過度に大きいコンポーネント（>400行）
- 未使用の Props
- `:global` スタイルの過度な使用
- `$state` で管理すべきローカル状態

## 実行される自動チェック

```bash
# 型チェック
npx svelte-check --tsconfig ./tsconfig.json

# リンティング
npx eslint . --ext .svelte,.ts,.js

# TypeScript
npx tsc --noEmit
```

## 他のコマンドとの統合

- まず `/svelte-test` でテスト駆動開発を適用
- `/svelte-build` でビルドエラーを事前に修正
- レビュー後に `/test-coverage` でカバレッジを検証
- `/e2e` で重要なユーザーフローをテスト

## 関連エージェント

このコマンドは以下のエージェントを呼び出します:

- `~/.claude/agents/svelte-reviewer.md` - Svelte コードレビュー
- `~/.claude/agents/svelte-file-editor.md` - MCP ツールによるコード検証

また、以下のスキルを参照できます:

- `~/.claude/skills/svelte-patterns/` - Svelte 5 / SvelteKit 実装パターン
- `~/.claude/skills/svelte-core-bestpractices/` - Svelte 5 公式ベストプラクティス
- `~/.claude/skills/svelte-code-writer/` - Svelte MCP CLI ツール
- `~/.claude/skills/svelte-testing/` - テスト戦略
- `~/.claude/skills/security-review/` - セキュリティレビュー
