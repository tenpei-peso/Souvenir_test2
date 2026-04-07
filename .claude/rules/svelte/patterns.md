---
paths:
  - "**/*.svelte"
  - "**/*.svelte.ts"
  - "**/*.svelte.js"
---

# Svelte パターン

> [common/patterns.md](../common/patterns.md) と [typescript/patterns.md](../typescript/patterns.md) を拡張。

## リアクティブストア (.svelte.ts)

```typescript
// lib/stores/counter.svelte.ts
export function createCounter(initial = 0) {
  let count = $state(initial);
  const doubled = $derived(count * 2);

  return {
    get count() {
      return count;
    },
    get doubled() {
      return doubled;
    },
    increment() {
      count++;
    },
    reset() {
      count = initial;
    },
  };
}
```

## SvelteKit Load パターン

```typescript
// +page.server.ts
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ params, locals }) => {
  const user = await locals.db.users.findById(params.id);
  if (!user) throw error(404, "User not found");
  return { user };
};
```

## フォームアクション

```typescript
// +page.server.ts
import type { Actions } from "./$types";
import { fail, redirect } from "@sveltejs/kit";

export const actions: Actions = {
  create: async ({ request, locals }) => {
    const data = await request.formData();
    const name = data.get("name")?.toString();

    if (!name) return fail(400, { name, missing: true });

    await locals.db.items.create({ name });
    throw redirect(303, "/items");
  },
};
```

```svelte
<!-- +page.svelte -->
<script lang="ts">
import { enhance } from '$app/forms'

const { form } = $props()
</script>

<form method="POST" action="?/create" use:enhance>
  <input name="name" value={form?.name ?? ''} />
  {#if form?.missing}<p class="error">名前は必須です</p>{/if}
  <button>作成</button>
</form>
```

## API レスポンス (SvelteKit)

```typescript
// +server.ts
import { json, error } from "@sveltejs/kit";
import type { RequestHandler } from "./$types";

export const GET: RequestHandler = async ({ url, locals }) => {
  const page = Number(url.searchParams.get("page") ?? "1");
  const limit = Math.min(Number(url.searchParams.get("limit") ?? "20"), 100);

  const { data, total } = await locals.db.items.findMany({ page, limit });
  return json({ success: true, data, meta: { total, page, limit } });
};
```

## コンポーネントコンポジション

```svelte
<!-- Dialog.svelte -->
<script lang="ts">
import type { Snippet } from 'svelte'

interface Props {
  open: boolean
  onClose: () => void
  header: Snippet
  children: Snippet
  footer?: Snippet
}

const { open, onClose, header, children, footer }: Props = $props()
</script>

{#if open}
  <div class="overlay" role="presentation" onclick={onClose}>
    <div class="dialog" role="dialog" onclick|stopPropagation>
      <header>{@render header()}</header>
      <main>{@render children()}</main>
      {#if footer}<footer>{@render footer()}</footer>{/if}
    </div>
  </div>
{/if}
```
