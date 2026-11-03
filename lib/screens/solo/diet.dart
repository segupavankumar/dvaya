import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';

class SoloDiet extends StatefulWidget {
  const SoloDiet({super.key});

  @override
  State<SoloDiet> createState() => _SoloDietState();
}

class _SoloDietState extends State<SoloDiet> {
  late DateTime _selectedDate;
  late Map<DateTime, DietDay> _diets;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _diets = getSoloDiet();
  }

  List<DateTime> get _dateRange {
    return List.generate(14, (i) => _selectedDate.subtract(Duration(days: 7 - i)));
  }

  @override
  Widget build(BuildContext context) {
    final diet = _diets[_selectedDate];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Diet', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _dateRange.length,
                itemBuilder: (context, i) {
                  final date = _dateRange[i];
                  final isSelected = date == _selectedDate;
                  final hasDiet = _diets.containsKey(date);
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
                          if (hasDiet)
                            Container(
                              width: 5, height: 5,
                              margin: const EdgeInsets.only(top: 3),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.white : AppColors.success),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            if (diet == null)
              _emptyState()
            else ...[
              // Macro summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Daily Macros', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text('${diet.targetCalories} cal', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.accent, fontFeatures: const [FontFeature.tabularFigures()])),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _macroBar('Protein', diet.protein, 200, AppColors.accent),
                      const SizedBox(height: 10),
                      _macroBar('Carbs', diet.carbs, 300, AppColors.warning),
                      const SizedBox(height: 10),
                      _macroBar('Fat', diet.fat, 100, AppColors.success),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Meals
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Meals', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    TextButton.icon(
                      onPressed: _showAddMealSheet,
                      icon: const Icon(Icons.add, size: 18, color: AppColors.accent),
                      label: Text('Add Meal', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.accent)),
                    ),
                  ],
                ),
              ),
              ...diet.meals.map((meal) => _mealCard(meal)),
              const SizedBox(height: 16),
            ],

            // Templates
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diet Templates', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  _templateTile('Cut Diet', '1,800 cal • High Protein'),
                  const SizedBox(height: 8),
                  _templateTile('Maintenance', '2,200 cal • Balanced'),
                  const SizedBox(height: 8),
                  _templateTile('Bulk Diet', '2,800 cal • High Carb'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.restaurant_menu, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text('No meals logged', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showAddMealSheet,
              icon: const Icon(Icons.add),
              label: const Text("Log Today's Meals"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroBar(String label, int value, int max, Color color) {
    return Row(
      children: [
        SizedBox(width: 56, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (value / max).clamp(0, 1),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          child: Text('${value}g', textAlign: TextAlign.right, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary, fontFeatures: const [FontFeature.tabularFigures()])),
        ),
      ],
    );
  }

  Widget _mealCard(Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(meal.label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Row(
                  children: [
                    Text('${meal.totalCalories} cal', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent)),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {},
                      child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...meal.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 5, color: AppColors.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${item.name} (${item.quantity})', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
                  Text('${item.calories} cal', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary, fontFeatures: const [FontFeature.tabularFigures()])),
                ],
              ),
            )),
          ],
        ),
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
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.content_copy, size: 18, color: AppColors.success),
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
            const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showAddMealSheet() {
    String mealLabel = 'Breakfast';
    final foodNameCtrl = TextEditingController();
    final quantityCtrl = TextEditingController();
    final caloriesCtrl = TextEditingController();

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
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('Add Food Item', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: mealLabel,
                dropdownColor: AppColors.surfaceElevated,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: 'Meal', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                items: ['Early Morning', 'Breakfast', 'Mid-Morning', 'Lunch', 'Evening Snack', 'Dinner', 'Before Bed']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setSheetState(() => mealLabel = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: foodNameCtrl,
                style: GoogleFonts.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(labelText: 'Food Name', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantityCtrl,
                      style: GoogleFonts.poppins(color: AppColors.textPrimary),
                      decoration: InputDecoration(labelText: 'Quantity', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: caloriesCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(color: AppColors.textPrimary),
                      decoration: InputDecoration(labelText: 'Calories', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (foodNameCtrl.text.isEmpty) return;
                    final item = MealItem(
                      name: foodNameCtrl.text,
                      quantity: quantityCtrl.text.isNotEmpty ? quantityCtrl.text : '1 serving',
                      calories: int.tryParse(caloriesCtrl.text) ?? 100,
                    );
                    setState(() {
                      final key = _selectedDate;
                      final mealTime = MealTime.values[['Early Morning', 'Breakfast', 'Mid-Morning', 'Lunch', 'Evening Snack', 'Dinner', 'Before Bed'].indexOf(mealLabel)];
                      if (_diets[key] == null) {
                        _diets[key] = DietDay(
                          date: key,
                          targetCalories: 2200,
                          protein: 150,
                          carbs: 220,
                          fat: 65,
                          meals: [Meal(time: mealTime, label: mealLabel, items: [item])],
                        );
                      } else {
                        final existingMealIdx = _diets[key]!.meals.indexWhere((m) => m.label == mealLabel);
                        final mealsList = List<Meal>.from(_diets[key]!.meals);
                        if (existingMealIdx >= 0) {
                          final existingMeal = mealsList[existingMealIdx];
                          mealsList[existingMealIdx] = Meal(time: existingMeal.time, label: existingMeal.label, items: [...existingMeal.items, item]);
                        } else {
                          mealsList.add(Meal(time: mealTime, label: mealLabel, items: [item]));
                        }
                        _diets[key] = DietDay(
                          date: key,
                          targetCalories: _diets[key]!.targetCalories,
                          protein: _diets[key]!.protein,
                          carbs: _diets[key]!.carbs,
                          fat: _diets[key]!.fat,
                          meals: mealsList,
                        );
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
