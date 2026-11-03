import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';

class AttendanceCalendar extends StatefulWidget {
  final List<AttendanceRecord> records;

  const AttendanceCalendar({super.key, required this.records});

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Set<DateTime> get _markedDays => widget.records
      .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
      .toSet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 30)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => _selectedDay != null && isSameDay(day, _selectedDay),
        onDaySelected: (selected, focused) {
          setState(() {
            _selectedDay = selected;
            _focusedDay = focused;
          });
        },
        calendarStyle: CalendarStyle(
          defaultTextStyle: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
          weekendTextStyle: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
          outsideTextStyle: GoogleFonts.poppins(color: AppColors.textTertiary, fontSize: 13),
          todayDecoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
          selectedDecoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          markerSize: 6,
          markersMaxCount: 1,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
          leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
          rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.poppins(color: AppColors.textTertiary, fontSize: 12),
          weekendStyle: GoogleFonts.poppins(color: AppColors.textTertiary, fontSize: 12),
        ),
        eventLoader: (day) {
          final d = DateTime(day.year, day.month, day.day);
          return _markedDays.contains(d) ? ['attended'] : [];
        },
      ),
    );
  }
}
