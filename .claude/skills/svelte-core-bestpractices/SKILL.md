---
name: svelte-core-bestpractices
description: Svelte 5 公式ベストプラクティス。リアクティビティ、イベント処理、スタイリング、外部ライブラリ統合など、高速で堅牢なモダン Svelte コードの書き方ガイド。Svelte コンポーネントの作成・編集・分析時に参照する。
---

# Svelte 5 公式ベストプラクティス

Svelte 公式ガイドラインに基づく、モダンな Svelte コードの書き方。
実装パターンやSvelteKit統合は `svelte-patterns` スキルを参照。

## リファレンスドキュメント (必須)

以下の `references/` ディレクトリに Svelte 5 公式 API の詳細ドキュメントがある。
**Svelte ファイルの作成・編集時は、関連するリファレンスを必ず読み込んでから作業すること。**

パスのベース: `.claude/skills/svelte-core-bestpractices/references/`

| ファイル               | 内容                          | 読むタイミング                                 |
| ---------------------- | ----------------------------- | ---------------------------------------------- |
| `@attach.md`           | `{@attach}` ディレクティブ    | 外部ライブラリ統合、DOM 要素の初期化時         |
| `@render.md`           | `{@render}` タグ              | Snippet の描画、コンポーネント合成時           |
| `snippet.md`           | `{#snippet}` ブロック         | 再利用可能なマークアップ定義時                 |
| `bind.md`              | 関数バインディング            | `bind:` ディレクティブ、双方向バインディング時 |
| `each.md`              | `{#each}` ブロック            | リスト描画、キー付きイテレーション時           |
| `$inspect.md`          | `$inspect` / `$inspect.trace` | リアクティビティのデバッグ時                   |
| `svelte-reactivity.md` | `createSubscriber` 等         | 外部状態の監視、カスタムリアクティビティ時     |
| `await-expressions.md` | 非同期 Svelte (`await` 式)    | コンポーネント内で Promise を直接使用する時    |
| `hydratable.md`        | SSR 対応コンポーネント        | SSR/ハイドレーション対応が必要な時             |

## `$state`

リアクティブにすべき変数（`$effect`、`$derived`、テンプレート式の更新をトリガーする変数）にのみ `$state` を使用する。それ以外は通常の変数で十分。

オブジェクトや配列（`$state({...})` / `$state([...])`）はディープリアクティブになり、ミューテーションが更新をトリガーする。ただし Proxy 化によるパフォーマンスオーバーヘッドがあるため、再代入のみで変更する大きなオブジェクト（APIレスポンスなど）には `$state.raw` を使用する。

## `$derived`

状態から何かを計算する場合は `$effect` ではなく `$derived` を使用する:

```js
// 正しい
let square = $derived(num * num);

// 避ける
let square;
$effect(() => {
  square = num * num;
});
```

> [!NOTE] `$derived` は式を受け取る（関数ではない）。複雑な式が必要な場合は `$derived.by` を使用する。

`$derived` は書き込み可能 - `$state` と同様に代入でき、式が変更されると再評価される。

派生式の結果がオブジェクトや配列の場合、そのまま返される（ディープリアクティブにはならない）。必要な場合は `$derived.by` 内で `$state` を使用できる。

## `$effect`

エフェクトはエスケープハッチであり、基本的に避けるべき。特にエフェクト内での状態更新は避ける。

- 外部ライブラリ（D3など）との同期には `{@attach ...}` を使用（詳細: `references/@attach.md`）
- ユーザー操作への応答はイベントハンドラに直接記述するか、関数バインディングを使用（詳細: `references/bind.md`）
- デバッグ用ログには `$inspect` を使用（詳細: `references/$inspect.md`）
- Svelte 外部の監視には `createSubscriber` を使用（詳細: `references/svelte-reactivity.md`）

エフェクトの中身を `if (browser) {...}` で囲まないこと - エフェクトはサーバーでは実行されない。

## `$props`

Props は変更される前提で扱う。Props に依存する値には `$derived` を使用する:

```js
let { type } = $props();

// 正しい
let color = $derived(type === "danger" ? "red" : "green");

// 避ける - type が変更されても color は更新されない
let color = type === "danger" ? "red" : "green";
```

## `$inspect.trace`

リアクティビティのデバッグツール。更新が正しく動作しない場合や過剰に実行される場合、`$effect` や `$derived.by` の先頭行に `$inspect.trace(label)` を追加して依存関係を追跡し、どれが更新をトリガーしたかを特定できる。

