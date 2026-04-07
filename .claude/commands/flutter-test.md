---
description: Flutter のテスト駆動開発 (TDD) ワークフロー。FVM 経由で flutter_test + mocktail によるユニット/Widget テスト、integration_test による統合テストを実行し、80%以上のカバレッジを確認します。
agents: [tdd-guide, flutter-reviewer]
rules: [flutter/testing.md, common/testing.md]
skills: [flutter-testing, flutter-patterns, tdd-workflow]
---

# Flutter TDD コマンド

Flutter のテスト駆動開発手法を適用します。

## 機能

1. **モデル/インターフェース定義**: データ構造と抽象クラスを最初に定義
2. **テストの作成**: flutter_test + mocktail でテストケースを作成 (RED)
3. **テストの実行**: テストが正しい理由で失敗することを確認
4. **コードの実装**: テストをパスするための最小限のコードを記述 (GREEN)
5. **リファクタリング**: テストをグリーンに保ちながら改善
6. **カバレッジの確認**: 80%以上のカバレッジを保証

## 使用するタイミング

- 新しい Widget/機能の作成時
- Repository/Service の実装時
- バグ修正時（失敗するテストを最初に作成）
- リファクタリング時

## TDD サイクル

```
RED     → 失敗するテストを作成
GREEN   → テストをパスするための最小限のコードを実装
REFACTOR → コードを改善、テストはグリーンを保持
REPEAT  → 次のテストケースへ
```

## セッション例

```text
User: /flutter-test ユーザーのメールアドレスを検証する関数が必要です

Agent:
# TDD セッション: メールバリデーター

## ステップ 1: インターフェース定義

// lib/core/validators.dart
String? validateEmail(String? value) {
  throw UnimplementedError();
}

## ステップ 2: テスト作成 (RED)

// test/core/validators_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/core/validators.dart';

void main() {
  group('validateEmail', () {
    test('有効なメールは null を返す', () {
      expect(validateEmail('test@example.com'), isNull);
    });

    test('空文字はエラーを返す', () {
      expect(validateEmail(''), isNotNull);
    });

    test('null はエラーを返す', () {
      expect(validateEmail(null), isNotNull);
    });

    test('不正な形式はエラーを返す', () {
      expect(validateEmail('invalid'), isNotNull);
      expect(validateEmail('@example.com'), isNotNull);
      expect(validateEmail('test@'), isNotNull);
    });
  });
}

## ステップ 3: テスト実行 → FAIL

$ fvm flutter test test/core/validators_test.dart
FAIL: UnimplementedError

## ステップ 4: 実装 (GREEN)

// lib/core/validators.dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'メールアドレスは必須です';
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) return '有効なメールアドレスを入力してください';
  return null;
}

## ステップ 5: テスト実行 → PASS

## ステップ 6: カバレッジ確認
$ fvm flutter test --coverage
Coverage: 100%
```

## 実行コマンド

```bash
# ユニット & Widget テスト
fvm flutter test

# カバレッジ付き
fvm flutter test --coverage

# 特定テスト
fvm flutter test test/core/validators_test.dart

# 統合テスト
fvm flutter test integration_test/

# カバレッジレポート生成
genhtml coverage/lcov.info -o coverage/html
```

## 他のコマンドとの統合

- まず `/plan` で何を構築するかを計画
- `/flutter-test` でテスト付きで実装
- `/flutter-build` でビルドエラー発生時に修正
- `/flutter-review` で実装をレビュー
- `/test-coverage` でカバレッジを検証

## 関連エージェント

このコマンドは以下の場所にある `tdd-guide` エージェントを呼び出します:
`~/.claude/agents/tdd-guide.md`

また、以下のスキルを参照できます:

- `~/.claude/skills/flutter-testing/` - Flutter テスト戦略
- `~/.claude/skills/flutter-patterns/` - Flutter / Dart 3 パターン
- `~/.claude/skills/tdd-workflow/` - TDD ワークフロー
