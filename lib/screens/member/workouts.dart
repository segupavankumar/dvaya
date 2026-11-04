import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/responsive.dart';

class MemberWorkouts extends ConsumerStatefulWidget {
  const MemberWorkouts({super.key});

  @override
  ConsumerState<MemberWorkouts> createState() => _MemberWorkoutsState();
}

class _MemberWorkoutsState extends ConsumerState<MemberWorkouts> {
  late DateTime _selectedDate;
  final _completedExercises = <String>{};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final member = auth.selectedMember!;
    final workouts = getWorkoutsForMember(member.id);
    final dayWorkouts = workouts[_selectedDate];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Workouts', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: DesktopAwareCenter(
        desktopMaxWidth: 800,
        child: Column(
        children: [
          _buildDateBar(),
          Expanded(
            child: dayWorkouts == null || dayWorkouts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center, size: 48, color: AppColors.textTertiary),
                        const SizedBox(height: 12),
                        Text('No workout assigned', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
                        Text('for ${DateFormat('MMM d').format(_selectedDate)}', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: dayWorkouts.length,
                    itemBuilder: (_, i) => _buildWorkoutSection(dayWorkouts[i]),
                  ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDateBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 14,
        itemBuilder: (_, i) {
          final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i));
          final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 48,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? AppColors.accent : AppColors.border, width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E').format(date).substring(0, 2), style: GoogleFonts.poppins(fontSize: 11, color: isSelected ? Colors.white : AppColors.textTertiary)),
                  const SizedBox(height: 2),
                  Text('${date.day}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textPrimary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutSection(WorkoutDay workout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(workout.title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        if (workout.assignedBy != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Assigned by ${workout.assignedBy}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent)),
          ),
        const SizedBox(height: 16),
        ...workout.exercises.map((ex) => _buildExerciseTile(ex)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExerciseTile(Exercise ex) {
    final key = '${_selectedDate.toIso8601String()}_${ex.name}';
    final done = _completedExercises.contains(key);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: done ? AppColors.success.withValues(alpha: 0.3) : AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              if (done) { _completedExercises.remove(key); } else { _completedExercises.add(key); }
            }),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: done ? AppColors.success : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: done ? AppColors.success : AppColors.textTertiary, width: 1.5),
              ),
              child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex.name, style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: done ? AppColors.textSecondary : AppColors.textPrimary,
                  decoration: done ? TextDecoration.lineThrough : null,
                )),
                const SizedBox(height: 2),
                Text(
                  '${ex.sets} sets × ${ex.reps} reps${ex.weight != null ? ' @ ${ex.weight!.toStringAsFixed(0)}kg' : ''}',
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(ex.muscleGroup, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
