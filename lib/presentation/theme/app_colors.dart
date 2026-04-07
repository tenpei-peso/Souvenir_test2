import 'package:flutter/material.dart';

/// アプリケーションカラー定義
class AppColors extends ThemeExtension<AppColors> {
  AppColors({
    this.primary = const Color(0xFF6200EE),
    this.secondary = const Color(0xFF03DAC6),
    this.error = const Color(0xFFCF6679),
    this.success = const Color(0xFF4CAF50),
    this.warning = const Color(0xFFFFC107),
    this.background = const Color(0xFFFFFFFF),
    this.surface = const Color(0xFFF5F5F5),
    this.textPrimary = const Color(0xFF212121),
    this.textSecondary = const Color(0xFF757575),
    this.border = const Color(0xFFE0E0E0),
  });

  final Color primary;
  final Color secondary;
  final Color error;
  final Color success;
  final Color warning;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? secondary,
    Color? error,
    Color? success,
    Color? warning,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      error: Color.lerp(error, other.error, t) ?? error,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      border: Color.lerp(border, other.border, t) ?? border,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get appColors {
    return Theme.of(this).extension<AppColors>() ?? AppColors();
  }
}
