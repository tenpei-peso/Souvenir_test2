# スキル

このディレクトリには、このプロジェクトで利用する Claude Code の project skills を配置します。

## 運用方針

- `description` には「何をする skill か」だけでなく「いつ使うか」を具体的に書きます。
- 自動で走ってほしくない手動ワークフローは `disable-model-invocation: true` を付けます。
- 範囲が広い skill は対象技術、対象ファイル、除外条件を `description` や `paths` で制限します。
- プロジェクト固有の実装ルールは skill ではなく [PROJECT.md](../PROJECT.md) を正とします。

## 現在の skill 一覧

### 自動呼び出しされる skill

- `flutter-patterns/` - `lib/**/*.dart` の実装時に使う Flutter/Dart パターン
- `flutter-testing/` - `test/**/*.dart` と `integration_test/**/*.dart` のテスト作業で使う Flutter テストパターン
- `backend-patterns/` - `functions/**` のサーバー側コードで使うバックエンド実装パターン
- `postgres-patterns/` - SQL、migrations、RLS、クエリ性能調査で使う PostgreSQL パターン
- `security-review/` - 認証、認可、シークレット、支払い、公開 API など高リスク変更時のセキュリティレビュー

### 手動で呼び出す skill

- `configure-ecc/` - ECC のインストール、再構成、修復を行う対話型インストーラー
- `security-scan/` - `.claude` 設定を AgentShield で監査する手動スキャン
- `strategic-compact/` - `/compact` の運用方針を決める手動ガイド
- `tdd-workflow/` - TDD を明示したときだけ使う手動ワークフロー
- `verification-loop/` - 実装後のビルド、lint、テスト、差分レビューをまとめる手動チェックリスト

## スキル追加時のチェック

1. 自動呼び出しで問題ないかを先に決める。
2. 手動専用なら `disable-model-invocation: true` を付ける。
3. `description` の先頭に主要なユースケースを書く。
4. 必要なら `paths` で対象ディレクトリや拡張子を絞る。
5. 他の skill、agent、command と責務が重複しないか確認する。

## テンプレート

```markdown
---
name: your-skill-name
description: 何をする skill か。いつ使うか。必要なら何を対象外にするか。
---

# Skill Title

この skill が有効な場面と、従うべき手順や参照先を書く。
```
