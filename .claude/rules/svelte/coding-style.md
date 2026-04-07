---
paths:
  - "**/*.svelte"
  - "**/*.svelte.ts"
  - "**/*.svelte.js"
---

# Svelte コーディングスタイル

> [common/coding-style.md](../common/coding-style.md) と [typescript/coding-style.md](../typescript/coding-style.md) を拡張。

## Runes (Svelte 5)

Svelte 5 の Runes を使用し、レガシーな `$:` リアクティブ宣言は避ける。

```svelte
<script lang="ts">
// 誤り: レガシーリアクティブ
// let count = 0
// $: doubled = count * 2

// 正解: Runes
let count = $state(0)
const doubled = $derived(count * 2)

function increment() {
  count++
}
</script>
```

## コンポーネント Props

`$props()` で型安全な Props を定義。

```svelte
<script lang="ts">
interface Props {
  name: string
  age?: number
  onSelect?: (id: string) => void
}

const { name, age = 0, onSelect }: Props = $props()
</script>
```

## $effect の使用

副作用は `$effect` で管理。クリーンアップを忘れない。

```svelte
<script lang="ts">
let width = $state(0)

$effect(() => {
  const handler = () => { width = window.innerWidth }
  window.addEventListener('resize', handler)
  return () => window.removeEventListener('resize', handler)
})
</script>
```

## Snippet パターン

再利用可能なテンプレートには `{#snippet}` を使用。

```svelte
{#snippet userCard(user: User)}
  <div class="card">
    <h3>{user.name}</h3>
    <p>{user.email}</p>
  </div>
{/snippet}

{#each users as user}
  {@render userCard(user)}
{/each}
```

## TypeScript 統合

- `<script lang="ts">` を必ず使用
- Props に `interface` を定義
- `$state<Type>()` でジェネリクス指定
- イベントハンドラに型を付ける

```svelte
<script lang="ts">
import type { MouseEventHandler } from 'svelte/elements'

let items = $state<string[]>([])

const handleClick: MouseEventHandler<HTMLButtonElement> = (e) => {
  console.log(e.currentTarget.name)
}
</script>
```

## ファイル構成

- 1コンポーネント1ファイル、200-400行目安
- ロジックが複雑なら `.svelte.ts` に分離
- `+page.svelte` はルーティング用、ロジックは `+page.ts` / `+page.server.ts` に
- 共通コンポーネントは `$lib/components/` に配置

## スタイル

- Tailwind CSS を優先
- スコープドスタイルのみ使用（`:global` は最小限に）
- 動的クラスは条件式で

```svelte
<div class="p-4" class:active={isActive} class:hidden={!visible}>
  {content}
</div>
```
