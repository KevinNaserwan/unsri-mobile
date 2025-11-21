import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
class Responsive {
  Responsive._();

  /// Get MediaQuery from context
  static MediaQueryData mediaQuery(BuildContext context) {
    return MediaQuery.of(context);
  }

  /// Get screen width
  static double width(BuildContext context) {
    return mediaQuery(context).size.width;
  }

  /// Get screen height
  static double height(BuildContext context) {
    return mediaQuery(context).size.height;
  }

  /// Get screen aspect ratio
  static double aspectRatio(BuildContext context) {
    return mediaQuery(context).size.aspectRatio;
  }

  /// Get padding based on screen size
  static EdgeInsets padding(BuildContext context) {
    final width = Responsive.width(context);
    if (width < 600) {
      // Mobile
      return const EdgeInsets.all(16.0);
    } else if (width < 900) {
      // Tablet
      return const EdgeInsets.all(24.0);
    } else {
      // Desktop
      return const EdgeInsets.all(32.0);
    }
  }

  /// Get horizontal padding based on screen size (Design System: 16px for mobile)
  static double horizontalPadding(BuildContext context) {
    final width = Responsive.width(context);
    if (width < 360) {
      // Small phones (iPhone SE, etc.)
      return 12.0;
    } else if (width < 600) {
      // Regular phones
      return 16.0; // Design system: 16px for mobile
    } else if (width < 900) {
      // Tablet
      return 24.0; // 24px for tablet
    } else {
      // Desktop
      return 32.0; // 32px for desktop (multiple of 8)
    }
  }

  /// Get vertical padding based on screen size
  static double verticalPadding(BuildContext context) {
    final height = Responsive.height(context);
    if (height < 600) {
      return 16.0;
    } else if (height < 900) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, double baseSize) {
    final width = Responsive.width(context);
    if (width < 360) {
      // Small phones - reduce by 5%
      return baseSize * 0.95;
    } else if (width < 600) {
      // Regular phones - use base size
      return baseSize;
    } else if (width < 900) {
      // Tablet - increase by 10%
      return baseSize * 1.1;
    } else {
      // Desktop - increase by 20%
      return baseSize * 1.2;
    }
  }

  /// Get responsive spacing
  static double spacing(BuildContext context, double baseSpacing) {
    final width = Responsive.width(context);
    if (width < 360) {
      // Small phones - reduce spacing slightly
      return baseSpacing * 0.9;
    } else if (width < 600) {
      // Regular phones
      return baseSpacing;
    } else if (width < 900) {
      // Tablet
      return baseSpacing * 1.2;
    } else {
      // Desktop
      return baseSpacing * 1.5;
    }
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w >= 600 && w < 900;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return width(context) >= 900;
  }

  /// Get responsive width percentage
  static double widthPercent(BuildContext context, double percent) {
    return width(context) * (percent / 100);
  }

  /// Get responsive height percentage
  static double heightPercent(BuildContext context, double percent) {
    return height(context) * (percent / 100);
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, double baseSize) {
    final width = Responsive.width(context);
    if (width < 600) {
      return baseSize;
    } else if (width < 900) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.5;
    }
  }

  /// Get responsive border radius
  static double borderRadius(BuildContext context, double baseRadius) {
    final width = Responsive.width(context);
    if (width < 600) {
      return baseRadius;
    } else if (width < 900) {
      return baseRadius * 1.1;
    } else {
      return baseRadius * 1.2;
    }
  }

  /// Get responsive button height
  static double buttonHeight(BuildContext context) {
    final width = Responsive.width(context);
    if (width < 600) {
      return 48.0;
    } else if (width < 900) {
      return 52.0;
    } else {
      return 56.0;
    }
  }

  /// Get responsive logo size
  static double logoSize(
    BuildContext context, {
    double mobile = 80,
    double tablet = 100,
    double desktop = 120,
  }) {
    final width = Responsive.width(context);
    if (width < 360) {
      // Small phones
      return mobile * 0.85; // 68px
    } else if (width < 600) {
      // Regular phones
      return mobile;
    } else if (width < 900) {
      // Tablet
      return tablet;
    } else {
      // Desktop
      return desktop;
    }
  }

  /// Get responsive image size
  static double imageSize(
    BuildContext context, {
    double mobile = 120,
    double tablet = 150,
    double desktop = 180,
  }) {
    final width = Responsive.width(context);
    if (width < 360) {
      // Small phones
      return mobile * 0.85; // ~102px
    } else if (width < 600) {
      // Regular phones
      return mobile;
    } else if (width < 900) {
      // Tablet
      return tablet;
    } else {
      // Desktop
      return desktop;
    }
  }

  /// Get responsive top padding based on screen height
  static double topPadding(BuildContext context) {
    final height = Responsive.height(context);
    if (height < 700) {
      // Small height phones
      return 8.0;
    } else if (height < 800) {
      // Medium height phones
      return 12.0;
    } else if (height < 900) {
      // Large phones
      return 16.0;
    } else {
      // Very large phones/tablets
      return 20.0;
    }
  }

  /// Get responsive decoration top position
  static double decorationTop(BuildContext context) {
    final height = Responsive.height(context);
    if (height < 700) {
      return 25.0;
    } else if (height < 800) {
      return 35.0;
    } else if (height < 900) {
      return 45.0;
    } else {
      return 55.0;
    }
  }
}
