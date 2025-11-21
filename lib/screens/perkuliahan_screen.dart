import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/app_role.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/schedule_card.dart';
import 'broadcast_screen.dart';
import 'mahasiswa_screen.dart';

enum PerkuliahanTab { jadwal, daftarKehadiran }

class PerkuliahanScreen extends StatefulWidget {
  final UserProfile profile;

  const PerkuliahanScreen({super.key, required this.profile});

  @override
  State<PerkuliahanScreen> createState() => _PerkuliahanScreenState();
}

class _PerkuliahanScreenState extends State<PerkuliahanScreen> {
  PerkuliahanTab _currentTab = PerkuliahanTab.jadwal;
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();
  List<ScheduleItem> _schedules = const [];
  List<bool> _teachingActiveStates = const [];
  List<bool> _teachingCompletedStates = const [];

  final _AttendanceOverview _attendanceOverview = const _AttendanceOverview(
    attendedSessions: 4,
    totalSessions: 9,
    percentage: 50,
    stats: [
      _AttendanceStat(
        label: 'Hadir',
        value: '32',
        background: Color(0xFFE6F7D4),
        valueColor: AppColors.success700,
      ),
      _AttendanceStat(
        label: 'Terlambat',
        value: '4',
        background: Color(0xFFFFEFEA),
        valueColor: AppColors.danger700,
      ),
      _AttendanceStat(
        label: 'Absen',
        value: '2',
        background: Color(0xFFE4F4FF),
        valueColor: AppColors.info700,
      ),
    ],
  );

