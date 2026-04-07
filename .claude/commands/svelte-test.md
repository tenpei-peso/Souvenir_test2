---
description: Svelte/SvelteKit のテスト駆動開発 (TDD) ワークフロー。Vitest + Testing Library でユニットテスト、Playwright で E2E テスト。80%以上のカバレッジを確認します。
agents: [tdd-guide, svelte-file-editor, svelte-reviewer]
rules: [svelte/testing.md, common/testing.md]
skills:
  [
    svelte-testing,
    svelte-patterns,
    svelte-core-bestpractices,
    svelte-code-writer,
    tdd-workflow,
  ]
---

# Svelte TDD コマンド

Svelte/SvelteKit のテスト駆動開発手法を適用します。TypeScript を使用します。

## 機能

1. **コンポーネント設計**: Props とインターフェースを最初に定義
2. **テストの作成**: Vitest + Testing Library でテストケースを作成 (RED)
3. **テストの実行**: テストが正しい理由で失敗することを確認
4. **コードの実装**: テストをパスするための最小限のコードを記述 (GREEN)
5. **リファクタリング**: テストをグリーンに保ちながら改善
6. **カバレッジの確認**: 80%以上のカバレッジを保証

## 使用するタイミング

- 新しい Svelte コンポーネントの作成時
- SvelteKit の Load 関数/アクション実装時
- バグ修正時（失敗するテストを最初に作成）
- リファクタリング時

## TDD サイクル

```
RED     → 失敗するテストを作成
GREEN   → テストをパスするための最小限のコードを実装
REFACTOR → コードを改善、テストはグリーンを保持
REPEAT  → 次のテストケースへ
```

## セッション例

```text
User: /svelte-test ユーザー一覧を表示するコンポーネントが必要です

Agent:
# TDD セッション: UserList コンポーネント

## ステップ 1: 型定義

// lib/types/user.ts
export interface User {
  id: string
  name: string
  email: string
}

## ステップ 2: テストの作成 (RED)

// lib/components/UserList.test.ts
import { render, screen } from '@testing-library/svelte'
import { describe, it, expect } from 'vitest'
import UserList from './UserList.svelte'

describe('UserList', () => {
  const users = [
    { id: '1', name: 'Alice', email: 'alice@example.com' },
    { id: '2', name: 'Bob', email: 'bob@example.com' },
  ]

  it('ユーザー名を表示する', () => {
    render(UserList, { props: { users } })
    expect(screen.getByText('Alice')).toBeInTheDocument()
    expect(screen.getByText('Bob')).toBeInTheDocument()
  })

  it('空の場合メッセージを表示する', () => {
    render(UserList, { props: { users: [] } })
    expect(screen.getByText('ユーザーがいません')).toBeInTheDocument()
  })
})

## ステップ 3: テスト実行 → FAIL

$ npx vitest run src/lib/components/UserList.test.ts
FAIL: Cannot find module './UserList.svelte'

## ステップ 4: 実装 (GREEN)

// lib/components/UserList.svelte
<script lang="ts">
  import type { User } from '$lib/types/user'

  interface Props { users: User[] }
  const { users }: Props = $props()
</script>

{#if users.length === 0}
  <p>ユーザーがいません</p>
{:else}
  <ul>
    {#each users as user (user.id)}
      <li>{user.name} - {user.email}</li>
    {/each}
  </ul>
{/if}

## ステップ 5: テスト実行 → PASS ✓

## ステップ 6: カバレッジ確認
$ npx vitest run --coverage
Coverage: 95% ✓
```

## 実行コマンド

```bash
# ユニットテスト
npx vitest run

# ウォッチモード
npx vitest

# カバレッジ
npx vitest run --coverage

# E2E テスト
npx playwright test

# 特定テスト
npx vitest run src/lib/components/UserList.test.ts
```

## 他のコマンドとの統合

- まず `/plan` で何を構築するかを計画
- `/svelte-test` でテスト付きで実装
- `/svelte-build` でビルドエラー発生時に修正
- `/svelte-review` で実装をレビュー
- `/test-coverage` でカバレッジを検証
- `/e2e` で重要なユーザーフローの E2E テスト

## 関連エージェント

このコマンドは以下のエージェントを呼び出します:

- `~/.claude/agents/tdd-guide.md` - TDD ガイド
- `~/.claude/agents/svelte-file-editor.md` - MCP ツールによるコード検証

また、以下のスキルを参照できます:

- `~/.claude/skills/svelte-testing/` - Svelte テスト戦略
- `~/.claude/skills/svelte-patterns/` - Svelte 5 / SvelteKit 実装パターン
- `~/.claude/skills/svelte-core-bestpractices/` - Svelte 5 公式ベストプラクティス
- `~/.claude/skills/svelte-code-writer/` - Svelte MCP CLI ツール
- `~/.claude/skills/tdd-workflow/` - TDD ワークフロー
