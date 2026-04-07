import 'package:json_annotation/json_annotation.dart';

/// お土産カテゴリ Enhanced Enum
enum SouvenirCategory {
  sweets(value: 'sweets', label: 'お菓子・スイーツ'),
  craft(value: 'craft', label: '工芸品'),
  localFood(value: 'local_food', label: '地方食・食品'),
  accessory(value: 'accessory', label: 'アクセサリー・雑貨'),
  alcohol(value: 'alcohol', label: 'お酒・飲料'),
  other(value: 'other', label: 'その他');

  const SouvenirCategory({required this.value, required this.label});

  final String value;
  final String label;

  /// 文字列値からカテゴリを取得
  static SouvenirCategory fromString(String value) {
    return SouvenirCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SouvenirCategory: $value'),
    );
  }
}

/// JSON変換用コンバーター
class SouvenirCategoryConverter
    implements JsonConverter<SouvenirCategory, String> {
  const SouvenirCategoryConverter();

  @override
  SouvenirCategory fromJson(String json) => SouvenirCategory.fromString(json);

  @override
  String toJson(SouvenirCategory category) => category.value;
}
