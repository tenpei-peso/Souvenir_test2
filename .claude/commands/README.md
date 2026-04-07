# コマンド一覧と関連リソース

コマンドはスラッシュ（`/command-name`）で起動します。`commands/` 配下の定義ファイルは、原則として先頭に frontmatter を持ちます。

## frontmatter ルール

### 標準コマンド

- 必須: `description`
- 任意: `agents`, `rules`, `skills`
- 用途: エージェントやルール、スキルと連携して動く通常のコマンド

```markdown
---
description: コマンドの説明
agents: [使用するエージェント名]
rules: [参照するルールファイル]
skills: [参照するスキル名]
---
```

### ユーティリティ / 特殊コマンド

- 必須: `description`
- 任意: `name`, `command`, `skills`, `disable-model-invocation`
- 用途: CLI ラッパー、セッション管理、設定系など、通常の agent 連携とは別の制御が必要なコマンド
- `disable-model-invocation` は CLI 実行だけで完結するコマンドに付与する

```markdown
---
name: command-name
description: コマンドの説明
command: /command-name
skills: [必要なスキル名]
disable-model-invocation: true
---
```

`README.md` 自体はコマンド定義ではなく、このディレクトリの仕様書です。

---

## 共通コマンド（言語非依存）

| コマンド           | 説明                                       | エージェント                                                    | ルール                                                  | スキル                        |
| ------------------ | ------------------------------------------ | --------------------------------------------------------------- | ------------------------------------------------------- | ----------------------------- |
| `/plan`            | 実装計画を作成                             | planner, architect                                              | common/agents.md                                        | -                             |
| `/tdd`             | テスト駆動開発ワークフロー                 | tdd-guide                                                       | common/testing.md                                       | tdd-workflow                  |
| `/code-review`     | コード品質 & セキュリティレビュー          | code-reviewer, security-reviewer                                | common/security.md, common/coding-style.md              | security-review               |
| `/build-fix`       | ビルドエラーを段階的に修正                 | build-error-resolver                                            | common/coding-style.md                                  | -                             |
| `/e2e`             | E2E テスト生成 & 実行                      | e2e-runner                                                      | common/testing.md                                       | -                             |
| `/verify`          | ビルド/型/Lint/テスト/シークレット包括検証 | build-error-resolver, code-reviewer                             | common/testing.md, common/security.md                   | -                             |
| `/test-coverage`   | テストカバレッジ分析 & テスト生成          | tdd-guide                                                       | common/testing.md                                       | tdd-workflow                  |
| `/refactor-clean`  | デッドコード検出 & 安全な削除              | refactor-cleaner                                                | common/coding-style.md                                  | -                             |
| `/orchestrate`     | 複数エージェントの連続実行                 | planner, tdd-guide, code-reviewer, security-reviewer, architect | common/agents.md, common/testing.md, common/security.md | tdd-workflow, security-review |
| `/checkpoint`      | チェックポイント作成 & 検証                | -                                                               | common/git-workflow.md                                  | -                             |
| `/update-docs`     | ドキュメントを同期・更新                   | doc-updater                                                     | -                                                       | -                             |
| `/update-codemaps` | コードマップを生成・更新                   | doc-updater                                                     | -                                                       | -                             |
| `/eval`            | 評価駆動開発ワークフロー                   | tdd-guide                                                       | common/testing.md                                       | eval-harness                  |

## Flutter 固有コマンド

Flutter 固有コマンド内の `flutter` / `dart` 実行例は、FVM 利用プロジェクトでは `fvm flutter` / `fvm dart` を前提とします。

| コマンド          | 説明                     | エージェント                                 | ルール                                                            | スキル                                             |
| ----------------- | ------------------------ | -------------------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------- |
| `/flutter-build`  | Flutter ビルドエラー修正 | flutter-build-resolver, build-error-resolver | flutter/coding-style.md, flutter/hooks.md                         | flutter-patterns, flutter-testing                  |
| `/flutter-review` | Flutter コードレビュー   | flutter-reviewer, code-reviewer              | flutter/coding-style.md, flutter/patterns.md, flutter/security.md | flutter-patterns, flutter-testing, security-review |
| `/flutter-test`   | Flutter TDD ワークフロー | tdd-guide, flutter-reviewer                  | flutter/testing.md, common/testing.md                             | flutter-testing, flutter-patterns, tdd-workflow    |

