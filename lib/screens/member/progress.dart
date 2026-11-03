import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';

class MemberProgress extends ConsumerWidget {
  const MemberProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final member = auth.selectedMember!;
    final today = DateTime(now.year, now.month, now.day);
    final weekDots = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return member.attendance.any((a) => a.date.year == d.year && a.date.month == d.month && a.date.day == d.day);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('My Progress', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsGrid(member),
            const SizedBox(height: 20),
            _buildWeightChart(member),
            const SizedBox(height: 20),
            _buildGoalCard(context, member),
            const SizedBox(height: 20),
            _buildPhotoSlots(),
            const SizedBox(height: 20),
            _buildAttendanceSection(member, weekDots),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showUpdateMetrics(context, member),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Update Metrics'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(Member member) {
    final metrics = [
      ('Weight', '${member.currentWeight}kg', Icons.monitor_weight_outlined, AppColors.accent),
      ('BMI', '${member.bmi}', Icons.speed_outlined, AppColors.warning),
      ('Body Fat', '${member.fatPercent}%', Icons.water_drop_outlined, AppColors.danger),
      ('Muscle', '${member.musclePercent}%', Icons.fitness_center, AppColors.success),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: metrics.map((m) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(m.$3, color: m.$4, size: 20),
            const SizedBox(height: 8),
            Text(m.$2, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFeatures: const [FontFeature.tabularFigures()])),
            Text(m.$1, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildWeightChart(Member member) {
    if (member.bodyMetrics.isEmpty) return const SizedBox();
    final spots = member.bodyMetrics.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.weight)).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weight Trend', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 0.5),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)))),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: AppColors.accent.withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, Member member) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              Text('My Goal', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showEditGoal(context, member),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Edit', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(member.goal ?? 'No goal set', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: member.goalProgress,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text('${(member.goalProgress * 100).toInt()}% complete', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  Widget _buildPhotoSlots() {
    return Row(
      children: ['Before', 'After'].map((label) => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: label == 'Before' ? 6 : 0, left: label == 'After' ? 6 : 0),
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: AppColors.textTertiary, size: 32),
              const SizedBox(height: 8),
              Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildAttendanceSection(Member member, List<bool> weekDots) {
    final totalDays = member.attendance.length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              Text('Attendance', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const Spacer(),
              Text('$totalDays days total', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              return Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: weekDots[i] ? AppColors.accent : AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(weekDots[i] ? Icons.check : Icons.close, size: 14, color: weekDots[i] ? Colors.white : AppColors.textTertiary),
                  ),
                  const SizedBox(height: 4),
                  Text(days[i], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.local_fire_department, color: AppColors.accent, size: 18),
              const SizedBox(width: 6),
              Text('${member.streak} day streak', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditGoal(BuildContext context, Member member) {
    final controller = TextEditingController(text: member.goal);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Edit Goal', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'What is your fitness goal?'),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Save'))),
          ],
        ),
      ),
    );
  }

  void _showUpdateMetrics(BuildContext context, Member member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Update Metrics', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _metricField('Weight (kg)', '${member.currentWeight}'),
            const SizedBox(height: 12),
            _metricField('BMI', '${member.bmi}'),
            const SizedBox(height: 12),
            _metricField('Body Fat %', '${member.fatPercent}'),
            const SizedBox(height: 12),
            _metricField('Muscle %', '${member.musclePercent}'),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Save'))),
          ],
        ),
      ),
    );
  }

  Widget _metricField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      keyboardType: TextInputType.number,
      style: GoogleFonts.poppins(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label, labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
    );
  }
}