  List<_AttendanceHistory> get _attendanceHistories {
    if (widget.profile.role == AppRole.mahasiswa) {
      return const [
        _AttendanceHistory(
          course: 'Pemrograman Web',
          statusLabel: 'Hadir',
          percentage: 86,
          completedSessions: 12,
          totalSessions: 14,
          sessions: [
            _AttendanceSession(
              dateLabel: 'Senin, 1 September 2025',
              timeLabel: '08:30 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 8 September 2025',
              timeLabel: '08:32 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 15 September 2025',
              timeLabel: '08:34 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 22 September 2025',
              timeLabel: '08:44 WIB',
              status: _AttendanceSessionStatus.absen,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 29 September 2025',
              timeLabel: '09:01 WIB',
              status: _AttendanceSessionStatus.terlambat,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 06 Oktober 2025',
              timeLabel: '09:02 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
          ],
        ),
        _AttendanceHistory(
          course: 'Basis Data II',
          statusLabel: 'Hadir',
          percentage: 92,
          completedSessions: 11,
          totalSessions: 12,
          sessions: [
            _AttendanceSession(
              dateLabel: 'Selasa, 2 September 2025',
              timeLabel: '10:15 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Selasa, 9 September 2025',
              timeLabel: '10:20 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Selasa, 16 September 2025',
              timeLabel: '10:18 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Selasa, 23 September 2025',
              timeLabel: '10:25 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Selasa, 30 September 2025',
              timeLabel: '10:22 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Selasa, 07 Oktober 2025',
              timeLabel: '10:19 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
          ],
        ),
        _AttendanceHistory(
          course: 'Rekayasa Perangkat Lunak',
          statusLabel: 'Terlambat',
          percentage: 75,
          completedSessions: 9,
          totalSessions: 12,
          sessions: [
            _AttendanceSession(
              dateLabel: 'Rabu, 3 September 2025',
              timeLabel: '13:05 WIB',
              status: _AttendanceSessionStatus.terlambat,
            ),
            _AttendanceSession(
              dateLabel: 'Rabu, 10 September 2025',
              timeLabel: '13:00 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Rabu, 17 September 2025',
              timeLabel: '13:10 WIB',
              status: _AttendanceSessionStatus.terlambat,
            ),
            _AttendanceSession(
              dateLabel: 'Rabu, 24 September 2025',
              timeLabel: '13:00 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Rabu, 01 Oktober 2025',
              timeLabel: '13:08 WIB',
              status: _AttendanceSessionStatus.terlambat,
            ),
            _AttendanceSession(
              dateLabel: 'Rabu, 08 Oktober 2025',
              timeLabel: '13:00 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
          ],
        ),
      ];
    } else {
      // For dosen/admin
      return const [
        _AttendanceHistory(
          course: 'Ketibaan Kampus',
          statusLabel: 'Hadir',
          percentage: 86,
          completedSessions: 12,
          totalSessions: 14,
          sessions: [
            _AttendanceSession(
              dateLabel: 'Senin, 1 September 2025',
              timeLabel: '08:30 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 8 September 2025',
              timeLabel: '08:32 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 15 September 2025',
              timeLabel: '08:34 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 22 September 2025',
              timeLabel: '08:44 WIB',
              status: _AttendanceSessionStatus.absen,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 29 September 2025',
              timeLabel: '09:01 WIB',
              status: _AttendanceSessionStatus.terlambat,
            ),
            _AttendanceSession(
              dateLabel: 'Senin, 06 Oktober 2025',
              timeLabel: '09:02 WIB',
              status: _AttendanceSessionStatus.hadir,
            ),
          ],
        ),
      ];
    }
  }

  bool get _isLecturer => widget.profile.role == AppRole.dosen;

  @override
  void initState() {
    super.initState();
    _schedules = _isLecturer ? _lecturerSchedules : _mahasiswaSchedules;
    _teachingActiveStates = List<bool>.filled(_schedules.length, false);
    _teachingCompletedStates = List<bool>.filled(_schedules.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final bottomPad =
        Responsive.spacing(context, 12) + MediaQuery.of(context).padding.bottom;
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);
    final maxContentWidth = isDesktop
        ? 640.0
        : isTablet
        ? 560.0
        : double.infinity;

    final pageContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(height: Responsive.spacing(context, 20)),
        _buildTabs(context),
        SizedBox(height: Responsive.spacing(context, 20)),
        if (_currentTab == PerkuliahanTab.jadwal) ...[
          _buildCalendarCard(context),
          SizedBox(height: Responsive.spacing(context, 8)),
        ],
        if (_currentTab == PerkuliahanTab.jadwal &&
            widget.profile.role != AppRole.admin) ...[
          _buildSectionHeader(
            context,
            title: widget.profile.role == AppRole.dosen
                ? 'Jadwal Mengajarmu Hari Ini'
                : 'Jadwal Kuliahmu Hari Ini',
          ),
          SizedBox(height: Responsive.spacing(context, 8)),
        ],
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 0),
          child: _currentTab == PerkuliahanTab.jadwal
              ? (widget.profile.role == AppRole.admin
                    ? const SizedBox.shrink()
                    : _buildScheduleList(context))
              : _buildAttendanceList(context),
        ),
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
            bottomPad,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: maxContentWidth.isFinite
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: pageContent,
                  )
                : pageContent,
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedTab: AppTab.perkuliahan,
        role: widget.profile.role,
        onTabSelected: _handleBottomNavTap,
      ),
    );
  }

  void _handleBottomNavTap(AppTab tab) {
    if (tab == AppTab.perkuliahan) return;

    final navigator = Navigator.of(context);

    if (tab == AppTab.beranda) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }

    Widget? target;
    if (tab == AppTab.broadcast) {
      target = BroadcastScreen(profile: widget.profile);
    } else if (tab == AppTab.mahasiswa) {
      target = MahasiswaScreen(profile: widget.profile);
    }

    if (target != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => target!),
        (route) => route.isFirst,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur belum tersedia'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perkuliahan',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.fontSize(context, 24),
                  height: 1.4,
                  letterSpacing: 0.5,
                  color: AppColors.text500,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Semua',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w500,
              fontSize: Responsive.fontSize(context, 14),
              letterSpacing: 0.5,
              color: AppColors.text400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final borderRadius = Responsive.borderRadius(context, 8);
    final tabs = [
      (label: 'Jadwal', value: PerkuliahanTab.jadwal),
      (label: 'Daftar Kehadiran', value: PerkuliahanTab.daftarKehadiran),
    ];

    final tabSpacing = Responsive.spacing(context, 8);

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(Responsive.spacing(context, 6)),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final selectedTab = tabs[i].value;
                  if (_currentTab != selectedTab) {
                    setState(() => _currentTab = selectedTab);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    vertical: Responsive.spacing(context, 12),
                  ),
                  decoration: BoxDecoration(
                    color: tabs[i].value == _currentTab
                        ? AppColors.primary500
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      tabs[i].label,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.fontSize(context, 16),
                        color: tabs[i].value == _currentTab
                            ? Colors.white
                            : AppColors.text400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (i != tabs.length - 1) SizedBox(width: tabSpacing),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendarCard(BuildContext context) {
    final monthLabel =
        '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}';
    final days = _generateCalendarDays();
    final dayLabels = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 8),
        ),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(Responsive.spacing(context, 10)),
      child: Column(
        children: [
          Row(
            children: [
              _MonthButton(
                icon: Icons.chevron_left,
                onPressed: () => _changeMonth(-1),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    monthLabel,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 18),
                      color: AppColors.text500,
                    ),
                  ),
                ),
              ),
              _MonthButton(
                icon: Icons.chevron_right,
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w500,
                          fontSize: Responsive.fontSize(context, 12),
                          color: AppColors.text400,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: Responsive.spacing(context, 1),
              crossAxisSpacing: Responsive.spacing(context, 8),
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = _isSameDay(day.date, _selectedDate);
              final isToday = _isSameDay(day.date, DateTime.now());
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = day.date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary500
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      Responsive.borderRadius(context, 10),
                    ),
                    border: isToday && !isSelected
                        ? Border.all(
                            color: AppColors.secondary500.withValues(
                              alpha: 0.3,
                            ),
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${day.date.day}',
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: Responsive.fontSize(context, 14),
                        color: isSelected
                            ? Colors.white
                            : day.isCurrentMonth
                            ? AppColors.text500
                            : const Color(0xFFBCBCBC),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w500,
              fontSize: Responsive.fontSize(context, 18),
              height: 1.4,
              letterSpacing: 0.5,
              color: AppColors.text500,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Semua',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w500,
              fontSize: Responsive.fontSize(context, 14),
              letterSpacing: 0.5,
              color: AppColors.text400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleList(BuildContext context) {
    return Column(
      key: const ValueKey('schedule-content'),
      children: [
        for (var i = 0; i < _schedules.length; i++) ...[
          ScheduleCard(
            schedule: _schedules[i],
            isLecturer: _isLecturer,
            isActive: _isLecturer ? _teachingActiveStates[i] : false,
            isCompleted: _isLecturer ? _teachingCompletedStates[i] : false,
            onToggleTeaching: _isLecturer
                ? () => _toggleTeachingSchedule(i)
                : null,
          ),
          if (i != _schedules.length - 1)
            SizedBox(height: Responsive.spacing(context, 16)),
        ],
      ],
    );
  }

  void _toggleTeachingSchedule(int index) {
    if (!_isLecturer) return;

    final isCurrentlyActive = _teachingActiveStates[index];

    if (isCurrentlyActive) {
      // Show confirmation dialog for stopping class
      _showStopClassConfirmation(context, index);
    } else {
      // Show QR modal for starting class
      _showClassQRModal(context, index);
    }
  }

  void _showClassQRModal(BuildContext context, int index) {
    final schedule = _schedules[index];
    final qrData =
        'CLASS:${schedule.title}:${schedule.lecturer}:${DateTime.now().millisecondsSinceEpoch}';

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
                    schedule.title,
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
                          _teachingActiveStates[index] = true;
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
    final schedule = _schedules[index];

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
                    schedule.title,
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
                              _teachingActiveStates[index] = false;
                              _teachingCompletedStates[index] = true;
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

  static const List<ScheduleItem> _mahasiswaSchedules = [
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
    ScheduleItem(
      startTime: '14:00',
      endTime: '16:00',
      title: 'Desain Basis Data',
      lecturer: 'Mira Saputri, M.Kom.',
      statusLabel: 'Selesai',
      statusColor: Color(0xFFF3F3F3),
      statusTextColor: Color(0xFFBCBCBC),
    ),
  ];

  static const List<ScheduleItem> _lecturerSchedules = [
    ScheduleItem(
      startTime: '08:00',
      endTime: '10:00',
      title: 'Pemrograman Web Lanjut',
      lecturer: 'Kelas SIREG B',
      statusLabel: 'Sedang berlangsung',
      statusColor: Color(0xFFE6F7D4),
      statusTextColor: AppColors.success700,
    ),
    ScheduleItem(
      startTime: '10:30',
      endTime: '12:00',
      title: 'Arsitektur Sistem',
      lecturer: 'Kelas SIREG A',
      statusLabel: '15 Menit lagi',
      statusColor: Color(0xFFE1F4FF),
      statusTextColor: AppColors.info500,
    ),
  ];

  Widget _buildAttendanceList(BuildContext context) {
    final formattedDate = _formatDateLong(_selectedDate);
    return Column(
      key: const ValueKey('attendance-content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AttendanceDateFilter(
          dateLabel: formattedDate,
          onTap: _selectAttendanceDate,
        ),
        SizedBox(height: Responsive.spacing(context, 16)),
        _AttendanceOverviewCard(overview: _attendanceOverview),
        SizedBox(height: Responsive.spacing(context, 8)),
        _buildSectionHeader(
          context,
          title: widget.profile.role == AppRole.admin
              ? 'Histori Kehadiran Staff'
              : widget.profile.role == AppRole.dosen
              ? 'Histori Kehadiran Dosen'
              : 'Histori Kehadiran',
        ),
        SizedBox(height: Responsive.spacing(context, 8)),
        Column(
          children: [
            for (var i = 0; i < _attendanceHistories.length; i++) ...[
              _AttendanceHistoryCard(history: _attendanceHistories[i]),
              if (i != _attendanceHistories.length - 1)
                SizedBox(height: Responsive.spacing(context, 16)),
            ],
          ],
        ),
      ],
    );
  }

  List<_CalendarDay> _generateCalendarDays() {
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    final leadingEmpty = firstDayOfMonth.weekday % 7;
    final totalCells = leadingEmpty + daysInMonth;
    final trailingEmpty = totalCells % 7 == 0 ? 0 : 7 - totalCells % 7;
    final total = totalCells + trailingEmpty;

    return List.generate(total, (index) {
      final dayNumber = index - leadingEmpty + 1;
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
      final isInMonth = dayNumber >= 1 && dayNumber <= daysInMonth;
      return _CalendarDay(date: date, isCurrentMonth: isInMonth);
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
      if (_focusedMonth.month != _selectedDate.month ||
          _focusedMonth.year != _selectedDate.year) {
        _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _monthName(int month) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return names[(month - 1).clamp(0, names.length - 1)];
  }

  String _formatDateLong(DateTime date) {
    final dayName = _dayName(date.weekday);
    return '$dayName, ${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _dayName(int weekday) {
    const names = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return names[(weekday - 1).clamp(0, names.length - 1)];
  }

  Future<void> _selectAttendanceDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year - 1),
      lastDate: DateTime(_selectedDate.year + 1),
      builder: (context, child) {
        final themedChild = Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.secondary500,
              onPrimary: Colors.white,
              onSurface: AppColors.text500,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );

        return Localizations.override(
          context: context,
          locale: const Locale('id'),
          delegates: GlobalMaterialLocalizations.delegates,
          child: themedChild,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _focusedMonth = DateTime(picked.year, picked.month, 1);
      });
    }
  }
}

