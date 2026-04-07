# docodoor 会社共通 Claude 設定

> このファイルは会社全プロジェクト共通の設定です。
> プロジェクト固有の設定は `.claude/PROJECT.md` を参照してください。

## 言語・出力ルール

- すべての説明と回答は日本語で提供する
- コードコメントも日本語で記述する
- エラーメッセージの説明も日本語で行う
- ファイル出力に絵文字を使用しない（会話セッション内は可）

## 操作ルール

- ユーザーに選択・判断を求める場合は AskUserQuestion ツールを使う
- 明示的に依頼されない限り git commit は行わない
- 機密情報(APIキー/トークン/パスワード/JWT)をログや出力に含めない

---

## モジュール化されたルール

詳細なガイドラインは `.claude/rules/` にあります:

- rules / skills / agents は一覧として管理し、常時一括で読む前提ではなく、必要なコマンドや文脈に応じて都度参照する

### 共通ルール（全プロジェクト共通）

| ファイル                               | 内容                                     |
| -------------------------------------- | ---------------------------------------- |
| `.claude/rules/common/security.md`     | セキュリティチェック、機密情報管理       |
| `.claude/rules/common/coding-style.md` | 不変性、ファイル構成、エラーハンドリング |
| `.claude/rules/common/testing.md`      | TDDワークフロー、80%カバレッジ要件       |
| `.claude/rules/common/git-workflow.md` | コミット形式、PRワークフロー             |
| `.claude/rules/common/agents.md`       | エージェント連携、使用タイミング         |
| `.claude/rules/common/patterns.md`     | Repository、APIレスポンスパターン        |
| `.claude/rules/common/performance.md`  | モデル選択、コンテキスト管理             |
| `.claude/rules/common/hooks.md`        | フックシステム                           |

### 言語固有ルール（プロジェクトで使用する言語のみ適用）

| ディレクトリ                | 対象                          |
| --------------------------- | ----------------------------- |
| `.claude/rules/flutter/`    | Dart 3 / Flutter パターン     |
| `.claude/rules/svelte/`     | Svelte 5 / SvelteKit パターン |
| `.claude/rules/typescript/` | TypeScript / Node.js パターン |

---

## 利用可能なエージェント

### 共通エージェント（言語非依存）

| エージェント         | 目的                              |
| -------------------- | --------------------------------- |
| planner              | 機能実装の計画                    |
| architect            | システム設計とアーキテクチャ      |
| tdd-guide            | テスト駆動開発                    |
| code-reviewer        | 品質/セキュリティのコードレビュー |
| security-reviewer    | セキュリティ脆弱性分析            |
| build-error-resolver | ビルドエラーの汎用解決            |
| e2e-runner           | E2Eテスト実行                     |
| refactor-cleaner     | デッドコードのクリーンアップ      |
| doc-updater          | ドキュメントの更新                |
| database-reviewer    | データベース設計・クエリレビュー  |

### 言語固有エージェント

| エージェント           | 目的                                  |
| ---------------------- | ------------------------------------- |
| flutter-build-resolver | Flutter ビルドエラー解決              |
| flutter-reviewer       | Flutter/Dart コードレビュー           |
| svelte-build-resolver  | Svelte ビルドエラー解決               |
| svelte-reviewer        | Svelte/SvelteKit コードレビュー       |
| svelte-file-editor     | Svelte コンポーネント作成・編集・検証 |

---

## コマンド一覧

コマンドとエージェント・ルール・スキルの関連は `.claude/commands/README.md` を参照。

---

## コードスタイル（共通）

- 不変性を優先 - オブジェクトや配列を決して変更しない
- 少数の大きなファイルよりも多数の小さなファイル
- 通常200-400行、ファイルごとに最大800行
- 関数は50行未満、ネストは4レベル以下

## Git（共通）

- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`, `perf:`, `ci:`
- コミット前に常にローカルでテスト
- 小さく焦点を絞ったコミット

## テスト（共通）

- TDD を基本とする: 最初にテストを書く
- ただし既存 Svelte 画面の軽微な UI 中心変更は `/svelte-implement` による通常フローを許容
- 通常フローでも局所検証と実装後レビューは必須
- 最低80%のカバレッジ
- 重要なフローにはユニット + 統合 + E2Eテスト

## プライバシー（共通）

- 機密情報を出力やログに含めない
- 共有前に出力をレビューし、すべての機密データを削除

---

## 成功指標

以下の場合に成功:

- すべてのテストが合格（80%以上のカバレッジ）
- セキュリティ脆弱性なし
- コードが読みやすく保守可能
- ユーザー要件を満たしている

---

## プロジェクト固有設定

**プロジェクト固有の設定は必ず `.claude/PROJECT.md` に記述してください。**

`.claude/PROJECT.md` に記載する内容:

- プロジェクト名・概要
- 使用技術スタック
- ディレクトリ構成
- ビルド・テスト・デプロイコマンド
- プロジェクト固有のアーキテクチャルール
- プロジェクト固有のセキュリティ要件
- 外部サービス連携情報

---

**哲学**: エージェント優先設計、並列実行、行動前に計画、コード前にテスト、常にセキュリティ
