import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding after 5 seconds (longer for logo to load)
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  Widget _buildLogo(double logoSize) {
    return Image.asset(
      'assets/logos/logo.png',
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if image not found
        return Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(logoSize / 2),
          ),
          child: Center(
            child: Text(
              'UNSRI',
              style: TextStyle(
                fontSize: logoSize * 0.2,
                fontWeight: FontWeight.bold,
                color: AppColors.primary500,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = Responsive.logoSize(
      context,
      mobile: Responsive.widthPercent(context, 40),
      tablet: Responsive.widthPercent(context, 30),
      desktop: Responsive.widthPercent(context, 25),
    );

    return Scaffold(
      backgroundColor: AppColors.primary500,
      body: SafeArea(child: Center(child: _buildLogo(logoSize))),
    );
  }
}
