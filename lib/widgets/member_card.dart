import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback? onTap;
  final VoidCallback? onNotify;

  const MemberCard({super.key, required this.member, this.onTap, this.onNotify});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                  Row(
                    children: [
                      Text(member.plan, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      _statusPill(member.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: member.streak > 0 ? AppColors.accent : AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text('${member.streak}d streak', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                      if (member.trainer != null) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.person_outline, size: 14, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(member.trainer!, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (onNotify != null)
              IconButton(
                onPressed: onNotify,
                icon: const Icon(Icons.notifications_outlined, size: 20),
                color: AppColors.accent,
                tooltip: 'Send notification',
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
              ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
