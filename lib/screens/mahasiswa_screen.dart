import 'package:flutter/material.dart';

import '../models/app_role.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/app_bottom_nav.dart';
import 'broadcast_screen.dart';
import 'perkuliahan_screen.dart';
import 'onboarding_screen.dart';

class MahasiswaScreen extends StatelessWidget {
  final UserProfile profile;

  const MahasiswaScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);
    final maxContentWidth = isDesktop
        ? 640.0
        : isTablet
        ? 560.0
        : double.infinity;

    final isAdmin = profile.role == AppRole.admin;
    final showFullProfile = true;
    final displayRole = isAdmin
        ? AppRole.dosen
        : profile.role; // reuse dosen layout for admin
    final detailItems = _detailItemsFor(displayRole);
    final actionItems = _actionItemsFor(displayRole);
    final headerTitle = profile.role == AppRole.mahasiswa
        ? 'Profil Mahasiswa'
        : profile.role == AppRole.dosen
        ? 'Profil Dosen'
        : 'Profil Staff';

    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerTitle,
          style: TextStyle(
            fontFamily: 'SFProDisplay',
            fontWeight: FontWeight.w500,
            fontSize: Responsive.fontSize(context, 26),
            color: AppColors.text500,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, 16)),
        if (showFullProfile) _ProfileHeaderCard(profile: profile),
        if (showFullProfile) ...[
          SizedBox(height: Responsive.spacing(context, 20)),
          ...detailItems.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: Responsive.spacing(context, 12)),
              child: _ProfileInfoTile(item: item),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 8)),
          Text(
            headerTitle,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w500,
              fontSize: Responsive.fontSize(context, 18),
              color: AppColors.text500,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          ...actionItems.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: Responsive.spacing(context, 12)),
              child: _ProfileInfoTile(
                item: item,
                onTap: item.label == 'Logout'
                    ? () => _handleLogout(context)
                    : null,
              ),
            ),
          ),
        ],
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPad,
            Responsive.spacing(context, 24),
            horizontalPad,
            Responsive.spacing(context, 24),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: maxContentWidth.isFinite
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: bodyContent,
                  )
                : bodyContent,
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedTab: AppTab.mahasiswa,
        role: profile.role,
        onTabSelected: (tab) => _handleBottomNavTap(context, tab),
      ),
    );
  }

  void _handleBottomNavTap(BuildContext context, AppTab tab) {
    if (tab == AppTab.mahasiswa) return;

    final navigator = Navigator.of(context);

    if (tab == AppTab.beranda) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }

    Widget? target;
    if (tab == AppTab.perkuliahan) {
      target = PerkuliahanScreen(profile: profile);
    } else if (tab == AppTab.broadcast) {
      target = BroadcastScreen(profile: profile);
    }

    if (target != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => target!),
        (route) => route.isFirst,
      );
    }
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final UserProfile profile;

  const _ProfileHeaderCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.spacing(context, 20);
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${profile.name}!',
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.fontSize(context, 18),
                        color: AppColors.text500,
                      ),
                    ),
                    SizedBox(height: Responsive.spacing(context, 8)),
                    Text(
                      profile.subtitle,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: Responsive.fontSize(context, 14),
                        color: AppColors.text400,
                      ),
                    ),
                  ],
                ),
              ),
              ClipOval(
                child: Container(
                  width: Responsive.iconSize(context, 28) * 1.8,
                  height: Responsive.iconSize(context, 28) * 1.8,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    profile.avatarPath,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          Divider(color: const Color(0xFFE4E6EB), thickness: 1),
          SizedBox(height: Responsive.spacing(context, 4)),
          _AttendanceBar(),
        ],
      ),
    );
  }
}

