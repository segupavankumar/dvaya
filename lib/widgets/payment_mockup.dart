import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PaymentMockup extends StatefulWidget {
  final double amount;
  final String plan;

  const PaymentMockup({super.key, required this.amount, required this.plan});

  @override
  State<PaymentMockup> createState() => _PaymentMockupState();
}

class _PaymentMockupState extends State<PaymentMockup> {
  String _selected = 'UPI';
  bool _processing = false;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            Text('Payment Successful!', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('This is a demo payment', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Text('Pay for ${widget.plan}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Amount: ₹${widget.amount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.accent)),
          const SizedBox(height: 20),
          Text('Select Payment Method', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ..._methodTile('UPI', Icons.account_balance_wallet_outlined),
          ..._methodTile('Card', Icons.credit_card_outlined),
          ..._methodTile('Net Banking', Icons.account_balance_outlined),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _processing ? null : _pay,
              child: _processing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Pay ₹${widget.amount.toStringAsFixed(0)}'),
            ),
          ),
          const SizedBox(height: 8),
          Center(child: Text('This is a demo — no real payment', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary))),
        ],
      ),
    );
  }

  List<Widget> _methodTile(String name, IconData icon) {
    return [
      InkWell(
        onTap: () => setState(() => _selected = name),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _selected == name ? AppColors.accent.withValues(alpha: 0.1) : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _selected == name ? AppColors.accent : AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: _selected == name ? AppColors.accent : AppColors.textSecondary, size: 22),
              const SizedBox(width: 12),
              Text(name, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
              const Spacer(),
              if (_selected == name) const Icon(Icons.check_circle, color: AppColors.accent, size: 20),
            ],
          ),
        ),
      ),
    ];
  }

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _processing = false; _done = true; });
  }
}
