import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/responsive.dart';

class CoachCheckin extends ConsumerStatefulWidget {
  const CoachCheckin({super.key});

  @override
  ConsumerState<CoachCheckin> createState() => _CoachCheckinState();
}

class _CoachCheckinState extends ConsumerState<CoachCheckin> {
  bool _checkedIn = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  @override
  Widget build(BuildContext context) {
    final coach = ref.watch(authProvider).selectedCoach!;
    final recentAttendance = coach.attendance.reversed.take(10).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Check In / Out', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          maxWidth: 480,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _checkedIn ? AppColors.success.withValues(alpha: 0.5) : AppColors.border, width: _checkedIn ? 1.5 : 0.5),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _checkedIn ? AppColors.success.withValues(alpha: 0.15) : AppColors.accent.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      _checkedIn ? Icons.check_circle : Icons.login,
                      size: 40,
                      color: _checkedIn ? AppColors.success : AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _checkedIn ? 'You are checked in' : 'Ready to check in?',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  if (_checkInTime != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login, size: 16, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text('In: ${DateFormat('hh:mm a').format(_checkInTime!)}', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.success)),
                        if (_checkOutTime != null) ...[
                          const SizedBox(width: 16),
                          Icon(Icons.logout, size: 16, color: AppColors.danger),
                          const SizedBox(width: 6),
                          Text('Out: ${DateFormat('hh:mm a').format(_checkOutTime!)}', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.danger)),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (!_checkedIn) {
                            _checkedIn = true;
                            _checkInTime = DateTime.now();
                            _checkOutTime = null;
                          } else {
                            _checkedIn = false;
                            _checkOutTime = DateTime.now();
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(_checkedIn ? 'Checked in successfully' : 'Checked out successfully'),
                          backgroundColor: _checkedIn ? AppColors.success : AppColors.accent,
                          behavior: SnackBarBehavior.floating,
                        ));
                      },
                      icon: Icon(_checkedIn ? Icons.logout : Icons.login, size: 20),
                      label: Text(_checkedIn ? 'Check Out' : 'Check In', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _checkedIn ? AppColors.danger : AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Recent Attendance', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const Spacer(),
                Text('${coach.attendance.length} total', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
            const SizedBox(height: 12),
            if (recentAttendance.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Center(child: Text('No attendance records yet', style: GoogleFonts.poppins(color: AppColors.textTertiary))),
              )
            else
              ...recentAttendance.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat('EEEE, MMM d, yyyy').format(a.date), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                            Text('Checked in at ${a.checkInTime}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          ],
        ),
        ),
      ),
    );
  }
}
