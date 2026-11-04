import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/responsive.dart';

class SoloWorkouts extends StatefulWidget {
  const SoloWorkouts({super.key});

  @override
  State<SoloWorkouts> createState() => _SoloWorkoutsState();
}

class _SoloWorkoutsState extends State<SoloWorkouts> {
  late DateTime _selectedDate;
  late Map<DateTime, List<WorkoutDay>> _workouts;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _workouts = getSoloWorkouts();
  }

  List<DateTime> get _dateRange {
    return List.generate(14, (i) => _selectedDate.subtract(Duration(days: 7 - i)));
  }

  @override
  Widget build(BuildContext context) {
    final todayWorkouts = _workouts[_selectedDate] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Workouts', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExerciseSheet,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          maxWidth: 480,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker bar
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _dateRange.length,
                itemBuilder: (context, i) {
                  final date = _dateRange[i];
                  final isSelected = date == _selectedDate;
                  final hasWorkout = _workouts.containsKey(date);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      width: 52,
                      margin: const EdgeInsets.only(right: 8),
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
                          Text('${date.day}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textPrimary)),
                          if (hasWorkout)
                            Container(
                              width: 5, height: 5,
                              margin: const EdgeInsets.only(top: 3),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.white : AppColors.accent),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Workout content
            if (todayWorkouts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Icon(Icons.fitness_center, size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: 12),
                      Text('No workout logged', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text('Tap + to add exercises', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary)),
                    ],
                  ),
                ),
              )
            else
              ...todayWorkouts.map((workout) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(workout.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                          onPressed: () {
                            final ctrl = TextEditingController(text: workout.title);
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.surface,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                              builder: (ctx) => Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
                                    const SizedBox(height: 16),
                                    Text('Rename Workout', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                    const SizedBox(height: 16),
                                    TextField(controller: ctrl, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Workout Name', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary))),
                                    const SizedBox(height: 20),
                                    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Renamed to "${ctrl.text}"'), backgroundColor: AppColors.surface)); }, child: Text('Save'))),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...workout.exercises.map((ex) => _exerciseTile(ex)),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _showAddExerciseSheet,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('Add Exercise', style: GoogleFonts.poppins(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              )),

            // Templates section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text('Templates', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  _templateTile('Push Day', '5 exercises • Chest, Shoulders, Triceps'),
                  const SizedBox(height: 8),
                  _templateTile('Pull Day', '4 exercises • Back, Biceps'),
                  const SizedBox(height: 8),
                  _templateTile('Leg Day', '6 exercises • Quads, Hamstrings, Calves'),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
        ),
      ),
    );
  }

  Widget _exerciseTile(Exercise ex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Checkbox(
            value: ex.completed,
            onChanged: (v) => setState(() => ex.completed = v ?? false),
            activeColor: AppColors.accent,
            side: BorderSide(color: AppColors.textTertiary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex.name, style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ex.completed ? AppColors.textTertiary : AppColors.textPrimary,
                  decoration: ex.completed ? TextDecoration.lineThrough : null,
                )),
                Text(
                  '${ex.muscleGroup} • ${ex.sets}x${ex.reps}${ex.weight != null ? ' @ ${ex.weight!.toStringAsFixed(0)}kg' : ''}',
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 18, color: AppColors.textTertiary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${ex.name} removed'),
                backgroundColor: AppColors.surface,
                action: SnackBarAction(label: 'Undo', textColor: AppColors.accent, onPressed: () {}),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _templateTile(String name, String subtitle) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Template "$name" applied'),
          backgroundColor: AppColors.surface,
        ));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.content_copy, size: 18, color: AppColors.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showAddExerciseSheet() {
    String muscleGroup = 'Chest';
    final nameCtrl = TextEditingController();
    final setsCtrl = TextEditingController(text: '3');
    final repsCtrl = TextEditingController(text: '12');
    final weightCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text('Add Exercise', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: muscleGroup,
                dropdownColor: AppColors.surfaceElevated,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: 'Muscle Group', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                items: ['Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Legs', 'Core']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setSheetState(() => muscleGroup = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: 'Exercise Name', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: setsCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(color: AppColors.textPrimary),
                      decoration: InputDecoration(labelText: 'Sets', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: repsCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(color: AppColors.textPrimary),
                      decoration: InputDecoration(labelText: 'Reps', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: weightCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(color: AppColors.textPrimary),
                      decoration: InputDecoration(labelText: 'Weight (kg)', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isEmpty) return;
                    final newEx = Exercise(
                      name: nameCtrl.text,
                      muscleGroup: muscleGroup,
                      sets: int.tryParse(setsCtrl.text) ?? 3,
                      reps: int.tryParse(repsCtrl.text) ?? 12,
                      weight: double.tryParse(weightCtrl.text),
                    );
                    setState(() {
                      final key = _selectedDate;
                      if (_workouts[key] == null) {
                        _workouts[key] = [WorkoutDay(date: key, title: 'Custom Workout', exercises: [newEx])];
                      } else {
                        _workouts[key]!.first.exercises.add(newEx);
                      }
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
