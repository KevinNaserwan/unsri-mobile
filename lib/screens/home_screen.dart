import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/app_role.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../utils/tap_in_state.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/schedule_card.dart';
import 'broadcast_screen.dart';
import 'mahasiswa_screen.dart';
import 'more_features_screen.dart';
import 'perkuliahan_screen.dart';
import 'tap_in_map_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile profile;

  const HomeScreen({super.key, required this.profile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextStyle _sfCompact18(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500,
    fontSize: Responsive.fontSize(context, 18),
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.text500,
  );

  TextStyle _sfCompact16(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500,
    fontSize: Responsive.fontSize(context, 16),
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.text500,
  );

  TextStyle _sfProBody(
    BuildContext context, {
    Color color = AppColors.text500,
    FontWeight fontWeight = FontWeight.w400,
  }) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: fontWeight,
    fontSize: Responsive.fontSize(context, 14),
    height: 1.5,
    letterSpacing: 0.5,
    color: color,
  );

  static const List<_QuickAction> _studentQuickActions = [
    _QuickAction('Kehadiran', 'assets/icons/Achievement.png'),
    _QuickAction('Transkrip', 'assets/icons/Quiz.png'),
    _QuickAction('KRS', 'assets/icons/Book.png'),
    _QuickAction('Bimbingan', 'assets/icons/Student.png'),
    _QuickAction('K-Life!', 'assets/icons/Discuss.png'),
    _QuickAction('Peta', 'assets/icons/School.png'),
    _QuickAction('Lacak Bus', 'assets/icons/Research.png'),
    _QuickAction('Lainnya', 'assets/icons/menu.png'),
  ];

  static const List<_QuickAction> _lecturerQuickActions = [
    _QuickAction('Pay Roll', 'assets/icons/quick_action/dosen/money-tick.png'),
    _QuickAction('Kehadiran', 'assets/icons/quick_action/dosen/timer.png'),
    _QuickAction('Izin', 'assets/icons/quick_action/dosen/note-favorite.png'),
    _QuickAction('Klaim', 'assets/icons/quick_action/dosen/note-1.png'),
    _QuickAction(
      'Aktivitas',
      'assets/icons/quick_action/dosen/password-check.png',
    ),
    _QuickAction('Permintaan', 'assets/icons/quick_action/dosen/note.png'),
    _QuickAction(
      'Persetujuan',
      'assets/icons/quick_action/dosen/user-edit.png',
    ),
    _QuickAction('Lainnya', 'assets/icons/menu.png'),
  ];

  final List<ScheduleItem> _schedules = const [
    ScheduleItem(
      startTime: '08:00',
      endTime: '09:40',
      title: 'Pengantar Teknologi Informasi',
      lecturer: 'Dr. Rahmawati, M.Kom.',
      statusLabel: 'Sedang berlangsung',
      statusColor: Color(0xFFE6F7D4),
      statusTextColor: Color(0xFF3A7A0C),
    ),
    ScheduleItem(
      startTime: '10:00',
      endTime: '13:00',
      title: 'Rekayasa Perangkat Lunak',
      lecturer: 'Dedy Kurniawan, S.Si., M.Sc.',
      statusLabel: '15 Menit lagi',
      statusColor: Color(0xFFE1F4FF),
      statusTextColor: AppColors.info500,
    ),
  ];

  late List<_TeachingSchedule> _teachingSchedules;
  late List<bool> _teachingActive;
  late List<bool> _teachingCompleted;

  AppTab _selectedTab = AppTab.beranda;

  bool get _isLecturer => widget.profile.role == AppRole.dosen;

  bool get _isAdmin => widget.profile.role == AppRole.admin;

  bool get _usesStaffHeader => _isLecturer || _isAdmin;

  List<_QuickAction> get _quickActions {
    if (_isAdmin) return const [];
    return _isLecturer ? _lecturerQuickActions : _studentQuickActions;
  }

  @override
  void initState() {
    super.initState();
    _setupTeachingSchedules();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.role != widget.profile.role) {
      _setupTeachingSchedules();
    }
  }

  void _setupTeachingSchedules() {
    if (_isLecturer) {
      _teachingSchedules = const [
        _TeachingSchedule(
          startTime: '08:00',
          endTime: '09:40',
          subject: 'Basis Data II',
          className: 'Kelas SIREG B',
          statusLabel: 'Sedang berlangsung',
          statusColor: Color(0xFFE6F7D4),
          statusTextColor: Color(0xFF3A7A0C),
          isActive: true,
        ),
        _TeachingSchedule(
          startTime: '10:00',
          endTime: '13:00',
          subject: 'Basis Data II',
          className: 'Kelas SIREG C',
          statusLabel: '15 Menit lagi',
          statusColor: Color(0xFFE1F4FF),
          statusTextColor: AppColors.info500,
          isActive: false,
        ),
      ];
      _teachingActive = _teachingSchedules.map((s) => s.isActive).toList();
      _teachingCompleted = List.filled(_teachingSchedules.length, false);
    } else {
      _teachingSchedules = const [];
      _teachingActive = const [];
      _teachingCompleted = const [];
    }
  }

  void _toggleTeaching(int index) {
    if (!_isLecturer || index < 0 || index >= _teachingActive.length) return;

    final isCurrentlyActive = _teachingActive[index];

    if (isCurrentlyActive) {
      // Show confirmation dialog for stopping class
      _showStopClassConfirmation(context, index);
    } else {
      // Show QR modal for starting class
      _showClassQRModal(context, index);
    }
  }

  void _showClassQRModal(BuildContext context, int index) {
    final schedule = _teachingSchedules[index];
    final qrData =
        'CLASS:${schedule.subject}:${schedule.className}:${DateTime.now().millisecondsSinceEpoch}';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            child: Container(
              padding: EdgeInsets.all(Responsive.spacing(context, 24)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Responsive.borderRadius(context, 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QR Absen Kelas',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.fontSize(context, 18),
                          color: AppColors.text500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(
                            Responsive.spacing(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: Responsive.iconSize(context, 20),
                            color: AppColors.text400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.spacing(context, 24)),
                  Container(
                    padding: EdgeInsets.all(Responsive.spacing(context, 20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(context, 16),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE4E6EB),
                        width: 1,
                      ),
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: Responsive.spacing(context, 220),
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 20)),
                  Text(
                    'Tunjukkan QR ini kepada mahasiswa untuk absen',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: Responsive.fontSize(context, 14),
                      color: AppColors.text400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Responsive.spacing(context, 8)),
                  Text(
                    '${schedule.subject} - ${schedule.className}',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 16),
                      color: AppColors.text500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Responsive.spacing(context, 24)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _teachingActive[index] = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.spacing(context, 12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.borderRadius(context, 12),
                          ),
                        ),
                      ),
                      child: Text(
                        'Mulai Kelas',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.fontSize(context, 16),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStopClassConfirmation(BuildContext context, int index) {
    final schedule = _teachingSchedules[index];

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            child: Container(
              padding: EdgeInsets.all(Responsive.spacing(context, 24)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Responsive.borderRadius(context, 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Responsive.iconSize(context, 60),
                    height: Responsive.iconSize(context, 60),
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primary500,
                      size: Responsive.iconSize(context, 36),
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 16)),
                  Text(
                    'Kelas Sudah Selesai?',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 20),
                      color: AppColors.text500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Responsive.spacing(context, 8)),
                  Text(
                    '${schedule.subject} - ${schedule.className}',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: Responsive.fontSize(context, 14),
                      color: AppColors.text400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Responsive.spacing(context, 24)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.text200),
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.spacing(context, 12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.borderRadius(context, 12),
                              ),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w600,
                              fontSize: Responsive.fontSize(context, 16),
                              color: AppColors.text500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.spacing(context, 12)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _teachingActive[index] = false;
                              _teachingCompleted[index] = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.spacing(context, 12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.borderRadius(context, 12),
                              ),
                            ),
                          ),
                          child: Text(
                            'Ya, Selesai',
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w600,
                              fontSize: Responsive.fontSize(context, 16),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDC405),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeaderBackdrop(context),
            ),
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPad = Responsive.horizontalPadding(context);
                  final cardTopOffset = Responsive.spacing(
                    context,
                    _isLecturer ? 30 : 30,
                  );
                  final whiteBgTopOffset = Responsive.spacing(
                    context,
                    _isLecturer
                        ? 130
                        : _isAdmin
                        ? 120
                        : 80,
                  );
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        top: whiteBgTopOffset,
                        child: Container(
                          width: double.infinity,
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
                            padding: EdgeInsets.fromLTRB(
                              horizontalPad,
                              (cardTopOffset -
                                          whiteBgTopOffset +
                                          Responsive.spacing(context, 24))
                                      .clamp(0.0, double.infinity) +
                                  (_usesStaffHeader
                                      ? Responsive.spacing(context, 200)
                                      : Responsive.spacing(context, 100)),
                              horizontalPad,
                              Responsive.spacing(context, 24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildHomeSections(context),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: cardTopOffset,
                        left: horizontalPad,
                        right: horizontalPad,
                        child: _usesStaffHeader
                            ? _buildLecturerHeader(context)
                            : _buildHeader(context),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedTab: _selectedTab,
        role: widget.profile.role,
        onTabSelected: _handleBottomNavTap,
      ),
    );
  }

  void _handleBottomNavTap(AppTab tab) {
    if (tab == _selectedTab) return;

    setState(() => _selectedTab = tab);

    if (tab == AppTab.beranda) {
      return;
    }

    if (tab == AppTab.perkuliahan) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) => PerkuliahanScreen(profile: widget.profile),
            ),
          )
          .then((_) {
            if (mounted) {
              setState(() => _selectedTab = AppTab.beranda);
            }
          });
      return;
    }

    if (tab == AppTab.broadcast) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) => BroadcastScreen(profile: widget.profile),
            ),
          )
          .then((_) {
            if (mounted) {
              setState(() => _selectedTab = AppTab.beranda);
            }
          });
      return;
    }

    if (tab == AppTab.mahasiswa) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) => MahasiswaScreen(profile: widget.profile),
            ),
          )
          .then((_) {
            if (mounted) {
              setState(() => _selectedTab = AppTab.beranda);
            }
          });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur belum tersedia'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _selectedTab = AppTab.beranda);
      }
    });
  }

  Route _buildMoreFeaturesRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MoreFeaturesScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curved);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Widget _buildHeaderBackdrop(BuildContext context) {
    final backdropHeight = _usesStaffHeader
        ? Responsive.spacing(context, 220)
        : Responsive.spacing(context, 200);
    return SizedBox(
      height: backdropHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: Container(color: const Color(0xFFFDC405))),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    final padding = Responsive.spacing(context, 12);
    return Container(
      width: double.infinity,
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
                      'Halo, ${widget.profile.name}!',
                      style: _sfCompact18(context).copyWith(
                        color: AppColors.text500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Responsive.spacing(context, 4)),
                    Text(
                      widget.profile.subtitle,
                      style: _sfProBody(context, color: AppColors.text400),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showQRModal(context),
                    child: Image.asset(
                      'assets/icons/scan.png',
                      width: Responsive.spacing(context, 32),
                      height: Responsive.spacing(context, 32),
                    ),
                  ),
                  SizedBox(width: Responsive.spacing(context, 8)),
                  ClipOval(
                    child: Container(
                      width: Responsive.iconSize(context, 28) * 2,
                      height: Responsive.iconSize(context, 28) * 2,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        widget.profile.avatarPath,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          Divider(color: const Color(0xFFE4E6EB), thickness: 1),
          SizedBox(height: Responsive.spacing(context, 4)),
          _buildAttendanceRow(context),
        ],
      ),
    );
  }

  Widget _buildLecturerHeader(BuildContext context) {
    final padding = Responsive.spacing(context, 16);
    final displayName = _lecturerDisplayName();
    return Container(
      width: double.infinity,
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
                      '${_greeting()}, $displayName!',
                      style: _sfCompact18(context).copyWith(
                        color: AppColors.text500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Responsive.spacing(context, 4)),
                    Text(
                      widget.profile.subtitle,
                      style: _sfProBody(context, color: AppColors.text400),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showQRModal(context),
                    child: Image.asset(
                      'assets/icons/scan.png',
                      width: Responsive.spacing(context, 32),
                      height: Responsive.spacing(context, 32),
                    ),
                  ),
                  SizedBox(width: Responsive.spacing(context, 8)),
                  ClipOval(
                    child: Container(
                      width: Responsive.iconSize(context, 28) * 2,
                      height: Responsive.iconSize(context, 28) * 2,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        widget.profile.avatarPath,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 16)),
          Row(
            children: [
              Expanded(
                child: _buildTimeTile(
                  context,
                  label: 'Jam Masuk',
                  time: TapInState.checkInTime,
                ),
              ),
              SizedBox(width: Responsive.spacing(context, 12)),
              Expanded(
                child: _buildTimeTile(
                  context,
                  label: 'Jam Pulang',
                  time: TapInState.checkOutTime,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: TapInState.isButtonDisabled
                  ? null
                  : () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TapInMapScreen(
                            profile: widget.profile,
                            isTappedIn: TapInState.isTappedIn,
                          ),
                        ),
                      );
                      if (result == true && mounted) {
                        setState(() {});
                      }
                    },
              icon: Image.asset(
                'assets/icons/bag-timer.png',
                width: Responsive.iconSize(context, 20),
                height: Responsive.iconSize(context, 20),
                color: Colors.white,
              ),
              label: Text(
                TapInState.isButtonDisabled
                    ? 'Already Tap In'
                    : TapInState.isTappedIn
                    ? 'Tap Out'
                    : 'Tap In',
                style: TextStyle(
                  fontFamily: 'SFCompact',
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.fontSize(context, 16),
                  height: 1.5,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TapInState.isTappedIn
                    ? const Color(0xFFFF5C49)
                    : AppColors.primary500,
                disabledBackgroundColor: AppColors.primary500.withValues(
                  alpha: 0.65,
                ),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                padding: EdgeInsets.symmetric(
                  vertical: Responsive.spacing(context, 8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(context, 4),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 8)),
          Divider(color: const Color(0xFFE4E6EB), thickness: 1),
          SizedBox(height: Responsive.spacing(context, 4)),
          _buildAttendanceRow(context),
        ],
      ),
    );
  }

  Widget _buildTimeTile(
    BuildContext context, {
    required String label,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, 12),
        vertical: Responsive.spacing(context, 10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12),
        ),
        border: Border.all(color: const Color(0xFFE4E6EB), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: Responsive.fontSize(context, 16),
              color: AppColors.text500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: Responsive.fontSize(context, 13),
              color: AppColors.text400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Pagi';
    if (hour < 15) return 'Siang';
    if (hour < 18) return 'Sore';
    return 'Malam';
  }

  String _lecturerDisplayName() {
    if (!_isLecturer) return widget.profile.name;
    final parts = widget.profile.name.split(' ');
    final last = parts.isNotEmpty ? parts.last : widget.profile.name;
    return 'Pak $last';
  }

  void _showQRModal(BuildContext context) {
    final roleLabel = widget.profile.role.name.toUpperCase();
    final qrData =
        '$roleLabel:${widget.profile.subtitle}:${DateTime.now().millisecondsSinceEpoch}';
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            child: Container(
              padding: EdgeInsets.all(Responsive.spacing(context, 24)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Responsive.borderRadius(context, 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QR Akses Kampus',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.fontSize(context, 18),
                          color: AppColors.text500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(
                            Responsive.spacing(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: Responsive.iconSize(context, 20),
                            color: AppColors.text400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.spacing(context, 24)),
                  Container(
                    padding: EdgeInsets.all(Responsive.spacing(context, 20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(context, 16),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE4E6EB),
                        width: 1,
                      ),
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: Responsive.spacing(context, 220),
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 20)),
                  Text(
                    'Tunjukkan QR ini pada gate kampus untuk masuk',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: Responsive.fontSize(context, 14),
                      color: AppColors.text400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Responsive.spacing(context, 8)),
                  Text(
                    widget.profile.name,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w500,
                      fontSize: Responsive.fontSize(context, 14),
                      color: AppColors.text500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final iconSize = Responsive.iconSize(context, 32);
    final cardSize = Responsive.spacing(context, 80);
    final actions = _quickActions;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context)
            ? 4
            : actions.length >= 8
            ? 5
            : 4,
        mainAxisSpacing: 0,
        crossAxisSpacing: Responsive.spacing(context, 2),
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        final bool isLainnya = action.label == 'Lainnya';
        return GestureDetector(
          onTap: isLainnya
              ? () => Navigator.of(context).push(_buildMoreFeaturesRoute())
              : null,
          child: Column(
            children: [
              Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  color: isLainnya ? Colors.transparent : Colors.white,
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(context, 8),
                  ),
                  boxShadow: isLainnya
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0x14000000),
                            offset: const Offset(0, -2),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Image.asset(
                        action.iconPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.text300,
                            ),
                      ),
                    ),
                    SizedBox(height: Responsive.spacing(context, 8)),
                    Text(
                      action.label,
                      textAlign: TextAlign.center,
                      style: _sfProBody(context, color: Color(0xFF7A7A7A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceRow(BuildContext context) {
    const totalSegments = 8;
    const attendedSegments = 2;
    final segmentHeight = Responsive.spacing(context, 8);
    final segmentMargin = Responsive.spacing(context, 4);
    final borderRadius = Responsive.borderRadius(context, 8);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Persentase Kehadiran', style: _sfCompact16(context)),
        SizedBox(width: Responsive.spacing(context, 12)),
        Expanded(
          child: Row(
            children: List.generate(totalSegments, (index) {
              final isFilled = index < attendedSegments;
              final isFirst = index == 0;
              final isLast = index == totalSegments - 1;
              return Expanded(
                child: Container(
                  height: segmentHeight,
                  margin: EdgeInsets.only(right: isLast ? 0 : segmentMargin),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? AppColors.info500
                        : const Color(0xFFE3E6EE),
                    borderRadius: BorderRadius.only(
                      topLeft: isFirst
                          ? Radius.circular(borderRadius)
                          : Radius.zero,
                      bottomLeft: isFirst
                          ? Radius.circular(borderRadius)
                          : Radius.zero,
                      topRight: isLast
                          ? Radius.circular(borderRadius)
                          : Radius.zero,
                      bottomRight: isLast
                          ? Radius.circular(borderRadius)
                          : Radius.zero,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(width: Responsive.spacing(context, 12)),
        Text(
          '$attendedSegments/$totalSegments',
          style: _sfCompact18(
            context,
          ).copyWith(fontSize: Responsive.fontSize(context, 14)),
        ),
      ],
    );
  }

  Widget _buildReminderBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, 16),
        vertical: Responsive.spacing(context, 8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F5FF),
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 8),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info500,
            size: Responsive.iconSize(context, 20),
          ),
          SizedBox(width: Responsive.spacing(context, 12)),
          Expanded(
            child: Text(
              'Kuliah RPL akan dimulai dalam',
              style: _sfProBody(context, color: AppColors.info600),
            ),
          ),
          Text(
            '15:49',
            style: _sfCompact16(
              context,
            ).copyWith(color: AppColors.info600, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isLecturer
                  ? 'Jadwal Mengajarmu Hari Ini'
                  : 'Jadwal Kuliahmu Hari Ini',
              style: _sfCompact18(context).copyWith(color: AppColors.text500),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Semua',
                style: _sfProBody(context, color: const Color(0xFF7A7A7A)),
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.spacing(context, 4)),
        Column(
          children: [
            for (var i = 0; i < _schedules.length; i++) ...[
              ScheduleCard(schedule: _schedules[i]),
              if (i != _schedules.length - 1)
                SizedBox(height: Responsive.spacing(context, 12)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTeachingScheduleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jadwal Mengajarmu Hari Ini',
              style: _sfCompact18(context).copyWith(color: AppColors.text500),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Semua',
                style: _sfProBody(context, color: const Color(0xFF7A7A7A)),
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.spacing(context, 4)),
        Column(
          children: List.generate(_teachingSchedules.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _teachingSchedules.length - 1
                    ? 0
                    : Responsive.spacing(context, 12),
              ),
              child: _TeachingScheduleCard(
                schedule: _teachingSchedules[index],
                isActive: _teachingActive[index],
                isCompleted: _teachingCompleted[index],
                onToggle: () => _toggleTeaching(index),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAcademicCalendarCard(BuildContext context) {
    const events = [
      _AcademicEvent(
        date: '17 Agustus 2025',
        title: 'Upacara Bendera Kemerdekaan 80th',
        description: 'Seluruh tenaga kerja & mahasiswa wajib hadir',
      ),
      _AcademicEvent(
        date: '25 Agustus 2025',
        title: 'Rapat Evaluasi Semester Genap',
        description: 'Seluruh ketua program studi hadir di Aula Rektorat',
      ),
      _AcademicEvent(
        date: '2 September 2025',
        title: 'Distribusi Kartu UTS',
        description: 'Ambil kartu ujian di BAAK pukul 09.00–15.00 WIB',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kalender Akademik',
              style: _sfCompact18(context).copyWith(color: AppColors.text500),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Lihat Kalender',
                style: _sfProBody(context, color: const Color(0xFF7A7A7A)),
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.spacing(context, 4)),
        Column(
          children: [
            for (var i = 0; i < events.length; i++) ...[
              _buildAcademicEventCard(context, events[i]),
              if (i != events.length - 1)
                SizedBox(height: Responsive.spacing(context, 12)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAcademicEventCard(BuildContext context, _AcademicEvent event) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.spacing(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, 12),
              vertical: Responsive.spacing(context, 3),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(
                Responsive.borderRadius(context, 8),
              ),
              border: Border.all(
                color: const Color(0xFFF3F3F3),
                width: Responsive.spacing(context, 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x0A000000),
                  offset: const Offset(0, -1),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/perkuliahan.png',
                  width: Responsive.iconSize(context, 16),
                  height: Responsive.iconSize(context, 16),
                  color: AppColors.text400,
                ),
                SizedBox(width: Responsive.spacing(context, 6)),
                Text(
                  event.date,
                  style: _sfProBody(
                    context,
                    color: AppColors.text400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          Text(
            event.title,
            style: _sfCompact16(
              context,
            ).copyWith(fontWeight: FontWeight.w600, color: AppColors.text500),
          ),
          SizedBox(height: Responsive.spacing(context, 6)),
          Text(
            event.description,
            style: _sfProBody(context, color: AppColors.text400),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHomeSections(BuildContext context) {
    if (_isAdmin) {
      return [_buildAcademicCalendarCard(context)];
    }

    final sections = <Widget>[_buildQuickActions(context)];

    if (!_isLecturer) {
      sections.add(SizedBox(height: Responsive.spacing(context, 8)));
      sections.add(_buildReminderBanner(context));
      sections.add(SizedBox(height: Responsive.spacing(context, 4)));
    } else {
      sections.add(SizedBox(height: Responsive.spacing(context, 8)));
    }

    sections.add(
      _isLecturer
          ? _buildTeachingScheduleSection(context)
          : _buildScheduleSection(context),
    );
    sections.add(SizedBox(height: Responsive.spacing(context, 8)));
    sections.add(_buildAcademicCalendarCard(context));

    return sections;
  }
}

class _QuickAction {
  final String label;
  final String iconPath;

  const _QuickAction(this.label, this.iconPath);
}

class _TeachingSchedule {
  final String startTime;
  final String endTime;
  final String subject;
  final String className;
  final String statusLabel;
  final Color statusColor;
  final Color statusTextColor;
  final bool isActive;

  const _TeachingSchedule({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.className,
    required this.statusLabel,
    required this.statusColor,
    required this.statusTextColor,
    required this.isActive,
  });
}

class _TeachingScheduleCard extends StatelessWidget {
  final _TeachingSchedule schedule;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback onToggle;

  const _TeachingScheduleCard({
    required this.schedule,
    required this.isActive,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final actionLabel = isActive ? 'Stop Kelas' : 'Mulai Kelas';
    final actionColor = isActive
        ? const Color(0xFFFF5C49)
        : AppColors.primary500;

    // Status label and color
    final statusLabel = isCompleted ? 'Selesai' : schedule.statusLabel;
    final statusColor = isCompleted
        ? const Color(0xFFE5E5E5)
        : schedule.statusColor;
    final statusTextColor = isCompleted
        ? const Color(0xFF7A7A7A)
        : schedule.statusTextColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 8),
        ),
        border: Border(
          left: BorderSide(
            color: statusTextColor,
            width: Responsive.spacing(context, 4),
          ),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(Responsive.spacing(context, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${schedule.startTime} - ${schedule.endTime}',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.fontSize(context, 14),
                  color: AppColors.text400,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, 10),
                  vertical: Responsive.spacing(context, 4),
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(context, 4),
                  ),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: Responsive.fontSize(context, 11),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          Text(
            schedule.subject,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: Responsive.fontSize(context, 16),
              color: AppColors.text500,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          Text(
            schedule.className,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: Responsive.fontSize(context, 14),
              color: AppColors.text400,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 8)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(
                      Responsive.spacing(context, 34),
                    ),
                    padding: EdgeInsets.zero,
                    side: const BorderSide(color: AppColors.text200),
                    foregroundColor: AppColors.text500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(context, 4),
                      ),
                    ),
                  ),
                  child: const Text('SIMAK'),
                ),
              ),
              SizedBox(width: Responsive.spacing(context, 12)),
              Expanded(
                child: ElevatedButton(
                  onPressed: isCompleted ? null : onToggle,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(
                      Responsive.spacing(context, 34),
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: isCompleted
                        ? AppColors.primary500.withValues(alpha: 0.6)
                        : actionColor,
                    disabledBackgroundColor: AppColors.primary500.withValues(
                      alpha: 0.6,
                    ),
                    disabledForegroundColor: Colors.white.withValues(
                      alpha: 0.7,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(context, 4),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/scanner.png',
                        width: Responsive.iconSize(context, 18),
                        height: Responsive.iconSize(context, 18),
                        color: isCompleted
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.white,
                      ),
                      SizedBox(width: Responsive.spacing(context, 6)),
                      Text(actionLabel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AcademicEvent {
  final String date;
  final String title;
  final String description;

  const _AcademicEvent({
    required this.date,
    required this.title,
    required this.description,
  });
}
