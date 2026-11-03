import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../data/models.dart';
import '../../data/dummy_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/member_card.dart';
import 'member_detail.dart';

class MembersList extends ConsumerWidget {
  const MembersList({super.key});

  List<Member> _buildFullList(String gymId) {
    final real = members.where((m) => m.gymId == gymId).toList();
    // Generate extra dummy members for scrolling
    final extras = extraMemberNames.map((name) {
      final statuses = [MemberStatus.active, MemberStatus.active, MemberStatus.active, MemberStatus.expiring, MemberStatus.expired];
      final plans = ['Monthly', 'Quarterly', 'Annual'];
      final idx = extraMemberNames.indexOf(name);
      return Member(
        id: 'extra_$idx',
        gymId: gymId,
        name: name,
        age: 22 + (idx % 20),
        gender: idx % 2 == 0 ? 'Male' : 'Female',
        phone: '+91 ${90000 + idx * 111}',
        email: '${name.toLowerCase().replaceAll(' ', '.')}@email.com',
        emergencyContact: '+91 ${80000 + idx * 111}',
        joinDate: now.subtract(Duration(days: 30 + idx * 5)),
        status: statuses[idx % statuses.length],
        plan: plans[idx % plans.length],
        planAmount: [1500.0, 4000.0, 12000.0][idx % 3],
        planExpiry: now.add(Duration(days: -5 + idx * 3)),
        currentWeight: 60.0 + (idx % 30),
        startWeight: 62.0 + (idx % 30),
        bmi: 22.0 + (idx % 8),
        fatPercent: 15.0 + (idx % 15),
        musclePercent: 30.0 + (idx % 12),
        streak: idx % 20,
        goal: 'General fitness',
        goalProgress: (idx % 10) / 10,
      );
    }).toList();
    return [...real, ...extras];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final filter = ref.watch(selectedMemberFilterProvider);
    final search = ref.watch(memberSearchProvider);
    final gymId = auth.selectedGym!.id;

    var allMembers = _buildFullList(gymId);

    // Apply filter
    if (filter != 'All') {
      final status = {
        'Active': MemberStatus.active,
        'Expiring': MemberStatus.expiring,
        'Expired': MemberStatus.expired,
      }[filter];
      if (status != null) {
        allMembers = allMembers.where((m) => m.status == status).toList();
      }
    }

    // Apply search
    if (search.isNotEmpty) {
      allMembers = allMembers.where((m) => m.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text('Members', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 12),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => ref.read(memberSearchProvider.notifier).state = v,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Filter tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['All', 'Active', 'Expiring', 'Expired'].map((label) {
                  final selected = filter == label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => ref.read(selectedMemberFilterProvider.notifier).state = label,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.accent : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? AppColors.accent : AppColors.border, width: 0.5),
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            // Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('${allMembers.length} members', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary)),
            ),
            // Member list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                itemCount: allMembers.length,
                itemBuilder: (context, index) {
                  final member = allMembers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MemberCard(
                      member: member,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MemberDetail(member: member)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => _showAddMemberSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddMemberSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
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
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Full Name', prefixIcon: Icon(Icons.person_outline, color: AppColors.textTertiary)),
              ),
              const SizedBox(height: 12),
              TextField(
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textTertiary)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.textTertiary)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Add Member'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