class _CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;

  const _CalendarDay({required this.date, required this.isCurrentMonth});
}

class _MonthButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MonthButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      splashRadius: Responsive.spacing(context, 20),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: Responsive.spacing(context, 32),
        minHeight: Responsive.spacing(context, 32),
      ),
      icon: Icon(
        icon,
        color: const Color(0xFF7A7A7A),
        size: Responsive.iconSize(context, 22),
      ),
    );
  }
}

class _AttendanceOverview {
  final int attendedSessions;
  final int totalSessions;
  final int percentage;
  final List<_AttendanceStat> stats;

  const _AttendanceOverview({
    required this.attendedSessions,
    required this.totalSessions,
    required this.percentage,
    this.stats = const [],
  });
}

class _AttendanceStat {
  final String label;
  final String value;
  final Color background;
  final Color valueColor;

  const _AttendanceStat({
    required this.label,
    required this.value,
    required this.background,
    required this.valueColor,
  });
}

class _AttendanceHistory {
  final String course;
  final String statusLabel;
  final int percentage;
  final int completedSessions;
  final int totalSessions;
  final List<_AttendanceSession> sessions;

  const _AttendanceHistory({
    required this.course,
    required this.statusLabel,
    required this.percentage,
    required this.completedSessions,
    required this.totalSessions,
    required this.sessions,
  });
}

