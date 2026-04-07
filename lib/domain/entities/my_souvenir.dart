import 'package:freezed_annotation/freezed_annotation.dart';
import 'souvenir_category.dart';

part 'my_souvenir.freezed.dart';
part 'my_souvenir.g.dart';

/// ユーザー登録のおすすめお土産 Entity
@freezed
class MySouvenir with _$MySouvenir {
  const factory MySouvenir({
    required String id,
    required String name,
    @SouvenirCategoryConverter() required SouvenirCategory category,
    required String description,
    required int price,
    @Default(<String>[]) List<String> imageUrls,
    @Default(<String>[]) List<String> tags,
    String? purchaseLocation,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MySouvenir;

  const MySouvenir._();

  /// お土産の詳細情報を文字列化
  String get displayInfo {
    return '$name（$price円） - ${category.label}';
  }

  /// 作成からの経過時間（日数）
  int get daysSinceCreated {
    return DateTime.now().difference(createdAt).inDays;
  }

  factory MySouvenir.fromJson(Map<String, dynamic> json) =>
      _$MySouvenirFromJson(json);
}
