import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'responsive.dart';

class AdaptiveDestination {
  final Widget icon;
  final Widget activeIcon;
  final String label;

  const AdaptiveDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class AdaptiveShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Widget> screens;
  final List<AdaptiveDestination> destinations;
  final Widget? floatingActionButton;

  const AdaptiveShell({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.screens,
    required this.destinations,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = Responsive.isWide(context);

    if (isWide) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              labelType: NavigationRailLabelType.all,
              backgroundColor: AppColors.surface,
              selectedIconTheme: IconThemeData(color: AppColors.accent),
              unselectedIconTheme: IconThemeData(color: AppColors.textTertiary),
              selectedLabelTextStyle: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
              unselectedLabelTextStyle: TextStyle(color: AppColors.textTertiary, fontSize: 12),
              indicatorColor: AppColors.accent.withValues(alpha: 0.15),
              destinations: destinations
                  .map((d) => NavigationRailDestination(
                        icon: d.icon,
                        selectedIcon: d.activeIcon,
                        label: Text(d.label),
                      ))
                  .toList(),
            ),
            VerticalDivider(width: 1, thickness: 0.5, color: AppColors.border),
            Expanded(
              child: IndexedStack(index: currentIndex, children: screens),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    }

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          items: destinations
              .map((d) => BottomNavigationBarItem(
                    icon: d.icon,
                    activeIcon: d.activeIcon,
                    label: d.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
