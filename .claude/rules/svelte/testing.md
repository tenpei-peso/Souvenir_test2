---
paths:
  - "**/*.svelte"
  - "**/*.svelte.ts"
  - "**/*.svelte.js"
---

# Svelte テスト

> [common/testing.md](../common/testing.md) と [typescript/testing.md](../typescript/testing.md) を拡張。

## ユニットテスト (Vitest + Testing Library)

```typescript
// Component.test.ts
import { render, screen, fireEvent } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import Counter from "./Counter.svelte";

describe("Counter", () => {
  it("初期値を表示する", () => {
    render(Counter, { props: { initial: 5 } });
    expect(screen.getByText("5")).toBeInTheDocument();
  });

  it("クリックでインクリメントする", async () => {
    render(Counter);
    await fireEvent.click(screen.getByRole("button", { name: "+" }));
    expect(screen.getByText("1")).toBeInTheDocument();
  });
});
```

## SvelteKit Load 関数テスト

```typescript
// +page.server.test.ts
import { describe, it, expect, vi } from "vitest";
import { load } from "./+page.server";

describe("load", () => {
  it("ユーザーデータを返す", async () => {
    const result = await load({
      params: { id: "1" },
      locals: {
        db: {
          users: {
            findById: vi.fn().mockResolvedValue({ id: "1", name: "Test" }),
          },
        },
      },
    } as any);
    expect(result.user).toEqual({ id: "1", name: "Test" });
  });
});
```

## E2E テスト (Playwright)

```typescript
// tests/auth.spec.ts
import { test, expect } from "@playwright/test";

test("ログインフロー", async ({ page }) => {
  await page.goto("/login");
  await page.getByLabel("メール").fill("test@example.com");
  await page.getByLabel("パスワード").fill("password123");
  await page.getByRole("button", { name: "ログイン" }).click();
  await expect(page).toHaveURL("/dashboard");
});
```

## Agent サポート

- **e2e-runner** - Playwright E2E テストスペシャリスト
- **svelte-reviewer** - Svelte コードレビュー