## Svelte 固有コマンド

| コマンド         | 説明                    | エージェント                                                    | ルール                                                         | スキル                                                                                          |
| ---------------- | ----------------------- | --------------------------------------------------------------- | -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `/svelte-build`  | Svelte ビルドエラー修正 | svelte-build-resolver, svelte-file-editor, build-error-resolver | svelte/coding-style.md, svelte/hooks.md                        | svelte-patterns, svelte-core-bestpractices, svelte-code-writer, svelte-testing                  |
| `/svelte-review` | Svelte コードレビュー   | svelte-reviewer, svelte-file-editor, code-reviewer              | svelte/coding-style.md, svelte/patterns.md, svelte/security.md | svelte-patterns, svelte-core-bestpractices, svelte-code-writer, svelte-testing, security-review |
| `/svelte-test`   | Svelte TDD ワークフロー | tdd-guide, svelte-file-editor, svelte-reviewer                  | svelte/testing.md, common/testing.md                           | svelte-testing, svelte-patterns, svelte-core-bestpractices, svelte-code-writer, tdd-workflow    |

## 学習 & インスティンク

| コマンド           | 説明                                           | スキル                                      |
| ------------------ | ---------------------------------------------- | ------------------------------------------- |
| `/learn`           | セッションから再利用パターンを抽出             | continuous-learning, continuous-learning-v2 |
| `/evolve`          | instincts をスキル/コマンド/エージェントに進化 | continuous-learning-v2                      |
| `/skill-create`    | git 履歴から SKILL.md を自動生成               | continuous-learning                         |
| `/instinct-import` | インスティンクトをインポート                   | continuous-learning-v2                      |
| `/instinct-export` | インスティンクトをエクスポート                 | continuous-learning-v2                      |
| `/instinct-status` | インスティンクトステータス表示                 | continuous-learning-v2                      |

## マルチモデル協調

| コマンド          | 説明                                          |
| ----------------- | --------------------------------------------- |
| `/multi-plan`     | マルチモデル協調による計画生成                |
| `/multi-execute`  | マルチモデルでプロトタイプ & 実装             |
| `/multi-frontend` | フロントエンド中心のマルチモデルワークフロー  |
| `/multi-backend`  | バックエンド中心のマルチモデルワークフロー    |
| `/multi-workflow` | 6フェーズ完全ワークフロー（自動ルーティング） |

## ユーティリティ

| コマンド    | 説明                       |
| ----------- | -------------------------- |
| `/sessions` | セッション履歴管理         |
| `/setup-pm` | パッケージマネージャー設定 |
| `/pm2`      | PM2 デプロイメント管理     |

---

## 推奨ワークフロー

### 新機能開発

```
/plan -> /tdd -> /code-review -> /build-fix -> /e2e -> /update-docs
```

### Flutter 開発

```
/plan -> /flutter-test -> /flutter-review -> /flutter-build -> /update-docs
```

### Svelte 開発

```
/plan -> /svelte-test -> /svelte-review -> /svelte-build -> /update-docs
```

### デバッグ

```
/verify -> /build-fix -> /code-review -> /test-coverage
```

---

## カスタムコマンドを追加

`commands/` に `.md` ファイルを作成し、用途に応じて以下のどちらかの frontmatter を付けます。

### 標準コマンドの例

```markdown
---
description: コマンドの説明
agents: [使用するエージェント名]
rules: [参照するルールファイル]
skills: [参照するスキル名]
---

# コマンド名

## 手順

1. ステップ 1
2. ステップ 2
```

### ユーティリティ / 特殊コマンドの例

```markdown
---
name: command-name
description: コマンドの説明
command: /command-name
skills: [必要なスキル名]
disable-model-invocation: true
---

# コマンド名

## 実装

必要な CLI やスクリプトの呼び出しを記述します。
```

---

## ディレクトリ構成

```
commands/          ... コマンド定義
agents/            ... エージェント定義
rules/
  common/          ... 全プロジェクト共通ルール
  flutter/         ... Flutter 固有ルール
  svelte/          ... Svelte 固有ルール
  typescript/      ... TypeScript 固有ルール
skills/            ... スキル定義
CLAUDE.md          ... 会社共通設定
PROJECT.md         ... プロジェクト固有設定（要カスタマイズ）
```