## イベント

`on` で始まる要素属性はすべてイベントリスナーとして扱われる:

```svelte
<button onclick={() => {...}}>クリック</button>

<!-- 属性の省略記法 -->
<button {onclick}>...</button>

<!-- スプレッド属性 -->
<button {...props}>...</button>
```

`window` や `document` にリスナーを付ける場合は `<svelte:window>` と `<svelte:document>` を使用する:

```svelte
<svelte:window onkeydown={...} />
<svelte:document onvisibilitychange={...} />
```

`onMount` や `$effect` でのリスナー登録は避ける。

## Snippets

Snippets（詳細: `references/snippet.md`）は再利用可能なマークアップの塊を定義し、`{@render ...}`（詳細: `references/@render.md`）タグでインスタンス化する。テンプレート内で宣言する必要がある。

```svelte
{#snippet greeting(name)}
	<p>こんにちは {name}!</p>
{/snippet}

{@render greeting('世界')}
```

> [!NOTE] コンポーネントのトップレベル（要素やブロックの外）で宣言された Snippet は `<script>` 内から参照可能。コンポーネント状態を参照しない Snippet は `<script module>` でも利用でき、エクスポートして他のコンポーネントから使用可能。

## Each ブロック

キー付き each ブロック（詳細: `references/each.md`）を使用する。Svelte が既存アイテムの DOM を更新する代わりに、外科的にアイテムを挿入・削除できるためパフォーマンスが向上する。

> [!NOTE] キーはオブジェクトを一意に識別する必要がある。インデックスをキーとして使用しない。

`bind:value={item.count}` のようにアイテムをミューテートする必要がある場合、分割代入は避ける。

## CSS での JavaScript 変数の使用

JS 変数を CSS 内で使用する場合、`style:` ディレクティブで CSS カスタムプロパティを設定する:

```svelte
<div style:--columns={columns}>...</div>
```

コンポーネントの `<style>` 内で `var(--columns)` を参照できる。

## 子コンポーネントのスタイリング

コンポーネントの `<style>` 内の CSS はそのコンポーネントにスコープされる。親から子のスタイルを制御する場合、CSS カスタムプロパティの使用を推奨:

```svelte
<!-- Parent.svelte -->
<Child --color="red" />

<!-- Child.svelte -->
<h1>Hello</h1>

<style>
	h1 {
		color: var(--color);
	}
</style>
```

ライブラリのコンポーネントなど不可能な場合は `:global` を使用:

```svelte
<div>
	<Child />
</div>

<style>
	div :global {
		h1 {
			color: red;
		}
	}
</style>
```

## Context

共有モジュールで状態を宣言する代わりに Context の使用を検討する。状態を必要な部分にスコープし、SSR 時のユーザー間での状態漏洩を防止できる。

型安全のため `setContext`/`getContext` よりも `createContext` を使用する。

## 非同期 Svelte

バージョン 5.36 以降では、await 式（詳細: `references/await-expressions.md`）と hydratable（詳細: `references/hydratable.md`）を使用してコンポーネント内で直接 Promise を使用可能。`svelte.config.js` で `experimental.async` オプションの有効化が必要（まだ完全安定ではない）。

## レガシー機能の回避

新規コードでは常に Runes モードを使用し、モダンな代替がある機能を避ける:

- `let count = 0; count += 1` の暗黙的リアクティビティの代わりに `$state` を使用
- `$:` 代入・ステートメントの代わりに `$derived` と `$effect` を使用（`$effect` はより良い手段がない場合のみ）
- `export let`、`$$props`、`$$restProps` の代わりに `$props` を使用
- `on:click={...}` の代わりに `onclick={...}` を使用
- `<slot>`、`$$slots`、`<svelte:fragment>` の代わりに `{#snippet ...}` と `{@render ...}` を使用
- `<svelte:component this={DynamicComponent}>` の代わりに `<DynamicComponent>` を使用
- `<svelte:self>` の代わりに `import Self from './ThisComponent.svelte'` と `<Self>` を使用
- ストアの代わりに `$state` フィールドを持つクラスでコンポーネント間のリアクティビティを共有
- `use:action` の代わりに `{@attach ...}` を使用
- `class:` ディレクティブの代わりに `class` 属性で clsx スタイルの配列・オブジェクトを使用
