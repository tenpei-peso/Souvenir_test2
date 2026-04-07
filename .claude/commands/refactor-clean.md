---
description: デッドコードを安全に特定して削除します。refactor-cleaner エージェントを呼び出します。
agents: [refactor-cleaner]
rules: [common/coding-style.md]
---

# Refactor Clean

テスト検証でデッドコードを安全に特定して削除します:

1. デッドコード分析ツールを実行（言語に応じて選択）:
   - Flutter: `fvm dart analyze`, `fvm dart fix --dry-run`
   - TypeScript: `knip`, `ts-prune`, `depcheck`
   - Svelte: `knip`, `eslint`

2. .reports/dead-code-analysis.mdに包括的なレポートを生成

3. 発見を重要度別に分類:
   - SAFE: テストファイル、未使用のユーティリティ
   - CAUTION: APIルート、コンポーネント
   - DANGER: 設定ファイル、メインエントリーポイント

4. 安全な削除のみを提案

5. 各削除の前に:
   - 完全なテストスイートを実行
   - テストが合格することを確認
   - 変更を適用
   - テストを再実行
   - テストが失敗した場合はロールバック

6. クリーンアップされたアイテムのサマリーを表示

まずテストを実行せずにコードを削除しないでください!
