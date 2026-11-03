import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

class OwnerSettings extends ConsumerStatefulWidget {
  const OwnerSettings({super.key});

  @override
  ConsumerState<OwnerSettings> createState() => _OwnerSettingsState();
}

class _OwnerSettingsState extends ConsumerState<OwnerSettings> {
  final Map<String, bool> _bannerToggles = {};

  @override
  void initState() {
    super.initState();
    final gym = ref.read(authProvider).selectedGym!;
    for (var i = 0; i < gym.bannerUrls.length; i++) {
      _bannerToggles[gym.bannerUrls[i]] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gym = ref.watch(authProvider).selectedGym!;
    final dashConfig = ref.watch(dashboardConfigProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 24),

              // Gym Profile
              _sectionHeader('Gym Profile'),
              const SizedBox(height: 12),
              _buildProfileSection(gym),
              const SizedBox(height: 24),

              // Advertising Banners
              _sectionHeader('Advertising Banners'),
              const SizedBox(height: 12),
              _buildBannersSection(gym),
              const SizedBox(height: 24),

              // Dashboard Customization
              _sectionHeader('Dashboard Customization'),
              const SizedBox(height: 12),
              _buildDashboardConfig(dashConfig),
              const SizedBox(height: 24),

              // Subscription Plans
              _sectionHeader('Subscription Plans'),
              const SizedBox(height: 12),
              _buildPlansSection(),
              const SizedBox(height: 24),

              // Logout
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  icon: const Icon(Icons.logout, color: AppColors.danger),
                  label: Text('Logout', style: GoogleFonts.poppins(color: AppColors.danger)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary));
  }

  Widget _buildProfileSection(Gym gym) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          _profileField('Gym Name', gym.name, Icons.business),
          const Divider(color: AppColors.border),
          _profileField('Address', gym.address, Icons.location_on_outlined),
          const Divider(color: AppColors.border),
          _profileField('Phone', gym.phone, Icons.phone_outlined),
          const Divider(color: AppColors.border),
          _profileField('Timings', gym.timings, Icons.access_time_outlined),
          const Divider(color: AppColors.border),
          _profileField('Description', gym.description, Icons.description_outlined),
        ],
      ),
    );
  }

  Widget _profileField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                Text(value, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: AppColors.textTertiary, size: 18),
        ],
      ),
    );
  }

  Widget _buildBannersSection(Gym gym) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          ...gym.bannerUrls.map<Widget>((banner) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(child: Text(banner, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary))),
                Switch(
                  value: _bannerToggles[banner] ?? true,
                  onChanged: (v) => setState(() => _bannerToggles[banner] = v),
                  activeThumbColor: AppColors.accent,
                ),
              ],
            ),
          )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Banner'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardConfig(Map<String, bool> config) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: config.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(child: Text(entry.key, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary))),
                Switch(
                  value: entry.value,
                  onChanged: (_) => ref.read(dashboardConfigProvider.notifier).toggle(entry.key),
                  activeThumbColor: AppColors.accent,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlansSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          ...subscriptionPlans.map((plan) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('${plan.durationMonths}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.accent)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                      Text('${plan.durationMonths} month${plan.durationMonths > 1 ? 's' : ''}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                    ],
                  ),
                ),
                Text('₹${NumberFormat('#,##,###').format(plan.price.toInt())}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.accent)),
              ],
            ),
          )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Plan'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
            ),
          ),
        ],
      ),
    );
  }
}
