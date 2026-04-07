---
paths:
  - "**/*.svelte"
  - "**/*.svelte.ts"
  - "**/*.svelte.js"
---

# Svelte セキュリティ

> [common/security.md](../common/security.md) と [typescript/security.md](../typescript/security.md) を拡張。

## XSS 防止

`{@html}` は原則禁止。やむを得ない場合はサニタイズ必須。

```svelte
<!-- 誤り: 未サニタイズの HTML -->
{@html userInput}

<!-- 正解: サニタイズ済み HTML -->
{@html DOMPurify.sanitize(userInput)}

<!-- 正解: テキストとして表示 (自動エスケープ) -->
<p>{userInput}</p>
```

## 環境変数

```typescript
// 誤り: クライアントにシークレット漏洩
const key = import.meta.env.VITE_SECRET_KEY;

// 正解: サーバー専用 ($env/static/private)
import { SECRET_KEY } from "$env/static/private";

// 正解: 公開情報のみクライアントに
import { PUBLIC_APP_URL } from "$env/static/public";
```

## CSRF 対策

SvelteKit のフォームアクションは CSRF トークンを自動付与。API ルートでは手動確認。

```typescript
// +server.ts
export const POST: RequestHandler = async ({ request }) => {
  const origin = request.headers.get("origin");
  if (origin !== PUBLIC_APP_URL) {
    throw error(403, "Forbidden");
  }
  // ...処理
};
```

## 認証ガード

```typescript
// hooks.server.ts
import type { Handle } from "@sveltejs/kit";

export const handle: Handle = async ({ event, resolve }) => {
  const session = await event.locals.auth.validate();
  event.locals.user = session?.user ?? null;

  if (event.url.pathname.startsWith("/admin") && !event.locals.user) {
    throw redirect(303, "/login");
  }

  return resolve(event);
};
```

## Agent サポート

- **security-reviewer** で包括的なセキュリティ監査を実施
