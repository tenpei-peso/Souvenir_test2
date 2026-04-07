import 'package:flutter/material.dart';

/// アプリケーションテキストスタイル定義
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  AppTextStyles({
    this.headingLarge = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.headingMedium = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.headingSmall = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      height: 1.3,
    ),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
  });

  final TextStyle headingLarge;
  final TextStyle headingMedium;
  final TextStyle headingSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;

  @override
  ThemeExtension<AppTextStyles> copyWith({
    TextStyle? headingLarge,
    TextStyle? headingMedium,
    TextStyle? headingSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
  }) {
    return AppTextStyles(
      headingLarge: headingLarge ?? this.headingLarge,
      headingMedium: headingMedium ?? this.headingMedium,
      headingSmall: headingSmall ?? this.headingSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
    );
  }

  @override
  ThemeExtension<AppTextStyles> lerp(
    ThemeExtension<AppTextStyles>? other,
    double t,
  ) {
    if (other is! AppTextStyles) {
      return this;
    }
    return AppTextStyles(
      headingLarge:
          TextStyle.lerp(headingLarge, other.headingLarge, t) ?? headingLarge,
      headingMedium:
          TextStyle.lerp(headingMedium, other.headingMedium, t) ??
          headingMedium,
      headingSmall:
          TextStyle.lerp(headingSmall, other.headingSmall, t) ?? headingSmall,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t) ?? bodyLarge,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t) ?? bodyMedium,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t) ?? bodySmall,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t) ?? labelLarge,
      labelMedium:
          TextStyle.lerp(labelMedium, other.labelMedium, t) ?? labelMedium,
    );
  }
}
