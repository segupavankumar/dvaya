import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? _step; // null = role select, 'owner' = gym pick, 'member_type' = gym or solo, 'member_gym' = pick gym, 'member_pick' = pick member

  Gym? _selectedGym;

  void _reset() => setState(() { _step = null; _selectedGym = null; });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),
              _buildLogo(),
              const SizedBox(height: 60),
              if (_step == null) _buildRoleSelection(),
              if (_step == 'owner') _buildOwnerPicker(),
              if (_step == 'member_type') _buildMemberTypePicker(),
              if (_step == 'member_gym') _buildMemberGymPicker(),
              if (_step == 'member_pick') _buildMemberPicker(),
              if (_step != null) ...[
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _reset,
                  child: Text('Back to Login', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Text(
          'dvaya',
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Powered by Dvaya',
          style: GoogleFonts.poppins(color: AppColors.textTertiary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      children: [
        Text('Welcome', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Choose how you want to continue', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 32),
        _loginCard(
          icon: Icons.business_outlined,
          title: "I'm a Gym Owner",
          subtitle: 'Manage your gym, members & more',
          onTap: () => setState(() => _step = 'owner'),
        ),
        const SizedBox(height: 16),
        _loginCard(
          icon: Icons.fitness_center_outlined,
          title: "I'm a Member",
          subtitle: 'Access your workouts, diet & progress',
          onTap: () => setState(() => _step = 'member_type'),
        ),
      ],
    );
  }

  Widget _buildMemberTypePicker() {
    return Column(
      children: [
        Text('Member Login', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 32),
        _loginCard(
          icon: Icons.storefront_outlined,
          title: 'My Gym',
          subtitle: 'I train at a Dvaya-powered gym',
          onTap: () => setState(() => _step = 'member_gym'),
        ),
        const SizedBox(height: 16),
        _loginCard(
          icon: Icons.person_outline,
          title: 'Solo Mode',
          subtitle: 'I train independently',
          onTap: () {
            ref.read(authProvider.notifier).loginAsSolo();
          },
        ),
      ],
    );
  }

  Widget _buildOwnerPicker() {
    return Column(
      children: [
        Text('Select Your Gym', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 32),
        ...gyms.map((gym) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _gymCard(gym, onTap: () {
            ref.read(authProvider.notifier).loginAsOwner(gym);
          }),
        )),
      ],
    );
  }

  Widget _buildMemberGymPicker() {
    return Column(
      children: [
        Text('Select Your Gym', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 32),
        ...gyms.map((gym) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _gymCard(gym, onTap: () {
            setState(() { _selectedGym = gym; _step = 'member_pick'; });
          }),
        )),
      ],
    );
  }

  Widget _buildMemberPicker() {
    final gymMembers = members.where((m) => m.gymId == _selectedGym!.id).toList();
    return Column(
      children: [
        Text('Select Your Profile', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text(_selectedGym!.name, style: GoogleFonts.poppins(color: AppColors.accent, fontSize: 14)),
        const SizedBox(height: 32),
        ...gymMembers.map((member) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _memberCard(member, onTap: () {
            ref.read(authProvider.notifier).loginAsMember(_selectedGym!, member);
          }),
        )),
      ],
    );
  }

  Widget _loginCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.accent, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _gymCard(Gym gym, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(gym.name[0], style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.accent)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gym.name, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(gym.ownerName, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                  Text('${gym.totalMembers} members  •  ${gym.location}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _memberCard(Member member, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.accent.withValues(alpha: 0.15),
              child: Text(member.name[0], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.accent)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('${member.plan} • ${member.status.name.toUpperCase()}', style: GoogleFonts.poppins(fontSize: 12, color: _statusColor(member.status))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Color _statusColor(MemberStatus status) {
    switch (status) {
      case MemberStatus.active: return AppColors.success;
      case MemberStatus.expiring: return AppColors.warning;
      case MemberStatus.expired: return AppColors.danger;
    }
  }
}