class _AttendanceBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const total = 9;
    const attended = 4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Persentase Kehadiran',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w500,
                fontSize: Responsive.fontSize(context, 14),
                color: AppColors.text500,
              ),
            ),
            Text(
              '$attended/$total',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w500,
                fontSize: Responsive.fontSize(context, 14),
                color: AppColors.text400,
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.spacing(context, 10)),
        Row(
          children: List.generate(total, (index) {
            final isFilled = index < attended;
            final isFirst = index == 0;
            final isLast = index == total - 1;
            return Expanded(
              child: Container(
                height: Responsive.spacing(context, 8),
                margin: EdgeInsets.only(
                  right: isLast ? 0 : Responsive.spacing(context, 4),
                ),
                decoration: BoxDecoration(
                  color: isFilled
                      ? const Color(0xFF55C1F8)
                      : const Color(0xFFE3E6EE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      isFirst ? Responsive.borderRadius(context, 8) : 0,
                    ),
                    bottomLeft: Radius.circular(
                      isFirst ? Responsive.borderRadius(context, 8) : 0,
                    ),
                    topRight: Radius.circular(
                      isLast ? Responsive.borderRadius(context, 8) : 0,
                    ),
                    bottomRight: Radius.circular(
                      isLast ? Responsive.borderRadius(context, 8) : 0,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final _ProfileInfo item;
  final VoidCallback? onTap;

  const _ProfileInfoTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Responsive.borderRadius(context, 14)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, 14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, 18),
          vertical: Responsive.spacing(context, 14),
        ),
        child: Row(
          children: [
            Expanded(
              child: item.value.isEmpty
                  ? Text(
                      item.label,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.fontSize(context, 16),
                        color: AppColors.text500,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w400,
                            fontSize: Responsive.fontSize(context, 13),
                            color: AppColors.text400,
                          ),
                        ),
                        SizedBox(height: Responsive.spacing(context, 4)),
                        Text(
                          item.value,
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: Responsive.fontSize(context, 16),
                            color: AppColors.text500,
                          ),
                        ),
                      ],
                    ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.text300),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfo {
  final String label;
  final String value;

  const _ProfileInfo({required this.label, required this.value});
}

List<_ProfileInfo> _detailItemsFor(AppRole role) {
  switch (role) {
    case AppRole.mahasiswa:
      return const [
        _ProfileInfo(label: 'Fakultas', value: 'Ilmu Komputer'),
        _ProfileInfo(label: 'Program Studi', value: 'Sistem Informasi'),
        _ProfileInfo(label: 'Angkatan', value: '2021'),
        _ProfileInfo(label: 'Tanggal Lahir', value: '12/02/2002'),
      ];
    case AppRole.dosen:
      return const [
        _ProfileInfo(label: 'Fakultas', value: 'Ilmu Komputer'),
        _ProfileInfo(label: 'Program Studi', value: 'Teknik Informatika'),
        _ProfileInfo(label: 'NIP', value: '19751204 200112 1 001'),
        _ProfileInfo(label: 'Tanggal Lahir', value: '16/04/1994'),
      ];
    case AppRole.admin:
      return const [
        _ProfileInfo(label: 'Unit Kerja', value: 'Biro Akademik'),
        _ProfileInfo(label: 'Jabatan', value: 'Staff Administrasi'),
        _ProfileInfo(label: 'NIP', value: '19810320 200501 2 004'),
        _ProfileInfo(label: 'Tanggal Bergabung', value: '10/08/2015'),
      ];
  }
}

List<_ProfileInfo> _actionItemsFor(AppRole role) {
  switch (role) {
    case AppRole.mahasiswa:
      return const [
        _ProfileInfo(label: 'Riwayat Absensi', value: ''),
        _ProfileInfo(label: 'Pengaturan Akun', value: ''),
        _ProfileInfo(label: 'Logout', value: ''),
      ];
    case AppRole.dosen:
      return const [
        _ProfileInfo(label: 'Riwayat Kehadiran', value: ''),
        _ProfileInfo(label: 'Pengaturan Akun', value: ''),
        _ProfileInfo(label: 'Logout', value: ''),
      ];
    case AppRole.admin:
      return const [
        _ProfileInfo(label: 'Kalender Akademik', value: ''),
        _ProfileInfo(label: 'Pengaturan Akun', value: ''),
        _ProfileInfo(label: 'Logout', value: ''),
      ];
  }
}
