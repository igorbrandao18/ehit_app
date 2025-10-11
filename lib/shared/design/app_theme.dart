// shared/design/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'design_tokens.dart';

/// Tema consolidado do app ÊHIT
/// Elimina duplicações entre app_theme.dart, app_colors.dart, app_text_styles.dart, etc.
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryRed,
        secondary: AppColors.accentYellow,
        surface: AppColors.backgroundCard,
        background: AppColors.backgroundDark,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimary,
        elevation: DesignTokens.elevationNone,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.backgroundCard,
        elevation: DesignTokens.elevationMD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cardBorderRadius),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.textPrimary,
          textStyle: AppTextStyles.buttonText,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.buttonPadding,
            vertical: DesignTokens.spaceLG,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.buttonBorderRadius),
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      
      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.primaryRed),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundCard,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
      ),
      
      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimary,
        iconColor: AppColors.textSecondary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceLG,
          vertical: DesignTokens.spaceSM,
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.textTertiary,
        thickness: DesignTokens.listDividerHeight,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundCard,
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.chipRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.chipPadding,
          vertical: DesignTokens.spaceXS,
        ),
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.backgroundCard,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.snackbarRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryRed,
        linearTrackColor: AppColors.backgroundCard,
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryRed;
          }
          return AppColors.textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryRed.withOpacity(DesignTokens.opacitySubtle);
          }
          return AppColors.backgroundCard;
        }),
      ),
      
      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primaryRed,
        inactiveTrackColor: AppColors.backgroundCard,
        thumbColor: AppColors.primaryRed,
        overlayColor: AppColors.primaryRed,
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.backgroundCard,
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.modalRadius),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.bottomSheetRadius),
          ),
        ),
      ),
      
      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(DesignTokens.tooltipRadius),
        ),
        textStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
        padding: const EdgeInsets.all(DesignTokens.tooltipPadding),
      ),
    );
  }
  
  // Light theme (if needed in the future)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryRed,
        secondary: AppColors.accentYellow,
        surface: Colors.white,
        background: Colors.white,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      ),
      
      // Similar theme configurations for light mode...
      // (Implement as needed)
    );
  }
}
