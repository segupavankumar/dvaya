import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/models.dart';
import 'coach_member_detail.dart';
import '../../widgets/responsive.dart';

class CoachMembers extends ConsumerStatefulWidget {
  const CoachMembers({super.key});

  @override
  ConsumerState<CoachMembers> createState() => _CoachMembersState();
}

class _CoachMembersState extends ConsumerState<CoachMembers> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final assignedMembers = ref.watch(coachAssignedMembersProvider);
    final filtered = assignedMembers.where((m) =>
        m.name.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('My Trainees', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: DesktopAwareCenter(
          desktopMaxWidth: 1000,
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search trainees...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textTertiary),
                prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('${filtered.length} trainee${filtered.length != 1 ? 's' : ''}', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, color: AppColors.textTertiary, size: 48),
                        const SizedBox(height: 12),
                        Text(_search.isEmpty ? 'No trainees assigned' : 'No matches found', style: GoogleFonts.poppins(color: AppColors.textTertiary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _memberTile(context, filtered[index]),
                  ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _memberTile(BuildContext context, Member member) {
    final lastVisit = member.attendance.isNotEmpty
        ? DateFormat('MMM d').format(member.attendance.last.date)
        : 'No visits';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CoachMemberDetail(member: member))),
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
                radius: 24,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: Text(member.name[0], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.accent)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('Goal: ${member.goal ?? 'Not set'}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                    Text('Last visit: $lastVisit  •  Streak: ${member.streak}d', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                  ],
                ),
              ),
              Column(
                children: [
                  _statusPill(member.status),
                  const SizedBox(height: 4),
                  Text('${member.currentWeight}kg', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(MemberStatus status) {
    final (label, color) = switch (status) {
      MemberStatus.active => ('Active', AppColors.success),
      MemberStatus.expiring => ('Expiring', AppColors.warning),
      MemberStatus.expired => ('Expired', AppColors.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
