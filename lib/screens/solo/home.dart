import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/responsive.dart';

class SoloHome extends ConsumerWidget {
  const SoloHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final workouts = getSoloWorkouts();
    final todayWorkout = workouts[todayKey]?.firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: DesktopAwareCenter(
            desktopMaxWidth: 1000,
            padding: const EdgeInsets.all(20),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Hey ${soloUser.name.split(' ').first}',
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(today),
                style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              Builder(builder: (context) => GridView.count(
                crossAxisCount: responsiveGridCount(context),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _quickAction(ref, Icons.fitness_center, 'Log Workout', AppColors.accent, 1),
                  _quickAction(ref, Icons.trending_up, 'My Progress', AppColors.success, 3),
                  _quickAction(ref, Icons.restaurant_menu, 'Diet Log', AppColors.warning, 2),
                  _quickAction(ref, Icons.monitor_weight_outlined, 'Check Weight', Colors.blueAccent, 3),
                ],
              )),
              const SizedBox(height: 24),

              Builder(builder: (context) {
                final desktop = Responsive.isDesktop(context);
                final workoutCard = todayWorkout != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today\'s Workout', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => ref.read(soloTabProvider.notifier).state = 1,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(todayWorkout.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
                                ),
                                const Spacer(),
                                Text('${todayWorkout.exercises.length} exercises', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                                const SizedBox(width: 4),
                                Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...todayWorkout.exercises.take(3).map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Icon(Icons.circle, size: 6, color: AppColors.textTertiary),
                                  const SizedBox(width: 8),
                                  Text(e.name, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
                                  const Spacer(),
                                  Text(
                                    '${e.sets}x${e.reps}${e.weight != null ? ' @ ${e.weight!.toStringAsFixed(0)}kg' : ''}',
                                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, fontFeatures: const [FontFeature.tabularFigures()]),
                                  ),
                                ],
                              ),
                            )),
                            if (todayWorkout.exercises.length > 3)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('+${todayWorkout.exercises.length - 3} more', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ) : null;

                final streakSection = StreakCard(
                  streak: soloUser.streak,
                  weekDots: const [true, true, false, true, true, true, true],
                );

                final motivationCard = Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.accent.withValues(alpha: 0.2), AppColors.accent.withValues(alpha: 0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: AppColors.accent, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Great consistency!', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            Text("You've worked out 18 of the last 30 days", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );

                if (desktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            if (workoutCard != null) ...[workoutCard, const SizedBox(height: 24)],
                            motivationCard,
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            streakSection,
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (workoutCard != null) ...[workoutCard, const SizedBox(height: 24)],
                    streakSection,
                    const SizedBox(height: 24),
                    motivationCard,
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _quickAction(WidgetRef ref, IconData icon, String label, Color color, int tabIndex) {
    return InkWell(
      onTap: () => ref.read(soloTabProvider.notifier).state = tabIndex,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
