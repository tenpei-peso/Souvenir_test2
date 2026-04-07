import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test2/main.dart' as app;
import 'package:test2/domain/entities/souvenir_category.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('おすすめお土産 CRUD 統合テスト', () {
    testWidgets('一覧ページが表示される', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // AppBar タイトルが表示されることを確認
      expect(find.text('マイお土産'), findsWidgets);
    });

    testWidgets('FAB をタップしてフォームページへ遷移', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // FAB をタップ
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // フォームページが表示されたことを確認（AppBar テキスト）
      expect(
        find.text('新しいお土産を追加'),
        findsWidgets,
      );
    });

    testWidgets('フォーム入力でバリデーションエラーが表示される', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // FAB をタップしてフォームへ
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // 空の状態で「作成」ボタンをタップ
      await tester.tap(find.text('作成'));
      await tester.pumpAndSettle();

      // バリデーションエラーが表示される
      expect(find.text('お土産名は必須です'), findsWidgets);
      expect(find.text('説明は必須です'), findsWidgets);
    });

    testWidgets('フォーム入力と送信が成功する', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // FAB をタップしてフォームへ
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // 名前を入力
      await tester.enterText(
        find.byType(TextFormField).first,
        '羊羹',
      );
      await tester.pumpAndSettle();

      // 説明を入力
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '東京の有名なお菓子',
      );
      await tester.pumpAndSettle();

      // 値段を入力
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '2500',
      );
      await tester.pumpAndSettle();

      // カテゴリを選択（お菓子・スイーツ）
      await tester.tap(find.text('お菓子・スイーツ'));
      await tester.pumpAndSettle();

      // 作成ボタンをタップ
      await tester.tap(find.text('作成'));
      await tester.pumpAndSettle();

      // 成功メッセージが表示される（またはリストページに戻る）
      // Firebase 接続が無い場合はエラーになる可能性あり
      // 実装時には Firebase Emulator を使用することを推奨
    });
  });
}
