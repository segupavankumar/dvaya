import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutDay workout;
  final bool showCheckboxes;

  const WorkoutCard({super.key, required this.workout, this.showCheckboxes = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(workout.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
              ),
              const Spacer(),
              if (workout.assignedBy != null)
                Text('by ${workout.assignedBy}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 12),
          ...workout.exercises.map((e) => _exerciseRow(e)),
        ],
      ),
    );
  }

  Widget _exerciseRow(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (showCheckboxes) ...[
            SizedBox(
              width: 20,
              height: 20,
              child: StatefulBuilder(
                builder: (context, setState) => Checkbox(
                  value: exercise.completed,
                  onChanged: (v) => setState(() => exercise.completed = v ?? false),
                  activeColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.textTertiary),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(exercise.name, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
          ),
          Text(
            '${exercise.sets}×${exercise.reps}${exercise.weight != null ? ' @ ${exercise.weight!.toStringAsFixed(0)}kg' : ''}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
