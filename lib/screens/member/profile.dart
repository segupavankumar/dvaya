import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import 'payments.dart';
import 'coach_profile_view.dart';
import '../../widgets/responsive.dart';

class MemberProfile extends ConsumerWidget {
  const MemberProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final member = auth.selectedMember!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        child: DesktopAwareCenter(
          desktopMaxWidth: 800,
          padding: const EdgeInsets.all(20),
          child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.accent.withValues(alpha: 0.15),
              child: Text(member.name[0], style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.accent)),
            ),
            const SizedBox(height: 16),
            Text(member.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(auth.selectedGym!.name, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            _infoCard([
              _infoRow(Icons.phone_outlined, 'Phone', member.phone),
              _infoRow(Icons.email_outlined, 'Email', member.email),
              _infoRow(Icons.emergency_outlined, 'Emergency', member.emergencyContact),
              _infoRow(Icons.calendar_today_outlined, 'Member Since', DateFormat('d MMM yyyy').format(member.joinDate)),
              if (member.trainer != null)
                _trainerRow(context, member.trainer!),
            ]),
            const SizedBox(height: 16),
            _buildQuickMetrics(member),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showEditProfile(context, member),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberPayments())),
                icon: const Icon(Icons.payment, size: 18),
                label: const Text('Payments'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(ref.watch(themeModeProvider) == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, color: AppColors.accent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dark Mode', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        Text(ref.watch(themeModeProvider) == ThemeMode.dark ? 'Currently dark' : 'Currently light', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                      ],
                    ),
                  ),
                  Switch(
                    value: ref.watch(themeModeProvider) == ThemeMode.dark,
                    onChanged: (v) => ref.read(themeModeProvider.notifier).state = v ? ThemeMode.dark : ThemeMode.light,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                child: Text('Logout', style: GoogleFonts.poppins(color: AppColors.danger, fontWeight: FontWeight.w500)),
              ),
            ),
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
          SizedBox(width: 80, child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _trainerRow(BuildContext context, String trainerName) {
    final coach = coaches.cast<Coach?>().firstWhere(
      (c) => c!.name == trainerName,
      orElse: () => null,
    );

    return InkWell(
      onTap: coach != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => CoachProfileView(coach: coach)))
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.person_outline, size: 18, color: AppColors.textTertiary),
            const SizedBox(width: 14),
            SizedBox(width: 80, child: Text('Trainer', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary))),
            Expanded(child: Text(trainerName, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500))),
            if (coach != null)
              Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMetrics(dynamic member) {
    return Container(
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
          _metricItem('Weight', '${member.currentWeight}kg', AppColors.accent),
          _metricItem('BMI', '${member.bmi}', AppColors.warning),
          _metricItem('Fat', '${member.fatPercent}%', AppColors.danger),
          _metricItem('Muscle', '${member.musclePercent}%', AppColors.success),
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: color, fontFeatures: const [FontFeature.tabularFigures()])),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  void _showEditProfile(BuildContext context, dynamic member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Edit Profile', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: member.name),
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: member.phone),
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: member.email),
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Save'))),
          ],
        ),
      ),
    );
  }
}
