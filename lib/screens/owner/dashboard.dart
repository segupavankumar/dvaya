import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/stats_card.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  Expanded(
                    child: Text(gym.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('${_greeting()}, ${gym.ownerName.split(' ').first}', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(today, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 20),

              // Alert card
              if (config['Due Today Alert'] == true)
                _buildAlertCard(context),

              if (config['Due Today Alert'] == true)
                const SizedBox(height: 20),

              // Stats grid
              _buildStatsGrid(config, gym),
              const SizedBox(height: 20),

              // Attendance heatmap
              if (config['Attendance Heatmap'] == true) ...[
                Text('Attendance Heatmap', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _buildHeatmap(),
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
                      const Icon(Icons.dashboard_customize_outlined, size: 48, color: AppColors.textTertiary),
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
    );
  }

  Widget _buildAlertCard(BuildContext context) {
    return InkWell(
      onTap: () {},
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

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: cards,
    );
  }

  Widget _buildHeatmap() {
    final now = DateTime.now();
    final daysInView = 35;
    // Simple 5-row x 7-col grid for last 35 days
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((d) => SizedBox(
                      width: 36,
                      child: Center(child: Text(d, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textTertiary))),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Grid
          ...List.generate(5, (week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (day) {
                  final idx = week * 7 + day;
                  if (idx >= daysInView) {
                    return const SizedBox(width: 36, height: 36);
                  }
                  final date = now.subtract(Duration(days: daysInView - 1 - idx));
                  // Simulated check-in count based on day
                  final count = (date.weekday <= 5) ? (date.day % 7 + 8) : (date.day % 4 + 2);
                  final intensity = (count / 20).clamp(0.1, 1.0);
                  final isToday = date.day == now.day && date.month == now.month;

                  return Container(
                    width: 36,
                    height: 36,
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
                  );
                }),
              ),
            );
          }),
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
        separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 1),
        itemBuilder: (context, index) {
          final activity = recentActivities[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
