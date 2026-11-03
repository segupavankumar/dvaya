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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              _sectionHeader('Gym Profile'),
              const SizedBox(height: 12),
              _buildProfileSection(gym),
              const SizedBox(height: 24),
              _sectionHeader('Advertising Banners'),
              const SizedBox(height: 12),
              _buildBannersSection(gym),
              const SizedBox(height: 24),
              _sectionHeader('Dashboard Customization'),
              const SizedBox(height: 12),
              _buildDashboardConfig(dashConfig),
              const SizedBox(height: 24),
              _sectionHeader('Subscription Plans'),
              const SizedBox(height: 12),
              _buildPlansSection(),
              const SizedBox(height: 24),
              _sectionHeader('Appearance'),
              const SizedBox(height: 12),
              Container(
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
          Divider(color: AppColors.border),
          _profileField('Address', gym.address, Icons.location_on_outlined),
          Divider(color: AppColors.border),
          _profileField('Phone', gym.phone, Icons.phone_outlined),
          Divider(color: AppColors.border),
          _profileField('Timings', gym.timings, Icons.access_time_outlined),
          Divider(color: AppColors.border),
          _profileField('Description', gym.description, Icons.description_outlined),
        ],
      ),
    );
  }

  Widget _profileField(String label, String value, IconData icon) {
    return InkWell(
      onTap: () => _showEditFieldSheet(label, value),
      child: Padding(
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
            const Icon(Icons.edit_outlined, color: AppColors.accent, size: 18),
          ],
        ),
      ),
    );
  }

  void _showEditFieldSheet(String label, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Edit $label', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: label == 'Description' ? 3 : 1,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(labelText: label, labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$label updated'),
                    backgroundColor: AppColors.success,
                  ));
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannersSection(Gym gym) {
    final icons = [Icons.local_offer, Icons.emoji_events, Icons.star, Icons.campaign];
    final gradients = [
      [AppColors.accent.withValues(alpha: 0.2), AppColors.accent.withValues(alpha: 0.06)],
      [AppColors.success.withValues(alpha: 0.15), AppColors.success.withValues(alpha: 0.04)],
      [AppColors.warning.withValues(alpha: 0.15), AppColors.warning.withValues(alpha: 0.04)],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          ...gym.bannerUrls.asMap().entries.map<Widget>((entry) {
            final i = entry.key;
            final banner = entry.value;
            final grad = gradients[i % gradients.length];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icons[i % icons.length], color: AppColors.accent, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(banner, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary))),
                  Switch(
                    value: _bannerToggles[banner] ?? true,
                    onChanged: (v) => setState(() => _bannerToggles[banner] = v),
                    activeThumbColor: AppColors.accent,
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAddBannerSheet(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Banner'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBannerSheet() {
    final titleCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Add Banner', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Create a promotional banner for your members', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtrl,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Banner Title',
                hintText: 'e.g. Summer Special: 20% off Annual Plans',
                labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
                hintStyle: GoogleFonts.poppins(color: AppColors.textTertiary, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (titleCtrl.text.isNotEmpty) {
                    setState(() => _bannerToggles[titleCtrl.text] = true);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(titleCtrl.text.isNotEmpty ? 'Banner "${titleCtrl.text}" added' : 'Banner added'),
                    backgroundColor: AppColors.success,
                  ));
                },
                child: const Text('Add Banner'),
              ),
            ),
          ],
        ),
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
          ...subscriptionPlans.map((plan) => InkWell(
            onTap: () => _showEditPlanSheet(plan),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
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
                  const SizedBox(width: 8),
                  Icon(Icons.edit_outlined, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ),
          )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAddPlanSheet(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Plan'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPlanSheet(SubscriptionPlan plan) {
    final nameCtrl = TextEditingController(text: plan.name);
    final priceCtrl = TextEditingController(text: plan.price.toStringAsFixed(0));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Edit Plan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(labelText: 'Plan Name', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(labelText: 'Price (₹)', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${nameCtrl.text} updated'),
                    backgroundColor: AppColors.success,
                  ));
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPlanSheet() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Add Plan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(labelText: 'Plan Name', hintText: 'e.g. Weekly', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(labelText: 'Duration (months)', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(labelText: 'Price (₹)', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(nameCtrl.text.isNotEmpty ? '${nameCtrl.text} plan added' : 'New plan added'),
                    backgroundColor: AppColors.success,
                  ));
                },
                child: const Text('Add Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
