import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../data/models.dart';
import '../../widgets/responsive.dart';

class CoachProfileView extends StatelessWidget {
  final Coach coach;
  const CoachProfileView({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('My Trainer', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        child: DesktopAwareCenter(
          desktopMaxWidth: 800,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.success.withValues(alpha: 0.15),
                child: Text(coach.name.split(' ').last[0], style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.success)),
              ),
              const SizedBox(height: 16),
              Text(coach.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(coach.specialization, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.accent)),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _metricItem('Experience', '${coach.yearsExperience} yr', AppColors.warning),
                    _metricItem('Trainees', '${coach.assignedMemberIds.length}', AppColors.success),
                    _metricItem('Attendance', '${coach.attendance.length}', AppColors.accent),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _infoCard([
                _infoRow(Icons.sports_outlined, 'Specialization', coach.specialization),
                _infoRow(Icons.star_outline, 'Experience', '${coach.yearsExperience} years'),
                _infoRow(Icons.phone_outlined, 'Phone', coach.phone),
                _infoRow(Icons.email_outlined, 'Email', coach.email),
              ]),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 14),
          SizedBox(width: 100, child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
