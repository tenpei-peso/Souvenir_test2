import 'package:flutter_test/flutter_test.dart';
import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/domain/entities/souvenir_category.dart';

void main() {
  group('MySouvenir', () {
    test('factory constructor で生成できる', () {
      final now = DateTime.now();
      final souvenir = MySouvenir(
        id: '1',
        name: 'テストお土産',
        category: SouvenirCategory.sweets,
        description: 'これはテストです',
        price: 1000,
        imageUrls: const ['https://example.com/image.jpg'],
        tags: const ['popular'],
        purchaseLocation: '東京',
        createdAt: now,
        updatedAt: now,
      );

      expect(souvenir.id, equals('1'));
      expect(souvenir.name, equals('テストお土産'));
      expect(souvenir.category, equals(SouvenirCategory.sweets));
      expect(souvenir.price, equals(1000));
      expect(souvenir.imageUrls.length, equals(1));
      expect(souvenir.tags.length, equals(1));
    });

    test('displayInfo computed property', () {
      final souvenir = MySouvenir(
        id: '1',
        name: '羊羹',
        category: SouvenirCategory.sweets,
        description: '東京の有名な羊羹',
        price: 2500,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(
        souvenir.displayInfo,
        equals('羊羹（2500円） - お菓子・スイーツ'),
      );
    });

    test('daysSinceCreated computed property', () {
      final now = DateTime.now();
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final souvenir = MySouvenir(
        id: '1',
        name: 'テスト',
        category: SouvenirCategory.other,
        description: 'desc',
        price: 100,
        createdAt: threeDaysAgo,
        updatedAt: now,
      );

      expect(souvenir.daysSinceCreated, greaterThanOrEqualTo(2));
      expect(souvenir.daysSinceCreated, lessThanOrEqualTo(4));
    });

    test('デフォルト値が適用される', () {
      final now = DateTime.now();
      final souvenir = MySouvenir(
        id: '1',
        name: 'テスト',
        category: SouvenirCategory.craft,
        description: 'desc',
        price: 500,
        createdAt: now,
        updatedAt: now,
      );

      expect(souvenir.imageUrls, isEmpty);
      expect(souvenir.tags, isEmpty);
      expect(souvenir.purchaseLocation, isNull);
    });

    test('copyWith で不変更新ができる', () {
      final now = DateTime.now();
      final original = MySouvenir(
        id: '1',
        name: '元のお土産',
        category: SouvenirCategory.sweets,
        description: '説明',
        price: 1000,
        createdAt: now,
        updatedAt: now,
      );

      final updated = original.copyWith(
        name: '更新されたお土産',
        price: 2000,
      );

      // 元のオブジェクトは変更されない
      expect(original.name, equals('元のお土産'));
      expect(original.price, equals(1000));

      // 新しいオブジェクトが生成される
      expect(updated.name, equals('更新されたお土産'));
      expect(updated.price, equals(2000));
      expect(updated.id, equals(original.id));
      expect(updated.category, equals(original.category));
    });
  });
}
