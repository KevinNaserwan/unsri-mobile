import 'package:flutter/material.dart';

import '../models/app_role.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

enum AppTab { beranda, perkuliahan, broadcast, mahasiswa }

class AppBottomNav extends StatelessWidget {
  final AppTab selectedTab;
  final AppRole role;
  final ValueChanged<AppTab> onTabSelected;

  const AppBottomNav({
    super.key,
    required this.selectedTab,
    required this.role,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_BottomNavItem>[
      _BottomNavItem(
        tab: AppTab.beranda,
        label: 'Beranda',
        iconPath: 'assets/icons/home.png',
      ),
      _BottomNavItem(
        tab: AppTab.perkuliahan,
        label: 'Perkuliahan',
        iconPath: 'assets/icons/perkuliahan.png',
      ),
      _BottomNavItem(
        tab: AppTab.broadcast,
        label: 'Broadcast',
        iconPath: 'assets/icons/broadcast.png',
      ),
      _BottomNavItem(
        tab: AppTab.mahasiswa,
        label: role.navLabel,
        iconPath: 'assets/icons/profile.png',
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: Responsive.horizontalPadding(context),
        right: Responsive.horizontalPadding(context),
        bottom: Responsive.spacing(context, 20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final selectedIndex = items.indexWhere(
            (item) => item.tab == selectedTab,
          );
          final safeSelectedIndex = selectedIndex == -1 ? 0 : selectedIndex;
          final itemWidth = constraints.maxWidth / items.length;
          final indicatorWidth = Responsive.spacing(context, 60);
          final indicatorLeft =
              safeSelectedIndex * itemWidth + (itemWidth - indicatorWidth) / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                top: 0,
                left: indicatorLeft,
                child: Container(
                  width: indicatorWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.primary500,
                    borderRadius: BorderRadius.circular(
                      Responsive.borderRadius(context, 12),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.map((item) {
                  final isSelected = item.tab == selectedTab;
                  final iconPath = isSelected
                      ? item.iconPath.replaceAll('.png', '-2.png')
                      : item.iconPath;
                  final iconSize = item.tab == AppTab.beranda && !isSelected
                      ? 19.0
                      : 24.0;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTabSelected(item.tab),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 0),
                          SizedBox(height: 3, width: indicatorWidth),
                          SizedBox(height: Responsive.spacing(context, 8)),
                          Image.asset(
                            iconPath,
                            width: iconSize,
                            height: iconSize,
                          ),
                          SizedBox(height: Responsive.spacing(context, 4)),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 14),
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? AppColors.primary400
                                  : AppColors.text300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BottomNavItem {
  final AppTab tab;
  final String label;
  final String iconPath;

  const _BottomNavItem({
    required this.tab,
    required this.label,
    required this.iconPath,
  });
}
