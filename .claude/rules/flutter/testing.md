---
paths:
  - "**/*.dart"
---

# Flutter テスト（汎用）

> [common/testing.md](../common/testing.md) を拡張。
> プロジェクト固有のレイヤー別テスト戦略は **PROJECT.md** を参照してください。

## ユニットテスト

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockClient;
  late UserRepositoryImpl repo;

  setUp(() {
    mockClient = MockApiClient();
    repo = UserRepositoryImpl(mockClient);
  });

  group('findById', () {
    test('ユーザーを返す', () async {
      when(() => mockClient.get('/users/1'))
          .thenAnswer((_) async => Response(data: {'id': '1', 'name': 'Test'}));

      final user = await repo.findById('1');
      expect(user?.name, equals('Test'));
    });

    test('見つからない場合 null を返す', () async {
      when(() => mockClient.get('/users/999'))
          .thenThrow(DioException(requestOptions: RequestOptions(), response: Response(statusCode: 404)));

      final user = await repo.findById('999');
      expect(user, isNull);
    });
  });
}
```

## Widget テスト

```dart
testWidgets('カウンターがインクリメントされる', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: CounterScreen()));

  expect(find.text('0'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  expect(find.text('1'), findsOneWidget);
});
```

## 統合テスト

```dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ログインからダッシュボードまで', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('email')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password')), 'password123');
    await tester.tap(find.text('ログイン'));
    await tester.pumpAndSettle();

    expect(find.text('ダッシュボード'), findsOneWidget);
  });
}
```

## Agent サポート

- **flutter-reviewer** - Flutter コードレビュー
- **flutter-build-resolver** - ビルドエラー解決
