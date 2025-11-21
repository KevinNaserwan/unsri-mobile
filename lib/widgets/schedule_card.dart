import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../screens/attendance_scanner_screen.dart';

class ScheduleItem {
  final String startTime;
  final String endTime;
  final String title;
  final String lecturer;
  final String statusLabel;
  final Color statusColor;
  final Color statusTextColor;

  const ScheduleItem({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.lecturer,
    required this.statusLabel,
    required this.statusColor,
    required this.statusTextColor,
  });
}

class ScheduleCard extends StatelessWidget {
  final ScheduleItem schedule;
  final bool isLecturer;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onToggleTeaching;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.isLecturer = false,
    this.isActive = false,
    this.isCompleted = false,
    this.onToggleTeaching,
  });

  @override
  Widget build(BuildContext context) {
    final actionLabel =
        isLecturer ? (isActive ? 'Stop Kelas' : 'Mulai Kelas') : 'Scan Absen';
    final actionColor = isLecturer && isActive
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
                  height: 1.5,
                  letterSpacing: 0.5,
                  color: AppColors.text400,
                ),
              ),
              const Spacer(),
              if (statusLabel.isNotEmpty)
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
            schedule.title,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w500,
              fontSize: Responsive.fontSize(context, 16),
              height: 1.5,
              letterSpacing: 0.5,
              color: AppColors.text500,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          Text(
            schedule.lecturer,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: Responsive.fontSize(context, 14),
              height: 1.5,
              letterSpacing: 0.5,
              color: AppColors.text400,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
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
                  onPressed: (isLecturer && isCompleted)
                      ? null
                      : () {
                          if (isLecturer) {
                            onToggleTeaching?.call();
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AttendanceScannerScreen(),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(
                      Responsive.spacing(context, 34),
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: (isLecturer && isCompleted)
                        ? AppColors.primary500.withValues(alpha: 0.6)
                        : actionColor,
                    disabledBackgroundColor: AppColors.primary500.withValues(alpha: 0.6),
                    disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
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
                        color: (isLecturer && isCompleted)
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

