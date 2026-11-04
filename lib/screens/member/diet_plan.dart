import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/responsive.dart';

class MemberDietPlan extends ConsumerStatefulWidget {
  const MemberDietPlan({super.key});

  @override
  ConsumerState<MemberDietPlan> createState() => _MemberDietPlanState();
}

class _MemberDietPlanState extends ConsumerState<MemberDietPlan> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final member = auth.selectedMember!;
    final diets = getDietForMember(member.id);
    final diet = diets[_selectedDate];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Diet Plan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: ResponsiveCenter(
        maxWidth: 600,
        child: Column(
        children: [
          _buildDateBar(),
          Expanded(
            child: diet == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restaurant, size: 48, color: AppColors.textTertiary),
                        const SizedBox(height: 12),
                        Text('No diet plan assigned', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
                        Text('for ${DateFormat('MMM d').format(_selectedDate)}', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary)),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMacroSummary(diet),
                        const SizedBox(height: 20),
                        if (diet.assignedBy != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text('Assigned by ${diet.assignedBy}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent)),
                          ),
                        ...diet.meals.map((meal) => _buildMealCard(meal)),
                        const SizedBox(height: 24),
                      ],
                    ),
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

  Widget _buildMacroSummary(DietDay diet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text('${diet.targetCalories}', style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.accent, fontFeatures: const [FontFeature.tabularFigures()])),
          Text('calories', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _macroItem('Protein', '${diet.protein}g', AppColors.accent),
              _macroItem('Carbs', '${diet.carbs}g', AppColors.warning),
              _macroItem('Fat', '${diet.fat}g', AppColors.danger),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroItem(String label, String value, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 4,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
              Center(child: Text(value, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildMealCard(Meal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(meal.label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const Spacer(),
              Text('${meal.totalCalories} cal', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent, fontFeatures: const [FontFeature.tabularFigures()])),
            ],
          ),
          const SizedBox(height: 10),
          ...meal.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.textTertiary, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(child: Text(item.name, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary))),
                Text(item.quantity, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                const SizedBox(width: 12),
                Text('${item.calories}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary, fontFeatures: const [FontFeature.tabularFigures()])),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
