---
name: flutter-testing
description: Flutter の unit test、widget test、integration test を書く・直すときに使う。実装全般には使わず、プロジェクト固有のレイヤー別テスト戦略は PROJECT.md を参照。
paths:
  - test/**/*.dart
  - integration_test/**/*.dart
---

# Flutter テスト（汎用）

Flutter + Dart でのテスト駆動開発と汎用テストパターン。

**プロジェクト固有のレイヤー別テスト戦略（テスト対象のレイヤー構成、各層のテスト方針）は PROJECT.md を参照してください。**

## いつ有効化するか

- テストを書く/修正するとき
- テストカバレッジの向上時
- lib/ 実装そのものではなく、テスト設計やテストコードの更新が主タスクのとき

## テスト環境

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  integration_test:
    sdk: flutter
```

## ユニットテスト (mocktail)

```dart
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
  });

  test('正常系: データを返す', () async {
    when(() => mockRepo.getById('1'))
        .thenAnswer((_) async => User(id: '1', name: 'Test'));
    final result = await mockRepo.getById('1');
    expect(result.name, equals('Test'));
    verify(() => mockRepo.getById('1')).called(1);
  });
}
```

## Widget テスト

```dart
testWidgets('ユーザー情報を表示する', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: UserCard(user: testUser))),
  );
  expect(find.text('Alice'), findsOneWidget);
});

testWidgets('バリデーションエラーを表示する', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginForm()));
  await tester.tap(find.text('送信'));
  await tester.pump();
  expect(find.text('必須項目です'), findsOneWidget);
});
```

## 統合テスト

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ログインフロー', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('email')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password')), 'pass');
    await tester.tap(find.text('ログイン'));
    await tester.pumpAndSettle();
    expect(find.text('ホーム'), findsOneWidget);
  });
}
```

## テストヘルパー

```dart
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {List<Override> overrides = const []}) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(home: Scaffold(body: widget)),
      ),
    );
  }
}
```

## 実行コマンド

テスト実行コマンドは PROJECT.md のビルド・テストコマンドセクションを参照。
