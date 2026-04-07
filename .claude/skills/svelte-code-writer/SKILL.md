---
name: svelte-code-writer
description: Svelte 5 公式ドキュメント検索・コード分析用 CLI ツール。Svelte コンポーネント (.svelte) やモジュール (.svelte.ts/.svelte.js) の作成・編集・分析時に使用する。svelte-file-editor エージェントとの併用を推奨。
---

# Svelte 5 コードライター

## CLI ツール

Svelte 固有の支援のため `@sveltejs/mcp` CLI を利用できる。`npx` 経由で以下のコマンドを使用する:

### ドキュメントセクション一覧

```bash
npx @sveltejs/mcp list-sections
```

Svelte 5 / SvelteKit の利用可能なドキュメントセクションをタイトルとパス付きで一覧表示する。

### ドキュメント取得

```bash
npx @sveltejs/mcp get-documentation "<section1>,<section2>,..."
```

指定セクションの完全なドキュメントを取得する。`list-sections` で確認後に使用する。

**例:**

```bash
npx @sveltejs/mcp get-documentation "$state,$derived,$effect"
```

### Svelte Autofixer

```bash
npx @sveltejs/mcp svelte-autofixer "<code_or_path>" [options]
```

Svelte コードを分析し、一般的な問題の修正を提案する。

**オプション:**

- `--async` - 非同期 Svelte モード有効化（デフォルト: false）
- `--svelte-version` - ターゲットバージョン: 4 または 5（デフォルト: 5）

**例:**

```bash
# インラインコード分析（$ は \$ にエスケープ）
npx @sveltejs/mcp svelte-autofixer '<script>let count = \$state(0);</script>'

# ファイル分析
npx @sveltejs/mcp svelte-autofixer ./src/lib/Component.svelte

# Svelte 4 をターゲット
npx @sveltejs/mcp svelte-autofixer ./Component.svelte --svelte-version 4
```

**重要:** ターミナルで Runes（`$state`、`$derived` など）を含むコードを渡す場合、シェルの変数展開を防ぐため `$` を `\$` にエスケープすること。

## ワークフロー

1. **構文が不明な場合:** `list-sections` を実行し、関連トピックの `get-documentation` を取得
2. **レビュー・デバッグ時:** `svelte-autofixer` でコードの問題を検出
3. **常に検証:** Svelte コンポーネントを完成させる前に必ず `svelte-autofixer` を実行
