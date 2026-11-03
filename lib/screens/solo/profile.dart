import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../providers/auth_provider.dart';

class SoloProfile extends ConsumerWidget {
  const SoloProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = soloUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + name
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.accent.withValues(alpha: 0.15),
              child: Text(user.name[0], style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.accent)),
            ),
            const SizedBox(height: 14),
            Text(user.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text('Solo Fitness Enthusiast', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // Info cards
            _infoTile(Icons.person_outline, 'Age', '${user.age} years'),
            _infoTile(Icons.male, 'Gender', user.gender),
            _infoTile(Icons.phone_outlined, 'Phone', user.phone),
            _infoTile(Icons.email_outlined, 'Email', user.email),
            _infoTile(Icons.monitor_weight_outlined, 'Current Weight', '${user.currentWeight} kg'),
            _infoTile(Icons.local_fire_department, 'Streak', '${user.streak} days'),
            const SizedBox(height: 24),

            // Edit profile
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showEditProfileSheet(context),
                icon: const Icon(Icons.edit, size: 18),
                label: Text('Edit Profile', style: GoogleFonts.poppins()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
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
                borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 12),

            // Join a gym
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text('Join a Gym', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      content: Text(
                        'Contact a Dvaya-powered gym to get connected. They will add you as a member and you\'ll get access to personalized workouts, diet plans, and more.',
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Got it', style: GoogleFonts.poppins(color: AppColors.accent)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.storefront_outlined, size: 18),
                label: Text('Join a Gym', style: GoogleFonts.poppins()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                icon: const Icon(Icons.logout, size: 18),
                label: Text('Logout', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger.withValues(alpha: 0.15),
                  foregroundColor: AppColors.danger,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 14),
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final nameCtrl = TextEditingController(text: soloUser.name);
    final phoneCtrl = TextEditingController(text: soloUser.phone);
    final emailCtrl = TextEditingController(text: soloUser.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Edit Profile', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Name', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary))),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Phone', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary))),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Email', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated'), backgroundColor: AppColors.surface));
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
