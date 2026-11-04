import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/adaptive_shell.dart';
import 'dashboard.dart';
import 'members_list.dart';
import 'settings.dart';

class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(ownerTabProvider);

    return AdaptiveShell(
      currentIndex: currentIndex,
      onTap: (i) => ref.read(ownerTabProvider.notifier).state = i,
      screens: [
        OwnerDashboard(),
        MembersList(),
        OwnerSettings(),
      ],
      destinations: const [
        AdaptiveDestination(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Members',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      floatingActionButton: currentIndex == 1
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.accent,
              onPressed: () => _showAddMemberSheet(context),
              child: const Icon(Icons.person_add, color: Colors.white),
            ),
    );
  }

  void _showAddMemberSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String selectedPlan = 'Monthly';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              Text('Add New Member', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(hintText: 'Full Name', prefixIcon: Icon(Icons.person_outline, color: AppColors.textTertiary)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(hintText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textTertiary)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.textTertiary)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedPlan,
                dropdownColor: AppColors.surfaceElevated,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Plan',
                  labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.card_membership, color: AppColors.textTertiary),
                ),
                items: ['Monthly - ₹1,500', 'Quarterly - ₹4,000', 'Annual - ₹12,000']
                    .map((p) => DropdownMenuItem(value: p.split(' - ').first, child: Text(p)))
                    .toList(),
                onChanged: (v) => setSheetState(() => selectedPlan = v!),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(nameCtrl.text.isNotEmpty
                          ? '${nameCtrl.text} added as a new member'
                          : 'New member added'),
                      backgroundColor: AppColors.success,
                    ));
                  },
                  child: const Text('Add Member'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
