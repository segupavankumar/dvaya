import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/models.dart';
import '../../providers/settings_provider.dart';
import 'coach_member_detail.dart';

class CoachHome extends ConsumerWidget {
  const CoachHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final coach = auth.selectedCoach!;
    final gym = auth.selectedGym!;
    final assignedMembers = ref.watch(coachAssignedMembersProvider);

    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);
    final checkedInToday = coach.attendance.any((a) =>
        a.date.year == todayKey.year && a.date.month == todayKey.month && a.date.day == todayKey.day);

    final activeMembers = assignedMembers.where((m) => m.status == MemberStatus.active).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, ${coach.name.split(' ').last}', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text(gym.name, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: checkedInToday ? AppColors.success.withValues(alpha: 0.15) : AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(checkedInToday ? Icons.check_circle : Icons.schedule, size: 16, color: checkedInToday ? AppColors.success : AppColors.warning),
                        const SizedBox(width: 4),
                        Text(checkedInToday ? 'Checked In' : 'Not In', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: checkedInToday ? AppColors.success : AppColors.warning)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _statCard('Trainees', '${assignedMembers.length}', Icons.people, AppColors.accent),
                  const SizedBox(width: 12),
                  _statCard('Active', '$activeMembers', Icons.check_circle_outline, AppColors.success),
                  const SizedBox(width: 12),
                  _statCard('Experience', '${coach.yearsExperience}yr', Icons.star_outline, AppColors.warning),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Specialization', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(coach.specialization, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.accent)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Your Trainees', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              if (assignedMembers.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.people_outline, color: AppColors.textTertiary, size: 48),
                      const SizedBox(height: 12),
                      Text('No trainees assigned', style: GoogleFonts.poppins(color: AppColors.textTertiary)),
                    ],
                  ),
                )
              else
                ...assignedMembers.map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _traineeCard(context, ref, member),
                )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  Widget _traineeCard(BuildContext context, WidgetRef ref, Member member) {
    final lastVisit = member.attendance.isNotEmpty
        ? DateFormat('MMM d').format(member.attendance.last.date)
        : 'No visits';

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CoachMemberDetail(member: member)));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.accent.withValues(alpha: 0.15),
              child: Text(member.name[0], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.accent)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('Last visit: $lastVisit  •  Streak: ${member.streak}d', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            _statusDot(member.status),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _statusDot(MemberStatus status) {
    final color = switch (status) {
      MemberStatus.active => AppColors.success,
      MemberStatus.expiring => AppColors.warning,
      MemberStatus.expired => AppColors.danger,
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
