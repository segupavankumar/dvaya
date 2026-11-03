import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';

class DietCard extends StatelessWidget {
  final Meal meal;

  const DietCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Text(meal.label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const Spacer(),
              Text('${meal.totalCalories} cal', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
            ],
          ),
          const SizedBox(height: 8),
          ...meal.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(child: Text(item.name, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary))),
                Text(item.quantity, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                const SizedBox(width: 12),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${item.calories}',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary, fontFeatures: const [FontFeature.tabularFigures()]),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
