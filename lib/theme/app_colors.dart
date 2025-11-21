import 'package:flutter/material.dart';

/// App Color System
///
/// Provides color palettes with shades 100-900 for:
/// - Primary (FCAE18)
/// - Secondary (394D8D)
/// - Success (98CE04)
/// - Info (1F9FF4)
/// - Warning (FFAB1C)
/// - Danger (FF5C49)
/// - Text (222222)
class AppColors {
  AppColors._();

  // Base colors (500 shade)
  static const Color _primaryBase = Color(0xFFFCAE18);
  static const Color _secondaryBase = Color(0xFF394D8D);
  static const Color _successBase = Color(0xFF98CE04);
  static const Color _infoBase = Color(0xFF1F9FF4);
  static const Color _warningBase = Color(0xFFFFAB1C);
  static const Color _dangerBase = Color(0xFFFF5C49);
  static const Color _textBase = Color(0xFF222222);

  // Primary Color Palette (FCAE18)
  static const Color primary100 = Color(0xFFFFF4E0);
  static const Color primary200 = Color(0xFFFFE4B3);
  static const Color primary300 = Color(0xFFFFD480);
  static const Color primary400 = Color(0xFFFFC14D);
  static const Color primary500 = _primaryBase;
  static const Color primary600 = Color(0xFFB56F0C);
  static const Color primary700 = Color(0xFFCC8C12);
  static const Color primary800 = Color(0xFFB37A0F);
  static const Color primary900 = Color(0xFF99690C);

  // Secondary Color Palette (394D8D)
  static const Color secondary100 = Color(0xFFE8EBF3);
  static const Color secondary200 = Color(0xFFD1D7E7);
  static const Color secondary300 = Color(0xFFBAC3DB);
  static const Color secondary400 = Color(0xFFA3AFCF);
  static const Color secondary500 = _secondaryBase;
  static const Color secondary600 = Color(0xFF33457F);
  static const Color secondary700 = Color(0xFF2D3D71);
  static const Color secondary800 = Color(0xFF273563);
  static const Color secondary900 = Color(0xFF212D55);

  // Success Color Palette (98CE04)
  static const Color success100 = Color(0xFFF0F9D0);
  static const Color success200 = Color(0xFFE1F3A1);
  static const Color success300 = Color(0xFFD2ED72);
  static const Color success400 = Color(0xFFC3E743);
  static const Color success500 = _successBase;
  static const Color success600 = Color(0xFF89B903);
  static const Color success700 = Color(0xFF7AA402);
  static const Color success800 = Color(0xFF6B8F02);
  static const Color success900 = Color(0xFF5C7A01);

  // Info Color Palette (1F9FF4)
  static const Color info100 = Color(0xFFD6EDFD);
  static const Color info200 = Color(0xFFADDBFB);
  static const Color info300 = Color(0xFF84C9F9);
  static const Color info400 = Color(0xFF5BB7F7);
  static const Color info500 = _infoBase;
  static const Color info600 = Color(0xFF1C8FDB);
  static const Color info700 = Color(0xFF197FC2);
  static const Color info800 = Color(0xFF166FA9);
  static const Color info900 = Color(0xFF135F90);

  // Warning Color Palette (FFAB1C)
  static const Color warning100 = Color(0xFFFFF0D6);
  static const Color warning200 = Color(0xFFFFE1AD);
  static const Color warning300 = Color(0xFFFFD284);
  static const Color warning400 = Color(0xFFFFC35B);
  static const Color warning500 = _warningBase;
  static const Color warning600 = Color(0xFFE69A19);
  static const Color warning700 = Color(0xFFCC8916);
  static const Color warning800 = Color(0xFFB37813);
  static const Color warning900 = Color(0xFF996710);

  // Danger Color Palette (FF5C49)
  static const Color danger100 = Color(0xFFFFE5E2);
  static const Color danger200 = Color(0xFFFFCBC5);
  static const Color danger300 = Color(0xFFFFB1A8);
  static const Color danger400 = Color(0xFFFF978B);
  static const Color danger500 = _dangerBase;
  static const Color danger600 = Color(0xFFE65342);
  static const Color danger700 = Color(0xFFCC4A3B);
  static const Color danger800 = Color(0xFFB34134);
  static const Color danger900 = Color(0xFF99382D);

  // Text Color Palette (222222)
  static const Color text0 = Color(0xFFFFFFFF);
  static const Color text100 = Color(0xFFE5E5E5);
  static const Color text200 = Color(0xFFCCCCCC);
  static const Color text300 = Color(0xFFB3B3B3);
  static const Color text400 = Color(0xFF999999);
  static const Color text500 = _textBase;
  static const Color text600 = Color(0xFF1F1F1F);
  static const Color text700 = Color(0xFF1C1C1C);
  static const Color text800 = Color(0xFF191919);
  static const Color text900 = Color(0xFF161616);