class _AttendanceSession {
  final String dateLabel;
  final String timeLabel;
  final _AttendanceSessionStatus status;

  const _AttendanceSession({
    required this.dateLabel,
    required this.timeLabel,
    required this.status,
  });
}

enum _AttendanceSessionStatus { hadir, terlambat, absen }

class _AttendanceDateFilter extends StatelessWidget {
  final String dateLabel;
  final VoidCallback onTap;

  const _AttendanceDateFilter({required this.dateLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, 16),
          vertical: Responsive.spacing(context, 12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, 12),
          ),
          border: Border.all(color: const Color(0xFFF3F3F3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: Responsive.iconSize(context, 18),
              color: AppColors.text400,
            ),
            SizedBox(width: Responsive.spacing(context, 12)),
            Text(
              dateLabel,
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w500,
                fontSize: Responsive.fontSize(context, 15),
                color: AppColors.text500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text400,
              size: Responsive.iconSize(context, 22),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceOverviewCard extends StatelessWidget {
  final _AttendanceOverview overview;

  const _AttendanceOverviewCard({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12),
        ),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                'Persentase Kehadiran',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.fontSize(context, 16),
                  color: AppColors.text500,
                ),
              ),
              const Spacer(),
              Text(
                '${overview.percentage}%',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 16),
                  color: AppColors.text500,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          Row(
            children: [
              Text(
                '${overview.attendedSessions}/${overview.totalSessions}',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.fontSize(context, 14),
                  height: 1.5,
                  letterSpacing: 0.5,
                  color: const Color(0xFF7A7A7A),
                ),
              ),
              SizedBox(width: Responsive.spacing(context, 12)),
              Expanded(
                child: _SegmentedProgress(
                  segments: overview.totalSessions,
                  filledSegments: overview.attendedSessions,
                  filledColor: const Color(0xFF55C1F8),
                  emptyColor: const Color(0xFFE7EBF3),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          if (overview.stats.isNotEmpty)
            Row(
              children: [
                for (var i = 0; i < overview.stats.length; i++) ...[
                  Expanded(
                    child: _AttendanceStatTile(
                      stat: overview.stats[i],
                      isFirst: i == 0,
                      isLast: i == overview.stats.length - 1,
                    ),
                  ),
                  if (i != overview.stats.length - 1)
                    SizedBox(width: Responsive.spacing(context, 8)),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _AttendanceStatTile extends StatelessWidget {
  final _AttendanceStat stat;
  final bool isFirst;
  final bool isLast;

  const _AttendanceStatTile({
    required this.stat,
    required this.isFirst,
    required this.isLast,
  });

  BorderRadius _radius(BuildContext context) {
    final large = Responsive.borderRadius(context, 12);
    final small = Responsive.borderRadius(context, 4);

    if (isFirst) {
      return BorderRadius.only(
        topLeft: Radius.circular(large),
        bottomLeft: Radius.circular(large),
        topRight: Radius.circular(small),
        bottomRight: Radius.circular(small),
      );
    }

    if (isLast) {
      return BorderRadius.only(
        topRight: Radius.circular(large),
        bottomRight: Radius.circular(large),
        topLeft: Radius.circular(small),
        bottomLeft: Radius.circular(small),
      );
    }

    return BorderRadius.circular(small);
  }

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF7A7A7A);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.spacing(context, 10),
        horizontal: Responsive.spacing(context, 8),
      ),
      decoration: BoxDecoration(
        color: stat.background,
        borderRadius: _radius(context),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, -2),
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.value,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: Responsive.fontSize(context, 18),
              color: stat.valueColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 2)),
          Text(
            stat.label,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w500,
              fontSize: Responsive.fontSize(context, 13),
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceHistoryCard extends StatelessWidget {
  final _AttendanceHistory history;

  const _AttendanceHistoryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    final visibleRows = history.sessions.isEmpty
        ? 0
        : math.min(history.sessions.length, 5);
    final rowHeight = Responsive.spacing(context, 52);
    final rowSpacing = Responsive.spacing(context, 2);
    final listHeight = visibleRows == 0
        ? 0.0
        : visibleRows * rowHeight + (visibleRows - 1) * rowSpacing;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12),
        ),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Expanded(
                child: Text(
                  history.course,
                  style: TextStyle(
                    fontFamily: 'SFCompact',
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 16),
                    height: 1.5,
                    letterSpacing: 0.5,
                    color: AppColors.text500,
                  ),
                ),
              ),
              Text(
                '${history.statusLabel} (${history.percentage}%)',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.fontSize(context, 14),
                  height: 1.5,
                  letterSpacing: 0.5,
                  color: const Color(0xFF7A7A7A),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 8)),
          Row(
            children: [
              Text(
                '${history.completedSessions.toString().padLeft(2, '0')}/${history.totalSessions}',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.fontSize(context, 14),
                  height: 1.5,
                  letterSpacing: 0.5,
                  color: const Color(0xFF7A7A7A),
                ),
              ),
              SizedBox(width: Responsive.spacing(context, 12)),
              Expanded(
                child: _SegmentedProgress(
                  segments: history.totalSessions,
                  filledSegments: history.completedSessions,
                  filledColor: AppColors.secondary500,
                  emptyColor: const Color(0xFFE7EBF3),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          SizedBox(
            height: listHeight,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(physics: const BouncingScrollPhysics()),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: history.sessions.length,
                separatorBuilder: (context, _) => SizedBox(height: rowSpacing),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: rowHeight,
                    child: _SessionRow(session: history.sessions[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedProgress extends StatelessWidget {
  final int segments;
  final int filledSegments;
  final Color filledColor;
  final Color emptyColor;

  const _SegmentedProgress({
    required this.segments,
    required this.filledSegments,
    required this.filledColor,
    required this.emptyColor,
  });

  @override
  Widget build(BuildContext context) {
    final clampedSegments = segments.clamp(1, 14);
    final clampedFilled = filledSegments.clamp(0, clampedSegments);
    return Row(
      children: List.generate(clampedSegments, (index) {
        final isFilled = index < clampedFilled;
        final isFirst = index == 0;
        final isLast = index == clampedSegments - 1;
        return Expanded(
          child: Container(
            height: Responsive.spacing(context, 6),
            margin: EdgeInsets.only(
              right: isLast ? 0 : Responsive.spacing(context, 2),
            ),
            decoration: BoxDecoration(
              color: isFilled ? filledColor : emptyColor,
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
    );
  }
}

class _SessionRow extends StatelessWidget {
  final _AttendanceSession session;

  const _SessionRow({required this.session});

  Color get _statusColor {
    switch (session.status) {
      case _AttendanceSessionStatus.hadir:
        return AppColors.success500;
      case _AttendanceSessionStatus.terlambat:
        return AppColors.danger500;
      case _AttendanceSessionStatus.absen:
        return AppColors.info500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(context, 8),
                  ),
                  border: Border(
                    left: BorderSide(
                      color: _statusColor,
                      width: Responsive.spacing(context, 4),
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x20000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Responsive.spacing(context, 12),
                    horizontal: Responsive.spacing(context, 12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.dateLabel,
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w500,
                            fontSize: Responsive.fontSize(context, 14),
                            color: AppColors.text500,
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.spacing(context, 12)),
                      Text(
                        session.timeLabel,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.fontSize(context, 14),
                          color: AppColors.text500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
