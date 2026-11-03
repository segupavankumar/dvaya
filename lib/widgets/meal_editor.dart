import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';

class MealEditor extends StatefulWidget {
  final String mealLabel;
  final Function(MealItem) onAdd;

  const MealEditor({super.key, required this.mealLabel, required this.onAdd});

  @override
  State<MealEditor> createState() => _MealEditorState();
}

class _MealEditorState extends State<MealEditor> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _caloriesController.dispose();
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
          Text('Add to ${widget.mealLabel}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            style: GoogleFonts.poppins(color: AppColors.textPrimary),
            decoration: InputDecoration(labelText: 'Food Name', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: TextField(controller: _quantityController, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Quantity', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _caloriesController, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Calories', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty) return;
                widget.onAdd(MealItem(
                  name: _nameController.text,
                  quantity: _quantityController.text.isEmpty ? '1 serving' : _quantityController.text,
                  calories: int.tryParse(_caloriesController.text) ?? 100,
                ));
                Navigator.pop(context);
              },
              child: const Text('Add Food Item'),
            ),
          ),
        ],
      ),
    );
  }
}
