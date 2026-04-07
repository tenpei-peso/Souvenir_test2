import 'package:flutter/material.dart';
import 'package:test2/domain/entities/souvenir_category.dart';

/// SouvenirCategory の UI 表示拡張メソッド
extension SouvenirCategoryUIExtension on SouvenirCategory {
  /// カテゴリアイコン
  IconData get icon {
    return switch (this) {
      SouvenirCategory.sweets => Icons.cake,
      SouvenirCategory.craft => Icons.palette,
      SouvenirCategory.localFood => Icons.local_dining,
      SouvenirCategory.accessory => Icons.shopping_bag,
      SouvenirCategory.alcohol => Icons.local_bar,
      SouvenirCategory.other => Icons.category,
    };
  }

  /// カテゴリカラー
  Color get color {
    return switch (this) {
      SouvenirCategory.sweets => Colors.pink,
      SouvenirCategory.craft => Colors.brown,
      SouvenirCategory.localFood => Colors.orange,
      SouvenirCategory.accessory => Colors.purple,
      SouvenirCategory.alcohol => Colors.amber,
      SouvenirCategory.other => Colors.grey,
    };
  }

  /// カテゴリバッジ背景色
  Color get badgeColor {
    return color.withValues(alpha: 0.2);
  }

  /// カテゴリバッジテキスト色
  Color get badgeTextColor {
    return color;
  }
}