  /// Get primary color by shade (100-900)
  static Color primary(int shade) {
    switch (shade) {
      case 100:
        return primary100;
      case 200:
        return primary200;
      case 300:
        return primary300;
      case 400:
        return primary400;
      case 500:
        return primary500;
      case 600:
        return primary600;
      case 700:
        return primary700;
      case 800:
        return primary800;
      case 900:
        return primary900;
      default:
        return primary500;
    }
  }

  /// Get secondary color by shade (100-900)
  static Color secondary(int shade) {
    switch (shade) {
      case 100:
        return secondary100;
      case 200:
        return secondary200;
      case 300:
        return secondary300;
      case 400:
        return secondary400;
      case 500:
        return secondary500;
      case 600:
        return secondary600;
      case 700:
        return secondary700;
      case 800:
        return secondary800;
      case 900:
        return secondary900;
      default:
        return secondary500;
    }
  }

  /// Get success color by shade (100-900)
  static Color success(int shade) {
    switch (shade) {
      case 100:
        return success100;
      case 200:
        return success200;
      case 300:
        return success300;
      case 400:
        return success400;
      case 500:
        return success500;
      case 600:
        return success600;
      case 700:
        return success700;
      case 800:
        return success800;
      case 900:
        return success900;
      default:
        return success500;
    }
  }

  /// Get info color by shade (100-900)
  static Color info(int shade) {
    switch (shade) {
      case 100:
        return info100;
      case 200:
        return info200;
      case 300:
        return info300;
      case 400:
        return info400;
      case 500:
        return info500;
      case 600:
        return info600;
      case 700:
        return info700;
      case 800:
        return info800;
      case 900:
        return info900;
      default:
        return info500;
    }
  }

  /// Get warning color by shade (100-900)
  static Color warning(int shade) {
    switch (shade) {
      case 100:
        return warning100;
      case 200:
        return warning200;
      case 300:
        return warning300;
      case 400:
        return warning400;
      case 500:
        return warning500;
      case 600:
        return warning600;
      case 700:
        return warning700;
      case 800:
        return warning800;
      case 900:
        return warning900;
      default:
        return warning500;
    }
  }

  /// Get danger color by shade (100-900)
  static Color danger(int shade) {
    switch (shade) {
      case 100:
        return danger100;
      case 200:
        return danger200;
      case 300:
        return danger300;
      case 400:
        return danger400;
      case 500:
        return danger500;
      case 600:
        return danger600;
      case 700:
        return danger700;
      case 800:
        return danger800;
      case 900:
        return danger900;
      default:
        return danger500;
    }
  }

  /// Get text color by shade (0, 100-900)
  static Color text(int shade) {
    switch (shade) {
      case 0:
        return text0;
      case 100:
        return text100;
      case 200:
        return text200;
      case 300:
        return text300;
      case 400:
        return text400;
      case 500:
        return text500;
      case 600:
        return text600;
      case 700:
        return text700;
      case 800:
        return text800;
      case 900:
        return text900;
      default:
        return text500;
    }
  }

  /// Material Design 3 ColorScheme using Primary as seed
  static ColorScheme get lightColorScheme => ColorScheme.light(
    primary: primary500,
    onPrimary: Colors.white,
    primaryContainer: primary100,
    onPrimaryContainer: primary900,
    secondary: secondary500,
    onSecondary: Colors.white,
    secondaryContainer: secondary100,
    onSecondaryContainer: secondary900,
    tertiary: info500,
    onTertiary: Colors.white,
    tertiaryContainer: info100,
    onTertiaryContainer: info900,
    error: danger500,
    onError: Colors.white,
    errorContainer: danger100,
    onErrorContainer: danger900,
    surface: Colors.white,
    onSurface: text500,
    surfaceContainerHighest: text100,
    onSurfaceVariant: text400,
    outline: text300,
    outlineVariant: text200,
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: text900,
    onInverseSurface: text0,
    inversePrimary: primary300,
  );

  /// Material Design 3 ColorScheme for dark theme
  static ColorScheme get darkColorScheme => ColorScheme.dark(
    primary: primary400,
    onPrimary: primary900,
    primaryContainer: primary800,
    onPrimaryContainer: primary100,
    secondary: secondary400,
    onSecondary: secondary900,
    secondaryContainer: secondary800,
    onSecondaryContainer: secondary100,
    tertiary: info400,
    onTertiary: info900,
    tertiaryContainer: info800,
    onTertiaryContainer: info100,
    error: danger400,
    onError: danger900,
    errorContainer: danger800,
    onErrorContainer: danger100,
    surface: text900,
    onSurface: text100,
    surfaceContainerHighest: text800,
    onSurfaceVariant: text300,
    outline: text600,
    outlineVariant: text700,
    shadow: Colors.black87,
    scrim: Colors.black87,
    inverseSurface: text100,
    onInverseSurface: text900,
    inversePrimary: primary600,
  );
}
