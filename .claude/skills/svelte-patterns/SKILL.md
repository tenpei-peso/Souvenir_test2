---
name: svelte-patterns
description: Svelte 5 Runes、SvelteKit、TypeScript 統合、状態管理、パフォーマンス最適化のためのモダンな開発パターン。
---

# Svelte 開発パターン

Svelte 5 + SvelteKit + TypeScript で高性能なアプリケーションを構築するためのベストプラクティス。

## いつ有効化するか

- Svelte/SvelteKit コードを書くとき
- Svelte コードをレビューするとき
- Svelte 5 への移行時
- SvelteKit ルーティング/データロードの設計時

## Svelte 5 Runes

### $state - リアクティブ状態

```svelte
<script lang="ts">
// プリミティブ
let count = $state(0)

// オブジェクト (ディープリアクティブ)
let user = $state<User>({ name: '', email: '' })

// 配列
let items = $state<Item[]>([])
</script>
```

### $derived - 派生値

```svelte
<script lang="ts">
let items = $state<Item[]>([])
const total = $derived(items.reduce((sum, i) => sum + i.price, 0))
const formatted = $derived(`合計: ${total.toLocaleString()}円`)

// 複雑な派生値
const filtered = $derived.by(() => {
  if (!searchQuery) return items
  const q = searchQuery.toLowerCase()
  return items.filter(i => i.name.toLowerCase().includes(q))
})
</script>
```

### $effect - 副作用

```svelte
<script lang="ts">
// 基本的な副作用
$effect(() => {
  document.title = `${count} items`
})

// クリーンアップ付き
$effect(() => {
  const controller = new AbortController()
  fetch(`/api/users/${id}`, { signal: controller.signal })
    .then(r => r.json())
    .then(data => { user = data })
  return () => controller.abort()
})

// $effect.pre: DOM 更新前に実行
$effect.pre(() => {
  // スクロール位置の保持など
})
</script>
```

### $props - コンポーネント Props

```svelte
<script lang="ts">
interface Props {
  title: string
  description?: string
  variant?: 'primary' | 'secondary'
  onSubmit: (data: FormData) => Promise<void>
  children: import('svelte').Snippet
}

const {
  title,
  description = '',
  variant = 'primary',
  onSubmit,
  children
}: Props = $props()
</script>
```

### $bindable - 双方向バインディング

```svelte
<!-- SearchInput.svelte -->
<script lang="ts">
interface Props {
  value: string
}
let { value = $bindable('') }: Props = $props()
</script>

<input bind:value />

<!-- 使用側 -->
<SearchInput bind:value={searchQuery} />
```

## SvelteKit パターン

### データローディング

```typescript
// +page.server.ts - サーバーサイドのみ
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ params, locals, depends }) => {
  depends("app:users");
  const users = await locals.db.users.findMany({
    where: { orgId: locals.user.orgId },
  });
  return { users };
};
```

```typescript
// +page.ts - SSR + CSR の両方で実行
import type { PageLoad } from "./$types";

export const load: PageLoad = async ({ fetch, params }) => {
  const res = await fetch(`/api/items/${params.id}`);
  if (!res.ok) throw error(res.status, "Item not found");
  return { item: await res.json() };
};
```

### フォームアクション + プログレッシブエンハンスメント

```typescript
// +page.server.ts
import { fail, redirect } from "@sveltejs/kit";
import type { Actions } from "./$types";
import { z } from "zod";

const schema = z.object({
  name: z.string().min(1, "名前は必須です"),
  email: z.string().email("有効なメールアドレスを入力"),
});

export const actions: Actions = {
  default: async ({ request, locals }) => {
    const formData = await request.formData();
    const result = schema.safeParse(Object.fromEntries(formData));

    if (!result.success) {
      return fail(400, {
        errors: result.error.flatten().fieldErrors,
        data: Object.fromEntries(formData),
      });
    }

    await locals.db.users.create(result.data);
    throw redirect(303, "/users");
  },
};
```

