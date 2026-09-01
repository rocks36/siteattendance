import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum AttendanceStatus {
  present,
  absent,
  halfDay,
  paidLeave,
  unpaidLeave,
  overtime,
}

class StatusBadgeWidget extends StatelessWidget {
  final AttendanceStatus status;
  final bool compact;

  const StatusBadgeWidget({
    required this.status,
    this.compact = false,
    super.key,
  });

  static String labelFor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return 'P';
      case AttendanceStatus.absent:
        return 'A';
      case AttendanceStatus.halfDay:
        return 'HD';
      case AttendanceStatus.paidLeave:
        return 'PL';
      case AttendanceStatus.unpaidLeave:
        return 'UL';
      case AttendanceStatus.overtime:
        return 'OT';
    }
  }

  static String fullLabelFor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.paidLeave:
        return 'Paid Leave';
      case AttendanceStatus.unpaidLeave:
        return 'Unpaid Leave';
      case AttendanceStatus.overtime:
        return 'Overtime';
    }
  }

  static Color colorFor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return AppTheme.statusPresent;
      case AttendanceStatus.absent:
        return AppTheme.statusAbsent;
      case AttendanceStatus.halfDay:
        return AppTheme.statusHalfDay;
      case AttendanceStatus.paidLeave:
        return AppTheme.statusLeave;
      case AttendanceStatus.unpaidLeave:
        return AppTheme.purple;
      case AttendanceStatus.overtime:
        return AppTheme.statusOvertime;
    }
  }

  static Color bgColorFor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return AppTheme.successLight;
      case AttendanceStatus.absent:
        return AppTheme.errorLight;
      case AttendanceStatus.halfDay:
        return AppTheme.warningLight;
      case AttendanceStatus.paidLeave:
        return AppTheme.purpleLight;
      case AttendanceStatus.unpaidLeave:
        return AppTheme.purpleLight;
      case AttendanceStatus.overtime:
        return AppTheme.infoLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(status);
    final bgColor = bgColorFor(status);
    final label = compact ? labelFor(status) : fullLabelFor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
