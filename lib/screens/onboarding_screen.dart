import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // SF Compact Medium style (using SFProDisplay Medium as substitute)
  static TextStyle _headingStyle(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500, // Medium (closest to 556)
    fontSize: Responsive.fontSize(context, 24),
    height: 1.5, // 150% line height
    letterSpacing: 0.5,
    color: AppColors.text500,
  );

  static TextStyle _bodyStyle(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500, // Medium (closest to 556)
    fontSize: Responsive.fontSize(context, 16),
    height: 1.5, // 150% line height
    letterSpacing: 0.5,
    color: AppColors.text500,
  );

  static TextStyle _buttonTextStyle(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500, // Medium (closest to 556)
    fontSize: Responsive.fontSize(context, 16),
    height: 1.5, // 150% line height
    letterSpacing: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    // Design System Spacing: 4px, 8px, 12px, 16px, 24px, then multiples of 8px
    final horizontalPad = Responsive.horizontalPadding(context);
    final topPad = Responsive.topPadding(context);
    final decorationTop = Responsive.decorationTop(context);
    final spacing12 = Responsive.spacing(context, 12.0);
    final spacing16 = Responsive.spacing(context, 16.0);
    final spacing24 = Responsive.spacing(context, 24.0);
    final buttonHeight = Responsive.buttonHeight(context);
    final borderRadius = Responsive.borderRadius(context, 12);
    final logoSize = Responsive.logoSize(
      context,
      mobile: 80,
      tablet: 100,
      desktop: 120,
    );
    final decorationSize = Responsive.imageSize(
      context,
      mobile: 110,
      tablet: 150,
      desktop: 180,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none, // Allow decoration to overflow
          children: [
            // Main content
            Column(
              children: [
                // Top section with logo and decoration
                Expanded(
                  flex: Responsive.isMobile(context) ? 7 : 6,
                  child: Stack(
                    clipBehavior: Clip.none, // Allow decoration to overflow
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: horizontalPad,
                              right: horizontalPad,
                              top: topPad + 35.0, // Responsive top padding
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo UNSRI
                                Image.asset(
                                  'assets/logos/logo.png',
                                  width: logoSize,
                                  height: logoSize,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox.shrink();
                                  },
                                ),
                                SizedBox(
                                  height: spacing16,
                                ), // Design system: 16px
                                // Welcome heading
                                RichText(
                                  text: TextSpan(
                                    style: _headingStyle(context),
                                    children: [
                                      const TextSpan(
                                        text: 'Selamat Datang di\n',
                                      ),
                                      TextSpan(
                                        text: 'UNSRI Mobile App ',
                                        style: TextStyle(
                                          fontWeight: FontWeight
                                              .w700, // Bold for app name
                                          fontSize: Responsive.fontSize(
                                            context,
                                            24,
                                          ),
                                        ),
                                      ),
                                      const TextSpan(text: '🎓'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: spacing16,
                                ), // Design system: 16px
                                // Description text
                                Text(
                                  'Aplikasi resmi Universitas Sriwijaya untuk mendukung aktivitas akademikmu.',
                                  style: _bodyStyle(
                                    context,
                                  ).copyWith(color: AppColors.text400),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: spacing16,
                          ), // Spacing above highlight box
                          // Highlight box - full width with horizontal margin, reduced vertical padding
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: horizontalPad, // Margin kanan kiri
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing16,
                              vertical: spacing12, // Reduced vertical padding
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: Text(
                              'Lebih mudah, cepat, dan terintegrasi.',
                              style: _bodyStyle(context).copyWith(
                                color: AppColors.primary600, // #B56F0C
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Responsive.spacing(context, 4),
                          ), // Spacing below highlight box (same as above)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPad,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: spacing16,
                                ), // Design system: 16px spacing
                                // Action buttons
                                Responsive.isMobile(context)
                                    ? Row(
                                        children: [
                                          // Daftar Akun button
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const AuthScreen(
                                                          initialMode:
                                                              AuthMode.register,
                                                        ),
                                                  ),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      spacing12, // Design system: 16px
                                                ),
                                                minimumSize: Size(
                                                  0,
                                                  buttonHeight,
                                                ),
                                                side: const BorderSide(
                                                  color: AppColors.primary500,
                                                  width: 2,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        borderRadius,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                'Daftar Akun',
                                                style: _buttonTextStyle(context)
                                                    .copyWith(
                                                      color:
                                                          AppColors.primary500,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: spacing16,
                                          ), // Design system: 16px between buttons
                                          // Masuk button
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const AuthScreen(
                                                          initialMode:
                                                              AuthMode.login,
                                                        ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      spacing12, // Design system: 16px
                                                ),
                                                minimumSize: Size(
                                                  0,
                                                  buttonHeight,
                                                ),
                                                backgroundColor:
                                                    AppColors.primary500,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        borderRadius,
                                                      ),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                'Masuk',
                                                style: _buttonTextStyle(
                                                  context,
                                                ).copyWith(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Daftar Akun button
                                          SizedBox(
                                            width: Responsive.widthPercent(
                                              context,
                                              30,
                                            ),
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const AuthScreen(
                                                          initialMode:
                                                              AuthMode.register,
                                                        ),
                                                  ),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      spacing16, // Design system: 16px
                                                ),
                                                minimumSize: Size(
                                                  0,
                                                  buttonHeight,
                                                ),
                                                side: const BorderSide(
                                                  color: AppColors.primary500,
                                                  width: 2,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        borderRadius,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                'Daftar Akun',
                                                style: _buttonTextStyle(context)
                                                    .copyWith(
                                                      color:
                                                          AppColors.primary500,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: spacing16,
                                          ), // Design system: 16px
                                          // Masuk button
                                          SizedBox(
                                            width: Responsive.widthPercent(
                                              context,
                                              30,
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const AuthScreen(
                                                          initialMode:
                                                              AuthMode.login,
                                                        ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      spacing16, // Design system: 16px
                                                ),
                                                minimumSize: Size(
                                                  0,
                                                  buttonHeight,
                                                ),
                                                backgroundColor:
                                                    AppColors.primary500,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        borderRadius,
                                                      ),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                'Masuk',
                                                style: _buttonTextStyle(
                                                  context,
                                                ).copyWith(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: spacing24,
                                ), // Design system: 24px bottom padding
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Decoration graphic at top right - sticks to right edge, responsive position
                      Positioned(
                        right:
                            -horizontalPad, // Negative padding to stick to edge
                        top: decorationTop, // Responsive top position
                        child: ClipRect(
                          child: Image.asset(
                            'assets/photos/decoration.png',
                            width: decorationSize,
                            height: decorationSize,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom section with campus image
                Expanded(
                  flex: Responsive.isMobile(context) ? 3 : 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Campus background image
                      Image.asset(
                        'assets/photos/landmark.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      // Gradient overlay for better text readability if needed
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
