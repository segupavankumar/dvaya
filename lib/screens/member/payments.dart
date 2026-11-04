import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/models.dart';
import '../../widgets/responsive.dart';

class MemberPayments extends ConsumerWidget {
  const MemberPayments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final member = auth.selectedMember!;
    final daysLeft = member.planExpiry.difference(DateTime.now()).inDays;
    final isExpired = daysLeft < 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Payments', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          padding: const EdgeInsets.all(20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentPlan(member, daysLeft, isExpired),
            const SizedBox(height: 16),
            if (!isExpired && daysLeft <= 7)
              _buildPayButton(context, member),
            if (isExpired)
              _buildPayButton(context, member),
            const SizedBox(height: 24),
            Text('Payment History', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            ...member.payments.map((p) => _buildPaymentItem(p)),
            const SizedBox(height: 24),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlan(Member member, int daysLeft, bool isExpired) {
    final statusColor = isExpired ? AppColors.danger : (daysLeft <= 7 ? AppColors.warning : AppColors.success);
    final statusText = isExpired ? 'Expired' : (daysLeft <= 7 ? 'Expiring Soon' : 'Active');
    final progress = isExpired ? 1.0 : (1.0 - daysLeft / 30).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Current Plan', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusText, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(member.plan, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text('₹${member.planAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.accent)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Expires: ${DateFormat('d MMM yyyy').format(member.planExpiry)}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Text(
                isExpired ? 'Expired ${-daysLeft}d ago' : '$daysLeft days left',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation(statusColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, Member member) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showPaymentSheet(context, member),
        child: Text('Pay Now - ₹${member.planAmount.toStringAsFixed(0)}'),
      ),
    );
  }

  void _showPaymentSheet(BuildContext context, Member member) {
    int selectedMethod = 0;
    final methods = ['UPI', 'Credit/Debit Card', 'Net Banking'];
    final icons = [Icons.account_balance, Icons.credit_card, Icons.language];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('Payment', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('${member.plan} Plan', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('₹', style: GoogleFonts.poppins(fontSize: 20, color: AppColors.textSecondary)),
                    Text(member.planAmount.toStringAsFixed(0), style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFeatures: const [FontFeature.tabularFigures()])),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(methods.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => setSheetState(() => selectedMethod = i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selectedMethod == i ? AppColors.accent.withValues(alpha: 0.1) : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selectedMethod == i ? AppColors.accent : AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(icons[i], color: selectedMethod == i ? AppColors.accent : AppColors.textSecondary, size: 22),
                        const SizedBox(width: 14),
                        Text(methods[i], style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                        const Spacer(),
                        if (selectedMethod == i) const Icon(Icons.check_circle, color: AppColors.accent, size: 20),
                      ],
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showSuccessDialog(context);
                  },
                  child: Text('Pay ₹${member.planAmount.toStringAsFixed(0)}'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 20),
              Text('Payment Successful!', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text('This is a demo. No actual payment was processed.', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentItem(Payment payment) {
    final isPaid = payment.status == 'Paid';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isPaid ? AppColors.success : AppColors.danger).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(isPaid ? Icons.check_circle_outline : Icons.pending_outlined, color: isPaid ? AppColors.success : AppColors.danger, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.plan, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                Text(DateFormat('d MMM yyyy').format(payment.date), style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${payment.amount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontFeatures: const [FontFeature.tabularFigures()])),
              Text(payment.status, style: GoogleFonts.poppins(fontSize: 11, color: isPaid ? AppColors.success : AppColors.danger)),
            ],
          ),
        ],
      ),
    );
  }
}
