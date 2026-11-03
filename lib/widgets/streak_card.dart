import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StreakCard extends StatelessWidget {
  final int streak;
  final List<bool> weekDots;

  const StreakCard({super.key, required this.streak, required this.weekDots});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Icon(Icons.local_fire_department, color: streak > 0 ? AppColors.accent : AppColors.textTertiary, size: 22),
              const SizedBox(width: 8),
              Text('$streak Day Streak', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final active = i < weekDots.length && weekDots[i];
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: active ? AppColors.accent : AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      active ? Icons.check : Icons.close,
                      size: 16,
                      color: active ? Colors.white : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(days[i], style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
