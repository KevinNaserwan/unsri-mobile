import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class MoreFeaturesScreen extends StatelessWidget {
  const MoreFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDC405),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Yellow header with ornaments
            SizedBox(
              height: Responsive.spacing(context, 60),
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(color: const Color(0xFFFDC405)),
                  ),
                  Positioned(
                    top: Responsive.spacing(context, 20),
                    left: -Responsive.spacing(context, 30),
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/photos/ornament1.png',
                        width: Responsive.imageSize(context, mobile: 160),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: Responsive.spacing(context, 30),
                    right: -Responsive.spacing(context, 20),
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/photos/ornament2.png',
                        width: Responsive.imageSize(context, mobile: 180),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Ornaments behind the #F8F9FD container
                  Positioned(
                    top: -Responsive.spacing(context, 30),
                    left: -Responsive.spacing(context, 30),
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/photos/ornament1.png',
                        width: Responsive.imageSize(context, mobile: 160),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -Responsive.spacing(context, 20),
                    right: -Responsive.spacing(context, 20),
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/photos/ornament2.png',
                        width: Responsive.imageSize(context, mobile: 180),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FD),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          Responsive.borderRadius(context, 12),
                        ),
                        topRight: Radius.circular(
                          Responsive.borderRadius(context, 12),
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(
                        Responsive.horizontalPadding(context),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Responsive.spacing(context, 16)),
                          // Fitur UNSRI App
                          _buildSection(
                            context,
                            title: 'Fitur UNSRI App',
                            items: _unsriAppFeatures,
                          ),
                          SizedBox(height: Responsive.spacing(context, 0)),
                          // Akademik
                          _buildSection(
                            context,
                            title: 'Akademik',
                            items: _akademikFeatures,
                          ),
                          SizedBox(height: Responsive.spacing(context, 0)),
                          // Kampus Life!
                          _buildSection(
                            context,
                            title: 'Kampus Life!',
                            items: _kampusLifeFeatures,
                          ),
                          SizedBox(height: Responsive.spacing(context, 0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_FeatureItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'SFProDisplay',
            fontWeight: FontWeight.w600,
            fontSize: Responsive.fontSize(context, 18),
            color: AppColors.text500,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, 32)),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isMobile(context) ? 4 : 5,
            mainAxisSpacing: Responsive.spacing(context, 2),
            crossAxisSpacing: Responsive.spacing(context, 8),
            childAspectRatio: Responsive.isMobile(context) ? 1.12 : 1.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildFeatureItem(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, _FeatureItem item) {
    final iconSize = Responsive.iconSize(context, 32);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          item.iconPath,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Debug: print error
            debugPrint('Error loading image: ${item.iconPath}');
            debugPrint('Error: $error');
            return Icon(
              Icons.image_not_supported,
              size: iconSize,
              color: AppColors.text300,
            );
          },
        ),
        SizedBox(height: Responsive.spacing(context, 8)),
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'SFProDisplay',
            fontWeight: FontWeight.w400,
            fontSize: Responsive.fontSize(context, 14),
            height: 1.5,
            letterSpacing: 0.5,
            color: const Color(0xFF7A7A7A),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Fitur UNSRI App
  static const List<_FeatureItem> _unsriAppFeatures = [
    _FeatureItem('Transkrip', 'assets/icons/facility/archive-book.png'),
    _FeatureItem('Aktivitas', 'assets/icons/facility/activity.png'),
    _FeatureItem('Lacak Bus', 'assets/icons/facility/bus.png'),
    _FeatureItem('Kehadiran', 'assets/icons/facility/tick-square.png'),
    _FeatureItem('Perwalian', 'assets/icons/facility/teacher.png'),
    _FeatureItem('KRS', 'assets/icons/facility/book.png'),
    _FeatureItem('UNSRI Pay', 'assets/icons/facility/moneys.png'),
  ];

  // Akademik
  static const List<_FeatureItem> _akademikFeatures = [
    _FeatureItem('Transkrip', 'assets/icons/facility/archive-book.png'),
    _FeatureItem('Kehadiran', 'assets/icons/facility/tick-square.png'),
    _FeatureItem('Bimbingan', 'assets/icons/facility/user-edit.png'),
    _FeatureItem('Perwalian', 'assets/icons/facility/teacher.png'),
    _FeatureItem('KRS', 'assets/icons/facility/book.png'),
    _FeatureItem('Bantuan', 'assets/icons/facility/message-question.png'),
    _FeatureItem('UKT', 'assets/icons/facility/money-4.png'),
    _FeatureItem('Kehadiran', 'assets/icons/facility/tick-square.png'),
    _FeatureItem('Aktivitas', 'assets/icons/facility/activity.png'),
    _FeatureItem('Fasilitasi', 'assets/icons/facility/message-add.png'),
    _FeatureItem('SKPI', 'assets/icons/facility/message-tick.png'),
    _FeatureItem('Kegiatan', 'assets/icons/facility/menu-board.png'),
  ];

  // Kampus Life!
  static const List<_FeatureItem> _kampusLifeFeatures = [
    _FeatureItem('Akt. Saya', 'assets/icons/facility/user.png'),
    _FeatureItem('Lacak Bus', 'assets/icons/facility/bus.png'),
    _FeatureItem('haloKlinik', 'assets/icons/facility/hospital.png'),
    _FeatureItem('UNSRI Pay', 'assets/icons/facility/moneys.png'),
    _FeatureItem('E-Library', 'assets/icons/facility/monitor-mobbile.png'),
    _FeatureItem('Peta', 'assets/icons/facility/map.png'),
    _FeatureItem('Lokasi', 'assets/icons/facility/map.png'),
  ];
}

class _FeatureItem {
  final String label;
  final String iconPath;

  const _FeatureItem(this.label, this.iconPath);
}
