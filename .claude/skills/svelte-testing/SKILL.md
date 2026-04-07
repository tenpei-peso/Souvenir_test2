---
name: svelte-testing
description: Svelte/SvelteKit の Vitest + Testing Library によるユニットテスト、Playwright による E2E テスト、TDD ワークフローのベストプラクティス。
---

# Svelte テスト

Svelte 5 + SvelteKit + TypeScript でのテスト駆動開発とテスト戦略。

## いつ有効化するか

- Svelte コンポーネントのテストを書くとき
- SvelteKit の Load 関数/アクションのテスト時
- E2E テストの作成時
- テストカバレッジの向上時

## テスト環境セットアップ

```typescript
// vitest.config.ts
import { defineConfig } from "vitest/config";
import { svelte } from "@sveltejs/vite-plugin-svelte";

export default defineConfig({
  plugins: [svelte({ hot: false })],
  test: {
    environment: "jsdom",
    include: ["src/**/*.test.ts"],
    setupFiles: ["src/test/setup.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "html", "lcov"],
      thresholds: { lines: 80, functions: 80, branches: 80 },
    },
  },
});
```

```typescript
// src/test/setup.ts
import "@testing-library/jest-dom/vitest";
```

## コンポーネントテスト

### 基本的なレンダリング

```typescript
import { render, screen } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import Badge from "./Badge.svelte";

describe("Badge", () => {
  it("テキストを表示する", () => {
    render(Badge, { props: { text: "新規", variant: "success" } });
    expect(screen.getByText("新規")).toBeInTheDocument();
  });

  it("バリアントに応じたクラスを適用する", () => {
    render(Badge, { props: { text: "エラー", variant: "error" } });
    expect(screen.getByText("エラー")).toHaveClass("badge-error");
  });
});
```

### ユーザーインタラクション

```typescript
import { render, screen } from "@testing-library/svelte";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";
import SearchForm from "./SearchForm.svelte";

describe("SearchForm", () => {
  it("入力値を送信する", async () => {
    const user = userEvent.setup();
    const onSearch = vi.fn();

    render(SearchForm, { props: { onSearch } });

    await user.type(screen.getByRole("searchbox"), "test query");
    await user.click(screen.getByRole("button", { name: "検索" }));

    expect(onSearch).toHaveBeenCalledWith("test query");
  });

  it("空文字では送信しない", async () => {
    const user = userEvent.setup();
    const onSearch = vi.fn();

    render(SearchForm, { props: { onSearch } });
    await user.click(screen.getByRole("button", { name: "検索" }));

    expect(onSearch).not.toHaveBeenCalled();
  });
});
```

### 非同期コンポーネント

```typescript
import { render, screen, waitFor } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import UserList from "./UserList.svelte";

describe("UserList", () => {
  it("ローディングを表示後データを描画する", async () => {
    render(UserList);

    expect(screen.getByText("読み込み中...")).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByText("Alice")).toBeInTheDocument();
    });
  });
});
```

## SvelteKit Load 関数テスト

```typescript
import { describe, it, expect, vi } from "vitest";
import { load } from "./+page.server";

describe("+page.server load", () => {
  const mockLocals = {
    db: {
      users: {
        findMany: vi.fn(),
        count: vi.fn(),
      },
    },
    user: { orgId: "org-1" },
  };

  it("ユーザー一覧を返す", async () => {
    const users = [{ id: "1", name: "Alice" }];
    mockLocals.db.users.findMany.mockResolvedValue(users);

    const result = await load({
      locals: mockLocals,
      depends: vi.fn(),
    } as any);

    expect(result.users).toEqual(users);
  });
});
```

## SvelteKit Actions テスト

```typescript
import { describe, it, expect, vi } from "vitest";
import { actions } from "./+page.server";

describe("Form actions", () => {
  it("バリデーションエラーで fail を返す", async () => {
    const formData = new FormData();
    formData.set("name", "");

    const result = await actions.default({
      request: { formData: async () => formData } as any,
      locals: { db: { users: { create: vi.fn() } } },
    } as any);

    expect(result?.status).toBe(400);
  });
});
```

## E2E テスト (Playwright)

```typescript
// tests/auth.spec.ts
import { test, expect } from "@playwright/test";

test.describe("認証フロー", () => {
  test("ログイン → ダッシュボード", async ({ page }) => {
    await page.goto("/login");
    await page.getByLabel("メールアドレス").fill("admin@example.com");
    await page.getByLabel("パスワード").fill("password123");
    await page.getByRole("button", { name: "ログイン" }).click();

    await expect(page).toHaveURL("/dashboard");
    await expect(
      page.getByRole("heading", { name: "ダッシュボード" }),
    ).toBeVisible();
  });

  test("無効な認証情報でエラー表示", async ({ page }) => {
    await page.goto("/login");
    await page.getByLabel("メールアドレス").fill("wrong@example.com");
    await page.getByLabel("パスワード").fill("wrong");
    await page.getByRole("button", { name: "ログイン" }).click();

    await expect(page.getByText("認証に失敗しました")).toBeVisible();
  });
});
```

## テストヘルパー

```typescript
// src/test-utils/render.ts
import { render, type RenderResult } from "@testing-library/svelte";
import type { ComponentProps, SvelteComponent } from "svelte";

export function renderWithContext<C extends SvelteComponent>(
  Component: new (...args: any[]) => C,
  props?: Partial<ComponentProps<C>>,
) {
  return render(Component, { props: props as any });
}
```

## 実行コマンド

```bash
# 全テスト
npx vitest run

# ウォッチモード
npx vitest

# カバレッジ
npx vitest run --coverage

# E2E
npx playwright test

# 特定テスト
npx vitest run src/lib/components/Badge.test.ts
npx playwright test tests/auth.spec.ts
```
