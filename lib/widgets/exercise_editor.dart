import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';

class ExerciseEditor extends StatefulWidget {
  final Function(Exercise) onAdd;

  const ExerciseEditor({super.key, required this.onAdd});

  @override
  State<ExerciseEditor> createState() => _ExerciseEditorState();
}

class _ExerciseEditorState extends State<ExerciseEditor> {
  final _nameController = TextEditingController();
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '12');
  final _weightController = TextEditingController();
  String _muscleGroup = 'Chest';

  final _muscleGroups = ['Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Legs', 'Glutes', 'Core', 'Full Body'];

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text('Add Exercise', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _muscleGroup,
            dropdownColor: AppColors.surfaceElevated,
            style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(labelText: 'Muscle Group', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            items: _muscleGroups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (v) => setState(() => _muscleGroup = v ?? 'Chest'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            style: GoogleFonts.poppins(color: AppColors.textPrimary),
            decoration: InputDecoration(labelText: 'Exercise Name', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Sets', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _repsController, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Reps', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _weightController, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Weight (kg)', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty) return;
                widget.onAdd(Exercise(
                  name: _nameController.text,
                  muscleGroup: _muscleGroup,
                  sets: int.tryParse(_setsController.text) ?? 3,
                  reps: int.tryParse(_repsController.text) ?? 12,
                  weight: double.tryParse(_weightController.text),
                ));
                Navigator.pop(context);
              },
              child: const Text('Add Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}
