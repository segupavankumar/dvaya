import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../data/models.dart';
import '../../data/dummy_data.dart';
import '../../widgets/responsive.dart';

class CoachMemberDetail extends ConsumerStatefulWidget {
  final Member member;
  const CoachMemberDetail({super.key, required this.member});

  @override
  ConsumerState<CoachMemberDetail> createState() => _CoachMemberDetailState();
}

class _CoachMemberDetailState extends ConsumerState<CoachMemberDetail> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  bool _workoutEditMode = false;
  bool _dietEditMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.background,
              pinned: true,
              expandedHeight: 160,
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                    child: _buildHeader(member),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Workouts'),
                  Tab(text: 'Diet Plan'),
                  Tab(text: 'Progress'),
                  Tab(text: 'Attendance'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverview(member),
            _buildWorkouts(member),
            _buildDietPlan(member),
            _buildProgress(member),
            _buildAttendance(member),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Member member) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.accent.withValues(alpha: 0.15),
          child: Text(member.name[0], style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.accent)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(member.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Row(
                children: [
                  _statusPill(member.status),
                  const SizedBox(width: 8),
                  if (member.goal != null)
                    Flexible(child: Text(member.goal!, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 4),
              Text('Joined ${DateFormat('MMM d, yyyy').format(member.joinDate)}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusPill(MemberStatus status) {
    final (label, color) = switch (status) {
      MemberStatus.active => ('Active', AppColors.success),
      MemberStatus.expiring => ('Expiring', AppColors.warning),
      MemberStatus.expired => ('Expired', AppColors.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  // ===== OVERVIEW TAB =====
  Widget _buildOverview(Member member) {
    return SingleChildScrollView(
      child: DesktopAwareCenter(
        desktopMaxWidth: 1000,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _miniStat('Weight', '${member.currentWeight}kg', Icons.monitor_weight_outlined),
              const SizedBox(width: 12),
              _miniStat('BMI', '${member.bmi}', Icons.speed_outlined),
              const SizedBox(width: 12),
              _miniStat('Fat %', '${member.fatPercent}%', Icons.water_drop_outlined),
              const SizedBox(width: 12),
              _miniStat('Muscle', '${member.musclePercent}%', Icons.fitness_center),
            ],
          ),
          const SizedBox(height: 20),
          if (member.goal != null) ...[
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
                  Text('Goal', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(member.goal!, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: member.goalProgress,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${(member.goalProgress * 100).toInt()}% complete', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
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
                Text('Weight Journey', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _journeyStat('Start', '${member.startWeight}kg'),
                    Icon(Icons.arrow_forward, color: AppColors.textTertiary),
                    _journeyStat('Current', '${member.currentWeight}kg'),
                    Icon(Icons.arrow_forward, color: AppColors.textTertiary),
                    _journeyStat('Change', '${(member.currentWeight - member.startWeight).toStringAsFixed(1)}kg'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Icon(Icons.local_fire_department, color: member.streak > 0 ? AppColors.accent : AppColors.textTertiary, size: 28),
                  const SizedBox(height: 4),
                  Text('${member.streak}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('Day Streak', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ]),
                Column(children: [
                  Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 28),
                  const SizedBox(height: 4),
                  Text('${member.attendance.length}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('Total Visits', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ]),
                Column(children: [
                  Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 28),
                  const SizedBox(height: 4),
                  Text('${DateTime.now().difference(member.joinDate).inDays}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('Days Active', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ]),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _miniStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(height: 6),
            Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  Widget _journeyStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
      ],
    );
  }

  // ===== WORKOUTS TAB (EDITABLE) =====
  Widget _buildWorkouts(Member member) {
    final workouts = getWorkoutsForMember(member.id);
    final selectedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    final dayWorkout = workouts[selectedDate];

    return SingleChildScrollView(
      child: DesktopAwareCenter(
        desktopMaxWidth: 1000,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarBar(),
          const SizedBox(height: 8),
          Text(DateFormat('EEEE, MMM d').format(_selectedDay), style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          if (dayWorkout != null && dayWorkout.isNotEmpty) ...[
            Text(dayWorkout.first.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ...dayWorkout.first.exercises.map((ex) => _exerciseCard(ex)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _workoutEditMode = !_workoutEditMode);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_workoutEditMode ? 'Edit mode disabled' : 'Workout edit mode enabled'),
                      backgroundColor: AppColors.accent,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  icon: Icon(_workoutEditMode ? Icons.check : Icons.edit, size: 16),
                  label: Text(_workoutEditMode ? 'Done' : 'Edit'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => _showAddExercise(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Exercise'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: BorderSide(color: AppColors.border)),
                )),
              ],
            ),
          ] else ...[
            _emptyCard('No workout assigned for ${DateFormat('MMM d').format(_selectedDay)}', Icons.fitness_center_outlined),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddExercise(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Workout'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }

  void _showAddExercise() {
    final nameCtrl = TextEditingController();
    final setsCtrl = TextEditingController(text: '3');
    final repsCtrl = TextEditingController(text: '12');
    final weightCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Add Exercise', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(hintText: 'Exercise name'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: setsCtrl, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(hintText: 'Sets'), keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: repsCtrl, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(hintText: 'Reps'), keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: weightCtrl, style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: InputDecoration(hintText: 'Weight (kg)'), keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  final name = nameCtrl.text.isNotEmpty ? nameCtrl.text : 'New Exercise';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$name added to workout'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ));
                },
                child: const Text('Add Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseCard(Exercise ex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.fitness_center, color: AppColors.accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ex.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  Text(
                    '${ex.sets} sets × ${ex.reps} reps${ex.weight != null ? ' @ ${ex.weight}kg' : ''}',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Text(ex.muscleGroup, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
            if (_workoutEditMode) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${ex.name} removed'),
                    backgroundColor: AppColors.danger,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ));
                },
                child: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===== DIET PLAN TAB (EDITABLE) =====
  Widget _buildDietPlan(Member member) {
    final diets = getDietForMember(member.id);
    final selectedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    final dayDiet = diets[selectedDate];

    return SingleChildScrollView(
      child: DesktopAwareCenter(
        desktopMaxWidth: 1000,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarBar(),
          const SizedBox(height: 8),
          Text(DateFormat('EEEE, MMM d').format(_selectedDay), style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          if (dayDiet != null) ...[
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
                  Text('Daily Macros', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _macroStat('Calories', '${dayDiet.targetCalories}', 'kcal', AppColors.accent),
                      _macroStat('Protein', '${dayDiet.protein}', 'g', AppColors.success),
                      _macroStat('Carbs', '${dayDiet.carbs}', 'g', AppColors.warning),
                      _macroStat('Fat', '${dayDiet.fat}', 'g', AppColors.danger),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...dayDiet.meals.map((meal) => _mealCard(meal)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _dietEditMode = !_dietEditMode);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_dietEditMode ? 'Edit mode disabled' : 'Diet edit mode enabled'),
                      backgroundColor: AppColors.accent,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  icon: Icon(_dietEditMode ? Icons.check : Icons.edit, size: 16),
                  label: Text(_dietEditMode ? 'Done' : 'Edit'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => _showAddMeal(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Meal'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: BorderSide(color: AppColors.border)),
                )),
              ],
            ),
          ] else ...[
            _emptyCard('No diet plan for ${DateFormat('MMM d').format(_selectedDay)}', Icons.restaurant_outlined),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddMeal(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Diet Plan'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }

  void _showAddMeal() {
    final nameCtrl = TextEditingController();
    final timeCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Add Meal', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(hintText: 'Meal name (e.g. Breakfast)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeCtrl,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(hintText: 'Time (e.g. 8:00 AM)'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  final name = nameCtrl.text.isNotEmpty ? nameCtrl.text : 'New Meal';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$name added to diet plan'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ));
                },
                child: const Text('Add Meal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        Text(unit, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _mealCard(Meal meal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
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
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_mealTimeLabel(meal.time), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent)),
                ),
                const SizedBox(width: 10),
                Text(meal.label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const Spacer(),
                Text('${meal.totalCalories} kcal', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                if (_dietEditMode) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${meal.label} removed'),
                        backgroundColor: AppColors.danger,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                      ));
                    },
                    child: const Icon(Icons.delete_outline, color: AppColors.danger, size: 18),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            ...meal.items.map((item) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.textTertiary)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item.name, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary))),
                  Text('${item.quantity} • ${item.calories}kcal', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ===== PROGRESS TAB =====
  Widget _buildProgress(Member member) {
    final metrics = member.bodyMetrics;

    return SingleChildScrollView(
      child: DesktopAwareCenter(
        desktopMaxWidth: 1000,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _miniStat('Weight', '${member.currentWeight}kg', Icons.monitor_weight_outlined),
              const SizedBox(width: 12),
              _miniStat('BMI', '${member.bmi}', Icons.speed_outlined),
              const SizedBox(width: 12),
              _miniStat('Fat %', '${member.fatPercent}%', Icons.water_drop_outlined),
              const SizedBox(width: 12),
              _miniStat('Muscle', '${member.musclePercent}%', Icons.fitness_center),
            ],
          ),
          const SizedBox(height: 20),
          if (metrics.isNotEmpty) ...[
            _progressChart('Weight Trend', metrics.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.weight)).toList(), AppColors.accent),
            const SizedBox(height: 16),
            _progressChart('BMI Trend', metrics.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.bmi)).toList(), AppColors.warning),
            const SizedBox(height: 16),
            Text('Recent Readings', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            ...metrics.reversed.take(5).map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Text(DateFormat('MMM d').format(m.date), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    const Spacer(),
                    _readingChip('${m.weight}kg', AppColors.accent),
                    const SizedBox(width: 8),
                    _readingChip('BMI ${m.bmi.toStringAsFixed(1)}', AppColors.warning),
                    const SizedBox(width: 8),
                    _readingChip('${m.fatPercent}% fat', AppColors.danger),
                  ],
                ),
              ),
            )),
          ] else
            _emptyCard('No body metrics recorded yet', Icons.show_chart),
          const SizedBox(height: 16),
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
                Text('Weight Journey', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _journeyStat('Start', '${member.startWeight}kg'),
                    Icon(Icons.arrow_forward, color: AppColors.textTertiary),
                    _journeyStat('Current', '${member.currentWeight}kg'),
                    Icon(Icons.arrow_forward, color: AppColors.textTertiary),
                    _journeyStat('Change', '${(member.currentWeight - member.startWeight).toStringAsFixed(1)}kg'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _progressChart(String title, List<FlSpot> spots, Color color) {
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
          Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, _) => Text(v.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)))),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }

  // ===== ATTENDANCE TAB =====
  Widget _buildAttendance(Member member) {
    final attendanceDates = {for (var a in member.attendance) DateTime(a.date.year, a.date.month, a.date.day): a};

    return SingleChildScrollView(
      child: DesktopAwareCenter(
        desktopMaxWidth: 1000,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: _selectedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) => setState(() => _selectedDay = selected),
              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return attendanceDates.containsKey(key) ? ['present'] : [];
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.poppins(color: AppColors.textPrimary),
                weekendTextStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
                outsideTextStyle: GoogleFonts.poppins(color: AppColors.textTertiary),
                todayDecoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.3), shape: BoxShape.circle),
                selectedDecoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                markerDecoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                markerSize: 6,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
                rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary),
                weekendStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Builder(builder: (_) {
            final key = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
            final record = attendanceDates[key];
            if (record != null) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Present on ${DateFormat('MMM d, yyyy').format(_selectedDay)}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        Text('Checked in at ${record.checkInTime}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cancel_outlined, color: AppColors.textTertiary, size: 24),
                    const SizedBox(width: 12),
                    Text('Absent on ${DateFormat('MMM d, yyyy').format(_selectedDay)}', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              );
            }
          }),
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
                Text('This Month', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _journeyStat('Visits', '${member.attendance.where((a) => a.date.month == DateTime.now().month).length}'),
                    _journeyStat('Streak', '${member.streak}d'),
                    _journeyStat('Avg/Week', '${(member.attendance.length / 4).toStringAsFixed(1)}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  // ===== SHARED WIDGETS =====
  Widget _buildCalendarBar() {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.subtract(Duration(days: 3 - i)));

    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: days.length,
        itemBuilder: (context, i) {
          final day = days[i];
          final isSelected = day.year == _selectedDay.year && day.month == _selectedDay.month && day.day == _selectedDay.day;
          final isToday = day.year == today.year && day.month == today.month && day.day == today.day;

          return GestureDetector(
            onTap: () => setState(() => _selectedDay = day),
            child: Container(
              width: 48,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? AppColors.accent : (isToday ? AppColors.accent.withValues(alpha: 0.5) : AppColors.border), width: isToday && !isSelected ? 1.5 : 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E').format(day).substring(0, 2), style: GoogleFonts.poppins(fontSize: 11, color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text('${day.day}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textPrimary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _mealTimeLabel(MealTime time) {
    return switch (time) {
      MealTime.earlyMorning => '6:00 AM',
      MealTime.breakfast => '8:00 AM',
      MealTime.midMorning => '10:30 AM',
      MealTime.lunch => '1:00 PM',
      MealTime.eveningSnack => '4:30 PM',
      MealTime.dinner => '8:00 PM',
      MealTime.beforeBed => '10:00 PM',
    };
  }

  Widget _emptyCard(String text, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 40),
          const SizedBox(height: 12),
          Text(text, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textTertiary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
