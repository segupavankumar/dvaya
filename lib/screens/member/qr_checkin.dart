import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/dummy_data.dart';
import '../../widgets/responsive.dart';

class QrCheckin extends ConsumerStatefulWidget {
  const QrCheckin({super.key});

  @override
  ConsumerState<QrCheckin> createState() => _QrCheckinState();
}

class _QrCheckinState extends ConsumerState<QrCheckin> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  int _countdown = 30;
  Timer? _timer;
  late String _qrData;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _regenerateQr();
    _startTimer();
  }

  void _regenerateQr() {
    final auth = ref.read(authProvider);
    _qrData = 'dvaya:${auth.selectedMember!.id}:${DateTime.now().millisecondsSinceEpoch}';
  }

  void _startTimer() {
    _timer?.cancel();
    _countdown = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _countdown--;
        if (_countdown <= 0) {
          _regenerateQr();
          _countdown = 30;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final member = auth.selectedMember!;
    final today = DateTime(now.year, now.month, now.day);
    final checkedInToday = member.attendance.any((a) => a.date.year == today.year && a.date.month == today.month && a.date.day == today.day);

    final weekHistory = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return member.attendance.any((a) => a.date.year == d.year && a.date.month == d.month && a.date.day == d.day);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('QR Check-In', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveCenter(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: Text(member.name[0], style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.accent)),
              ),
              const SizedBox(height: 12),
              Text(member.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text(auth.selectedGym!.name, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, child) => Transform.scale(scale: _pulseAnim.value, child: child),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5),
                    ],
                  ),
                  child: QrImageView(data: _qrData, version: QrVersions.auto, size: 200),
                ),
              ),
              const SizedBox(height: 20),
              Text('Show this at the entrance', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 16, color: AppColors.textTertiary),
                  const SizedBox(width: 6),
                  Text('Refreshes in ${_countdown}s', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary, fontFeatures: const [FontFeature.tabularFigures()])),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          checkedInToday ? Icons.check_circle : Icons.cancel_outlined,
                          color: checkedInToday ? AppColors.success : AppColors.textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          checkedInToday ? 'Checked in today' : 'Not checked in today',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: checkedInToday ? AppColors.success : AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Last 7 days', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (i) {
                        final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        final dayIndex = (today.subtract(Duration(days: 6 - i)).weekday - 1) % 7;
                        return Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: weekHistory[i] ? AppColors.accent : AppColors.surfaceElevated,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                weekHistory[i] ? Icons.check : Icons.close,
                                size: 14,
                                color: weekHistory[i] ? Colors.white : AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(days[dayIndex], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
