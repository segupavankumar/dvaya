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
import '../../widgets/responsive.dart';

class MembersList extends ConsumerWidget {
  const MembersList({super.key});

  List<Member> _buildFullList(String gymId) {
    final real = members.where((m) => m.gymId == gymId).toList();
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

    if (search.isNotEmpty) {
      allMembers = allMembers.where((m) => m.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 600,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Text('Members', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.campaign_outlined, color: AppColors.accent),
                    onPressed: () => _showBroadcastSheet(context),
                    tooltip: 'Send broadcast notification',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => ref.read(memberSearchProvider.notifier).state = v,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text('${allMembers.length} members', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
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
                      onNotify: () => _showNotifyMemberSheet(context, member),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => _showAddMemberSheet(context),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  void _showNotifyMemberSheet(BuildContext context, Member member) {
    String selectedType = 'Payment Reminder';
    final msgCtrl = TextEditingController();
    final types = ['Payment Reminder', 'Workout Reminder', 'Diet Reminder', 'General Message'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('Send Notification', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('To: ${member.name}', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.accent)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: types.map((type) {
                  final selected = selectedType == type;
                  return InkWell(
                    onTap: () => setSheetState(() => selectedType = type),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.accent : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? AppColors.accent : AppColors.border),
                      ),
                      child: Text(type, style: GoogleFonts.poppins(fontSize: 12, color: selected ? Colors.white : AppColors.textSecondary)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: msgCtrl,
                maxLines: 3,
                style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Custom message (optional)...',
                  hintStyle: GoogleFonts.poppins(color: AppColors.textTertiary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('WhatsApp reminder sent to ${member.name}'),
                          backgroundColor: AppColors.success,
                        ));
                      },
                      icon: const Icon(Icons.chat, size: 18),
                      label: const Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.success, side: const BorderSide(color: AppColors.success), padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('$selectedType sent to ${member.name}'),
                          backgroundColor: AppColors.success,
                        ));
                      },
                      icon: const Icon(Icons.send, size: 18),
                      label: const Text('Send'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBroadcastSheet(BuildContext context) {
    final msgCtrl = TextEditingController();
    String target = 'All Members';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('Broadcast Notification', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: target,
                dropdownColor: AppColors.surfaceElevated,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: 'Send to', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                items: ['All Members', 'Active Only', 'Expiring Soon', 'Expired']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setSheetState(() => target = v!),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: msgCtrl,
                maxLines: 3,
                style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: GoogleFonts.poppins(color: AppColors.textTertiary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Broadcast sent to $target'),
                      backgroundColor: AppColors.success,
                    ));
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Send Broadcast'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMemberSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

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
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(nameCtrl.text.isNotEmpty ? '${nameCtrl.text} added' : 'New member added'),
                      backgroundColor: AppColors.success,
                    ));
                  },
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
