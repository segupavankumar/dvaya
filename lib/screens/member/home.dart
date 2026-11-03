import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/dummy_data.dart';
import '../../widgets/streak_card.dart';

class MemberHome extends ConsumerStatefulWidget {
  const MemberHome({super.key});

  @override
  ConsumerState<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends ConsumerState<MemberHome> {
  int _bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final gym = auth.selectedGym!;
    final member = auth.selectedMember!;
    final firstName = member.name.split(' ').first;
    final today = DateTime(now.year, now.month, now.day);
    final workouts = getWorkoutsForMember(member.id);
    final todayWorkout = workouts[today];
    final diets = getDietForMember(member.id);
    final todayDiet = diets[today];

    final weekDots = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return member.attendance.any((a) => a.date.year == d.year && a.date.month == d.month && a.date.day == d.day);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCover(gym.name),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text('Hey $firstName', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(gym.name, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 20),
                    if (gym.bannerUrls.isNotEmpty) _buildBannerCarousel(gym.bannerUrls),
                    const SizedBox(height: 20),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    if (todayWorkout != null && todayWorkout.isNotEmpty) ...[
                      _buildWorkoutPreview(todayWorkout.first),
                      const SizedBox(height: 16),
                    ],
                    if (todayDiet != null) ...[
                      _buildDietPreview(todayDiet),
                      const SizedBox(height: 16),
                    ],
                    StreakCard(streak: member.streak, weekDots: weekDots),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(String gymName) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent.withValues(alpha: 0.3), AppColors.background],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            bottom: 16,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(gymName[0], style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                Text(gymName, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel(List<String> banners) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 80,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (i, _) => setState(() => _bannerIndex = i),
          ),
          itemBuilder: (_, i, __) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withValues(alpha: 0.2), AppColors.surface],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Center(
              child: Text(
                banners[i],
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSmoothIndicator(
          activeIndex: _bannerIndex,
          count: banners.length,
          effect: WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.accent,
            dotColor: AppColors.textTertiary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      (Icons.qr_code, 'Check In', 1),
      (Icons.trending_up, 'Progress', -1),
      (Icons.fitness_center, 'Workout', 2),
      (Icons.restaurant, 'Diet', 3),
    ];
    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: a != actions.last ? 10 : 0),
            child: InkWell(
              onTap: () {
                if (a.$3 >= 0) {
                  final shell = context.findAncestorStateOfType<State>();
                  if (shell != null && shell is dynamic) {
                    // Navigate via bottom nav by finding the shell
                  }
                }
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Column(
                  children: [
                    Icon(a.$1, color: AppColors.accent, size: 24),
                    const SizedBox(height: 6),
                    Text(a.$2, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutPreview(dynamic workout) {
    return Container(
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
              Icon(Icons.fitness_center, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Text("Today's Workout", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(workout.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.accent)),
          const SizedBox(height: 4),
          Text('${workout.exercises.length} exercises', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          if (workout.assignedBy != null)
            Text('Assigned by ${workout.assignedBy}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  Widget _buildDietPreview(dynamic diet) {
    return Container(
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
              Icon(Icons.restaurant, color: AppColors.success, size: 18),
              const SizedBox(width: 8),
              Text("Today's Diet", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          Text('${diet.targetCalories} cal target', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.success)),
          const SizedBox(height: 4),
          Text('P: ${diet.protein}g  C: ${diet.carbs}g  F: ${diet.fat}g', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          if (diet.assignedBy != null)
            Text('Assigned by ${diet.assignedBy}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
