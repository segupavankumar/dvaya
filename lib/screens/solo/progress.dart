import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/responsive.dart';

class SoloProgress extends StatefulWidget {
  const SoloProgress({super.key});

  @override
  State<SoloProgress> createState() => _SoloProgressState();
}

class _SoloProgressState extends State<SoloProgress> {
  double _weight = soloUser.currentWeight;
  double _bmi = soloUser.bmi;
  double _fat = soloUser.fatPercent;
  double _muscle = soloUser.musclePercent;
  String _goal = soloUser.goal;
  double _goalProgress = soloUser.goalProgress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Progress', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          maxWidth: 480,
          padding: const EdgeInsets.all(20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Body metrics
            Builder(builder: (context) => GridView.count(
              crossAxisCount: responsiveGridCount(context),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _metricCard('Weight', '${_weight.toStringAsFixed(1)} kg', Icons.monitor_weight_outlined, AppColors.accent),
                _metricCard('BMI', _bmi.toStringAsFixed(1), Icons.straighten, Colors.blueAccent),
                _metricCard('Body Fat', '${_fat.toStringAsFixed(1)}%', Icons.water_drop_outlined, AppColors.warning),
                _metricCard('Muscle', '${_muscle.toStringAsFixed(1)}%', Icons.fitness_center, AppColors.success),
              ],
            )),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _showUpdateMetricsSheet,
                icon: const Icon(Icons.edit, size: 16, color: AppColors.accent),
                label: Text('Update Metrics', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.accent)),
              ),
            ),
            const SizedBox(height: 12),

            // Weight chart
            Text('Weight Trend', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: soloUser.bodyMetrics.isEmpty
                  ? Center(child: Text('No data yet', style: GoogleFonts.poppins(color: AppColors.textTertiary)))
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) => FlLine(color: AppColors.border, strokeWidth: 0.5),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (v, _) => Text('${v.toInt()}', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
                            ),
                          ),
                          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: soloUser.bodyMetrics.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.weight)).toList(),
                            isCurved: true,
                            color: AppColors.accent,
                            barWidth: 2.5,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.accent.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                        minY: soloUser.bodyMetrics.map((m) => m.weight).reduce((a, b) => a < b ? a : b) - 1,
                        maxY: soloUser.bodyMetrics.map((m) => m.weight).reduce((a, b) => a > b ? a : b) + 1,
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Goal
            Text('My Goal', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
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
                      Expanded(child: Text(_goal, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary))),
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                        onPressed: _showEditGoalSheet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _goalProgress,
                            backgroundColor: AppColors.surfaceElevated,
                            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                            minHeight: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${(_goalProgress * 100).toInt()}%', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accent)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Before/After Photos
            Text('Before / After', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _photoPlaceholder('Before')),
                const SizedBox(width: 12),
                Expanded(child: _photoPlaceholder('After')),
              ],
            ),
            const SizedBox(height: 24),

            // Streak
            StreakCard(
              streak: soloUser.streak,
              weekDots: const [true, true, false, true, true, true, true],
            ),
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFeatures: const [FontFeature.tabularFigures()])),
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _photoPlaceholder(String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera will open here in production'), backgroundColor: AppColors.surface));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            Text('Tap to add', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  void _showUpdateMetricsSheet() {
    final weightCtrl = TextEditingController(text: _weight.toStringAsFixed(1));
    final bmiCtrl = TextEditingController(text: _bmi.toStringAsFixed(1));
    final fatCtrl = TextEditingController(text: _fat.toStringAsFixed(1));
    final muscleCtrl = TextEditingController(text: _muscle.toStringAsFixed(1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Update Body Metrics', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: weightCtrl, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Weight (kg)', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: bmiCtrl, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'BMI', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: fatCtrl, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Body Fat %', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: muscleCtrl, keyboardType: TextInputType.number, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(labelText: 'Muscle %', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)))),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _weight = double.tryParse(weightCtrl.text) ?? _weight;
                    _bmi = double.tryParse(bmiCtrl.text) ?? _bmi;
                    _fat = double.tryParse(fatCtrl.text) ?? _fat;
                    _muscle = double.tryParse(muscleCtrl.text) ?? _muscle;
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGoalSheet() {
    final goalCtrl = TextEditingController(text: _goal);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Edit Goal', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: goalCtrl,
              maxLines: 3,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(labelText: 'Your fitness goal', labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _goal = goalCtrl.text);
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
