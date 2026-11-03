import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_theme.dart';
import '../../data/models.dart';
import '../../data/dummy_data.dart';
import '../../providers/auth_provider.dart';

class MemberDetail extends ConsumerStatefulWidget {
  final Member member;
  const MemberDetail({super.key, required this.member});

  @override
  ConsumerState<MemberDetail> createState() => _MemberDetailState();
}

class _MemberDetailState extends ConsumerState<MemberDetail> with TickerProviderStateMixin {
  late TabController _tabController;
  String? _assignedTrainer;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _assignedTrainer = widget.member.trainer;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final gym = ref.read(authProvider).selectedGym!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.background,
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                    child: _buildHeader(member, gym),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Attendance'),
                  Tab(text: 'Body Metrics'),
                  Tab(text: 'Workouts'),
                  Tab(text: 'Diet Plan'),
                  Tab(text: 'Goals'),
                  Tab(text: 'Payments'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverview(member),
            _buildAttendance(member),
            _buildBodyMetrics(member),
            _buildWorkouts(member),
            _buildDietPlan(member),
            _buildGoals(member),
            _buildPayments(member),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Member member, Gym gym) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.accent.withValues(alpha: 0.15),
          child: Text(member.name[0], style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.accent)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(member.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Row(
                children: [
                  _statusPill(member.status),
                  const SizedBox(width: 8),
                  Text(member.plan, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 4),
              Text('Joined ${DateFormat('MMM d, yyyy').format(member.joinDate)}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
              const SizedBox(height: 8),
              // Trainer assignment
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  if (_assignedTrainer != null)
                    Text(_assignedTrainer!, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent))
                  else
                    InkWell(
                      onTap: () => _showTrainerPicker(gym),
                      child: Text('Assign Trainer', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent, decoration: TextDecoration.underline)),
                    ),
                  if (_assignedTrainer != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _showTrainerPicker(gym),
                      child: const Icon(Icons.edit, size: 14, color: AppColors.textTertiary),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTrainerPicker(Gym gym) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Assign Trainer', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              ...gym.trainers.map((trainer) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                  child: Text(trainer[0], style: GoogleFonts.poppins(color: AppColors.accent, fontWeight: FontWeight.w600)),
                ),
                title: Text(trainer, style: GoogleFonts.poppins(color: AppColors.textPrimary)),
                trailing: _assignedTrainer == trainer ? const Icon(Icons.check_circle, color: AppColors.accent) : null,
                onTap: () {
                  setState(() => _assignedTrainer = trainer);
                  Navigator.pop(context);
                },
              )),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.surfaceElevated,
                  child: const Icon(Icons.close, color: AppColors.textTertiary),
                ),
                title: Text('No trainer', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                onTap: () {
                  setState(() => _assignedTrainer = null);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats row
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
          // Goal progress
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
          ],
          const SizedBox(height: 16),
          // Weight change card
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
                    const Icon(Icons.arrow_forward, color: AppColors.textTertiary),
                    _journeyStat('Current', '${member.currentWeight}kg'),
                    const Icon(Icons.arrow_forward, color: AppColors.textTertiary),
                    _journeyStat('Change', '${(member.currentWeight - member.startWeight).toStringAsFixed(1)}kg'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Streak + Attendance summary
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
                  const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 28),
                  const SizedBox(height: 4),
                  Text('${member.attendance.length}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('Total Visits', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ]),
                Column(children: [
                  const Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 28),
                  const SizedBox(height: 4),
                  Text('${DateTime.now().difference(member.joinDate).inDays}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('Days Active', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
                ]),
              ],
            ),
          ),
        ],
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

  // ===== ATTENDANCE TAB =====
  Widget _buildAttendance(Member member) {
    final attendanceDates = {for (var a in member.attendance) DateTime(a.date.year, a.date.month, a.date.day): a};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary),
                weekendStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary),
              ),
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
          const SizedBox(height: 16),
          Text('Recent Check-ins', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ...member.attendance.reversed.take(5).map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.login, color: AppColors.success, size: 18),
                  const SizedBox(width: 12),
                  Text(DateFormat('MMM d, yyyy').format(a.date), style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
                  const Spacer(),
                  Text(a.checkInTime, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  // ===== BODY METRICS TAB =====
  Widget _buildBodyMetrics(Member member) {
    final metrics = member.bodyMetrics;
    if (metrics.isEmpty) {
      return Center(child: Text('No body metrics recorded', style: GoogleFonts.poppins(color: AppColors.textTertiary)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weight Trend', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(color: AppColors.border, strokeWidth: 0.5),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (metrics.length / 4).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= metrics.length) return const SizedBox.shrink();
                        return Text(DateFormat('d/M').format(metrics[idx].date), style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textTertiary));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: metrics.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.weight)).toList(),
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
          const SizedBox(height: 20),
          // BMI trend
          Text('BMI Trend', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 0.5)),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, _) => Text('${v.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)))),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: metrics.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.bmi)).toList(),
                    isCurved: true,
                    color: AppColors.warning,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: AppColors.warning.withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Add reading button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddReading(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Reading'),
            ),
          ),
          const SizedBox(height: 16),
          // Before/After placeholder
          Text('Before / After Photos', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _photoSlot('Before')),
              const SizedBox(width: 12),
              Expanded(child: _photoSlot('After')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _photoSlot(String label) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, color: AppColors.textTertiary, size: 32),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary)),
          Text('Tap to add', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  void _showAddReading(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Add Body Metrics', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'Weight (kg)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'Fat %'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'BMI'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(style: GoogleFonts.poppins(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'Muscle %'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Save Reading'))),
            ],
          ),
        );
      },
    );
  }

  // ===== WORKOUTS TAB =====
  Widget _buildWorkouts(Member member) {
    final workouts = getWorkoutsForMember(member.id);
    final today = DateTime(now.year, now.month, now.day);
    final todayWorkout = workouts[today];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar bar (horizontal date picker)
          _buildCalendarBar(),
          const SizedBox(height: 16),
          if (todayWorkout != null && todayWorkout.isNotEmpty) ...[
            Text(todayWorkout.first.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            if (todayWorkout.first.assignedBy != null)
              Text('Assigned by ${todayWorkout.first.assignedBy}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
            const SizedBox(height: 16),
            ...todayWorkout.first.exercises.map((ex) => _exerciseCard(ex)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy Previous'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.border)),
                )),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_outlined, size: 16),
                label: const Text('Save as Template'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.border)),
              ),
            ),
          ] else
            _emptyCard('No workout assigned for today', Icons.fitness_center_outlined),
        ],
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
          ],
        ),
      ),
    );
  }

  // ===== DIET PLAN TAB =====
  Widget _buildDietPlan(Member member) {
    final diets = getDietForMember(member.id);
    final today = DateTime(now.year, now.month, now.day);
    final todayDiet = diets[today];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarBar(),
          const SizedBox(height: 16),
          if (todayDiet != null) ...[
            // Macro summary
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
                      _macroStat('Calories', '${todayDiet.targetCalories}', 'kcal', AppColors.accent),
                      _macroStat('Protein', '${todayDiet.protein}', 'g', AppColors.success),
                      _macroStat('Carbs', '${todayDiet.carbs}', 'g', AppColors.warning),
                      _macroStat('Fat', '${todayDiet.fat}', 'g', AppColors.danger),
                    ],
                  ),
                ],
              ),
            ),
            if (todayDiet.assignedBy != null) ...[
              const SizedBox(height: 8),
              Text('Assigned by ${todayDiet.assignedBy}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
            ],
            const SizedBox(height: 16),
            // Meal cards
            ...todayDiet.meals.map((meal) => _mealCard(meal)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.people_outline, size: 16),
                  label: const Text('Apply to Others'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.border)),
                )),
              ],
            ),
          ] else
            _emptyCard('No diet plan assigned for today', Icons.restaurant_outlined),
        ],
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
                Text(meal.label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const Spacer(),
                Text('${meal.totalCalories} kcal', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.accent)),
              ],
            ),
            const SizedBox(height: 8),
            ...meal.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: AppColors.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.name, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary))),
                  Text(item.quantity, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                  const SizedBox(width: 8),
                  Text('${item.calories}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ===== GOALS TAB =====
  Widget _buildGoals(Member member) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                    const Icon(Icons.flag_outlined, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Text('Member Goal', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(member.goal ?? 'No goal set', style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: member.goalProgress,
                    minHeight: 10,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                  ),
                ),
                const SizedBox(height: 8),
                Text('${(member.goalProgress * 100).toInt()}% progress', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Owner notes
          Container(
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
                Text('Owner Notes', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 4,
                  style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Add notes about this member\'s progress...',
                    hintStyle: GoogleFonts.poppins(color: AppColors.textTertiary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: () {}, child: const Text('Save Notes')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Edit Goal'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
            ),
          ),
        ],
      ),
    );
  }

  // ===== PAYMENTS TAB =====
  Widget _buildPayments(Member member) {
    final daysLeft = member.planExpiry.difference(DateTime.now()).inDays;
    final isOverdue = daysLeft < 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current plan card
          Container(
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
                    Text('Current Plan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const Spacer(),
                    _statusPill(member.status),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.plan, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text('₹${NumberFormat('#,##,###').format(member.planAmount.toInt())}', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.accent, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(isOverdue ? 'Overdue' : 'Expires', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                        Text(DateFormat('MMM d, yyyy').format(member.planExpiry), style: GoogleFonts.poppins(fontSize: 13, color: isOverdue ? AppColors.danger : AppColors.textPrimary)),
                        Text(isOverdue ? '${-daysLeft} days ago' : '$daysLeft days left', style: GoogleFonts.poppins(fontSize: 12, color: isOverdue ? AppColors.danger : AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Payment History', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ...member.payments.map((p) => Padding(
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
                      color: (p.status == 'Paid' ? AppColors.success : AppColors.danger).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      p.status == 'Paid' ? Icons.check_circle_outline : Icons.warning_amber,
                      color: p.status == 'Paid' ? AppColors.success : AppColors.danger,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${NumberFormat('#,##,###').format(p.amount.toInt())} — ${p.plan}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        Text('${DateFormat('MMM d, yyyy').format(p.date)}${p.method.isNotEmpty ? '  •  ${p.method}' : ''}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (p.status == 'Paid' ? AppColors.success : AppColors.danger).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(p.status, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: p.status == 'Paid' ? AppColors.success : AppColors.danger)),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  // ===== SHARED HELPERS =====
  Widget _buildCalendarBar() {
    final today = DateTime.now();
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = today.subtract(Duration(days: 7 - index));
          final isToday = index == 7;
          final isSelected = isSameDay(date, _selectedDay);
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = date),
            child: Container(
              width: 48,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isToday && !isSelected ? AppColors.accent : AppColors.border, width: isToday && !isSelected ? 1.5 : 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E').format(date).substring(0, 2), style: GoogleFonts.poppins(fontSize: 11, color: isSelected ? Colors.white : AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text('${date.day}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textPrimary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyCard(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(message, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textTertiary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
