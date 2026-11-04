import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/responsive.dart';

class OwnerDashboard extends ConsumerWidget {
  const OwnerDashboard({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final gym = auth.selectedGym!;
    final config = ref.watch(dashboardConfigProvider);
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveCenter(
            maxWidth: 600,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gym banner/cover
              _buildGymBanner(gym.name),
              const SizedBox(height: 16),

              // Top bar
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_greeting()}, ${gym.ownerName.split(' ').first}', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text(today, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                    onPressed: () => _showNotificationsSheet(context),
                    tooltip: 'Notifications',
                  ),
                  IconButton(
                    icon: Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                    onPressed: () => ref.read(ownerTabProvider.notifier).state = 2,
                    tooltip: 'Settings',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Alert card
              if (config['Due Today Alert'] == true)
                _buildAlertCard(context, ref),

              if (config['Due Today Alert'] == true)
                const SizedBox(height: 20),

              // Stats grid
              _buildStatsGrid(config, gym),
              const SizedBox(height: 20),

              // Attendance heatmap
              if (config['Attendance Heatmap'] == true) ...[
                Text('Attendance Heatmap', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Tap any date to see check-ins', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                const SizedBox(height: 12),
                _buildHeatmap(context),
                const SizedBox(height: 20),
              ],

              // Recent activity
              if (config['Recent Activity'] == true) ...[
                Text('Recent Activity', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _buildActivityFeed(),
              ],

              // Empty state
              if (!config.values.any((v) => v))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.dashboard_customize_outlined, size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: 12),
                      Text('No cards visible', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('Enable cards in Settings > Dashboard Customization', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary), textAlign: TextAlign.center),
                    ],
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildGymBanner(String gymName) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.4),
            AppColors.accent.withValues(alpha: 0.15),
            AppColors.surface,
          ],
        ),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 16,
            child: Icon(Icons.fitness_center, size: 64, color: AppColors.accent.withValues(alpha: 0.15)),
          ),
          Positioned(
            right: 50,
            bottom: 20,
            child: Icon(Icons.sports_gymnastics, size: 48, color: AppColors.accent.withValues(alpha: 0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Text(gymName[0], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white))),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(gymName, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text('Powered by Dvaya', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(ownerTabProvider.notifier).state = 1;
        ref.read(selectedMemberFilterProvider.notifier).state = 'Expiring';
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notification_important_outlined, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('3 members\' payments due today', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accent)),
                  Text('Tap to view and send reminders', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.accent),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, bool> config, gym) {
    final cards = <Widget>[];

    if (config["Today's Check-ins"] == true) {
      cards.add(StatsCard(
        title: "Today's Check-ins",
        value: '18/45',
        icon: Icons.login_outlined,
        color: AppColors.accent,
        trailing: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            value: 18 / 45,
            strokeWidth: 3,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
          ),
        ),
      ));
    }
    if (config['Active Members'] == true) {
      cards.add(const StatsCard(
        title: 'Active Members',
        value: '42',
        subtitle: '↑ 8% from last month',
        icon: Icons.people_outline,
        color: AppColors.success,
      ));
    }
    if (config['Expiring Subscriptions'] == true) {
      cards.add(const StatsCard(
        title: 'Expiring This Week',
        value: '5',
        icon: Icons.warning_amber_outlined,
        color: AppColors.warning,
      ));
    }
    if (config['Monthly Revenue'] == true) {
      cards.add(StatsCard(
        title: 'Monthly Revenue',
        value: '₹${NumberFormat('#,##,###').format(gym.monthlyRevenue.toInt())}',
        subtitle: '↑ 12% from last month',
        icon: Icons.currency_rupee_outlined,
        color: AppColors.success,
      ));
    }

    if (cards.isEmpty) return const SizedBox.shrink();

    return Builder(builder: (context) => GridView.count(
      crossAxisCount: responsiveGridCount(context),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: cards,
    ));
  }

  Widget _buildHeatmap(BuildContext context) {
    final now = DateTime.now();
    const daysInView = 35;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((d) => SizedBox(
                      width: 40,
                      child: Center(child: Text(d, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary))),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          ...List.generate(5, (week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (day) {
                  final idx = week * 7 + day;
                  if (idx >= daysInView) {
                    return const SizedBox(width: 40, height: 40);
                  }
                  final date = now.subtract(Duration(days: daysInView - 1 - idx));
                  final count = (date.weekday <= 5) ? (date.day % 7 + 8) : (date.day % 4 + 2);
                  final intensity = (count / 20).clamp(0.1, 1.0);
                  final isToday = date.day == now.day && date.month == now.month;

                  return GestureDetector(
                    onTap: () => _showDayAttendance(context, date, count),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: intensity * 0.7),
                        borderRadius: BorderRadius.circular(6),
                        border: isToday ? Border.all(color: AppColors.accent, width: 2) : null,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textPrimary, fontWeight: isToday ? FontWeight.w700 : FontWeight.w400),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Less', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
              const SizedBox(width: 4),
              ...List.generate(5, (i) => Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: (i + 1) * 0.14),
                  borderRadius: BorderRadius.circular(3),
                ),
              )),
              const SizedBox(width: 4),
              Text('More', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  void _showDayAttendance(BuildContext context, DateTime date, int count) {
    final dayNames = ['Rajesh Kumar', 'Priya Sharma', 'Arjun Rao', 'Meena Devi', 'Sanjay Patel', 'Deepa Nair', 'Ravi Verma', 'Anita Singh', 'Mohan Das', 'Kavita Reddy'];
    final checkedIn = dayNames.take(count.clamp(0, dayNames.length)).toList();
    final dateStr = DateFormat('EEEE, MMM d').format(date);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text(dateStr, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text('$count check-ins', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.accent, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            ...checkedIn.map((name) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                    child: Text(name[0], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent)),
                  ),
                  const SizedBox(width: 12),
                  Text(name, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                  const Spacer(),
                  Text('${7 + checkedIn.indexOf(name)}:${(15 + checkedIn.indexOf(name) * 7) % 60}0 AM', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            )),
            if (count > dayNames.length)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('+ ${count - dayNames.length} more members', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textTertiary)),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Notifications', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _notifItem(Icons.payment, 'Priya Sharma\'s plan expiring in 3 days', '2h ago', AppColors.warning),
            _notifItem(Icons.login, 'Rajesh Kumar checked in', '3h ago', AppColors.success),
            _notifItem(Icons.payment, 'Payment received from Arjun Rao - ₹11,000', '5h ago', AppColors.success),
            _notifItem(Icons.warning_amber, 'Meena Devi\'s plan expired 5 days ago', '1d ago', AppColors.danger),
            _notifItem(Icons.person_add, 'New member inquiry - Rohit Mehra', '2d ago', AppColors.accent),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _notifItem(IconData icon, String text, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary))),
          Text(time, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentActivities.length,
        separatorBuilder: (_, __) => Divider(color: AppColors.border, height: 1),
        itemBuilder: (context, index) {
          final activity = recentActivities[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(activity.icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(activity.text, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
                ),
                Text(activity.time, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textTertiary)),
              ],
            ),
          );
        },
      ),
    );
  }
}
