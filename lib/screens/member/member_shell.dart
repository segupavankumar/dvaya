import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/adaptive_shell.dart';
import 'home.dart';
import 'qr_checkin.dart';
import 'workouts.dart';
import 'diet_plan.dart';
import 'profile.dart';

class MemberShell extends ConsumerWidget {
  const MemberShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(memberTabProvider);

    return AdaptiveShell(
      currentIndex: currentIndex,
      onTap: (i) => ref.read(memberTabProvider.notifier).state = i,
      screens: [
        MemberHome(),
        QrCheckin(),
        MemberWorkouts(),
        MemberDietPlan(),
        MemberProfile(),
      ],
      destinations: const [
        AdaptiveDestination(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.qr_code),
          activeIcon: Icon(Icons.qr_code),
          label: 'Check In',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.fitness_center_outlined),
          activeIcon: Icon(Icons.fitness_center),
          label: 'Workouts',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.restaurant_outlined),
          activeIcon: Icon(Icons.restaurant),
          label: 'Diet',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
