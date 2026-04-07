import 'package:flutter_test/flutter_test.dart';
import 'package:test2/domain/entities/souvenir_category.dart';

void main() {
  group('SouvenirCategory', () {
    test('fromString正常系 - sweets', () {
      final category = SouvenirCategory.fromString('sweets');
      expect(category, equals(SouvenirCategory.sweets));
      expect(category.label, equals('お菓子・スイーツ'));
    });

    test('fromString正常系 - local_food', () {
      final category = SouvenirCategory.fromString('local_food');
      expect(category, equals(SouvenirCategory.localFood));
    });

    test('fromString異常系 - 無効な値', () {
      expect(
        () => SouvenirCategory.fromString('invalid'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('value属性が正しく設定されている', () {
      expect(SouvenirCategory.sweets.value, equals('sweets'));
      expect(SouvenirCategory.craft.value, equals('craft'));
      expect(SouvenirCategory.localFood.value, equals('local_food'));
      expect(SouvenirCategory.accessory.value, equals('accessory'));
      expect(SouvenirCategory.alcohol.value, equals('alcohol'));
      expect(SouvenirCategory.other.value, equals('other'));
    });

    test('label属性が正しく設定されている', () {
      expect(SouvenirCategory.sweets.label, equals('お菓子・スイーツ'));
      expect(SouvenirCategory.craft.label, equals('工芸品'));
      expect(SouvenirCategory.localFood.label, equals('地方食・食品'));
      expect(SouvenirCategory.accessory.label, equals('アクセサリー・雑貨'));
      expect(SouvenirCategory.alcohol.label, equals('お酒・飲料'));
      expect(SouvenirCategory.other.label, equals('その他'));
    });
  });

  group('SouvenirCategoryConverter', () {
    test('fromJson - 文字列をEnumに変換', () {
      const converter = SouvenirCategoryConverter();
      final result = converter.fromJson('craft');
      expect(result, equals(SouvenirCategory.craft));
    });

    test('toJson - EnumをJsonに変換', () {
      const converter = SouvenirCategoryConverter();
      final result = converter.toJson(SouvenirCategory.localFood);
      expect(result, equals('local_food'));
    });

    test('round-trip変換', () {
      const converter = SouvenirCategoryConverter();
      final original = SouvenirCategory.accessory;
      final json = converter.toJson(original);
      final restored = converter.fromJson(json);
      expect(restored, equals(original));
    });
  });
}