```svelte
<!-- +page.svelte -->
<script lang="ts">
import { enhance } from '$app/forms'
import type { ActionData } from './$types'

const { form }: { form: ActionData } = $props()
let loading = $state(false)
</script>

<form
  method="POST"
  use:enhance={() => {
    loading = true
    return async ({ update }) => {
      loading = false
      await update()
    }
  }}
>
  <input name="name" value={form?.data?.name ?? ''} />
  {#if form?.errors?.name}
    <p class="error">{form.errors.name[0]}</p>
  {/if}
  <button disabled={loading}>
    {loading ? '送信中...' : '送信'}
  </button>
</form>
```

### API ルート

```typescript
// +server.ts
import { json, error } from "@sveltejs/kit";
import type { RequestHandler } from "./$types";

export const GET: RequestHandler = async ({ url, locals }) => {
  const page = Math.max(1, Number(url.searchParams.get("page") ?? "1"));
  const limit = Math.min(
    100,
    Math.max(1, Number(url.searchParams.get("limit") ?? "20")),
  );

  const [data, total] = await Promise.all([
    locals.db.items.findMany({ skip: (page - 1) * limit, take: limit }),
    locals.db.items.count(),
  ]);

  return json({
    success: true,
    data,
    meta: { total, page, limit, pages: Math.ceil(total / limit) },
  });
};

export const POST: RequestHandler = async ({ request, locals }) => {
  const body = await request.json();
  // バリデーション省略
  const item = await locals.db.items.create(body);
  return json({ success: true, data: item }, { status: 201 });
};
```

## パフォーマンス最適化

### 遅延ロード

```svelte
<script lang="ts">
import { onMount } from 'svelte'

let HeavyComponent: typeof import('./HeavyComponent.svelte').default | null = $state(null)

onMount(async () => {
  HeavyComponent = (await import('./HeavyComponent.svelte')).default
})
</script>

{#if HeavyComponent}
  <svelte:component this={HeavyComponent} />
{:else}
  <div class="skeleton" />
{/if}
```

### リスト仮想化

```svelte
<script lang="ts">
// 大量リストには svelte-virtual-list 等を使用
import VirtualList from 'svelte-virtual-list'

let items = $state<Item[]>([])
</script>

<VirtualList {items} let:item>
  <div class="item">{item.name}</div>
</VirtualList>
```

### デバウンス

```typescript
// lib/utils/debounce.svelte.ts
export function createDebounced<T>(initialValue: T, delay = 300) {
  let value = $state(initialValue);
  let debounced = $state(initialValue);
  let timer: ReturnType<typeof setTimeout>;

  $effect(() => {
    timer = setTimeout(() => {
      debounced = value;
    }, delay);
    return () => clearTimeout(timer);
  });

  return {
    get value() {
      return value;
    },
    set value(v: T) {
      value = v;
    },
    get debounced() {
      return debounced;
    },
  };
}
```

## リアクティブストアパターン

```typescript
// lib/stores/auth.svelte.ts
import { getContext, setContext } from "svelte";

class AuthStore {
  user = $state<User | null>(null);
  isAuthenticated = $derived(this.user !== null);

  async login(email: string, password: string) {
    const res = await fetch("/api/auth/login", {
      method: "POST",
      body: JSON.stringify({ email, password }),
      headers: { "Content-Type": "application/json" },
    });
    if (!res.ok) throw new Error("ログイン失敗");
    this.user = await res.json();
  }

  async logout() {
    await fetch("/api/auth/logout", { method: "POST" });
    this.user = null;
  }
}

const AUTH_KEY = Symbol("auth");

export function setAuthStore() {
  return setContext(AUTH_KEY, new AuthStore());
}

export function getAuthStore() {
  return getContext<AuthStore>(AUTH_KEY);
}
```

## Drizzle ORM パターン (SvelteKit)

```typescript
// lib/server/db/schema.ts
import { pgTable, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull(),
  email: text("email").notNull().unique(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});

// lib/server/db/index.ts
import { drizzle } from "drizzle-orm/node-postgres";
import * as schema from "./schema";

export const db = drizzle(process.env.DATABASE_URL!, { schema });
```
