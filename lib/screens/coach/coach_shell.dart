import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/adaptive_shell.dart';
import 'coach_home.dart';
import 'coach_members.dart';
import 'coach_checkin.dart';
import 'coach_profile.dart';

class CoachShell extends ConsumerWidget {
  const CoachShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(coachTabProvider);

    return AdaptiveShell(
      currentIndex: currentIndex,
      onTap: (i) => ref.read(coachTabProvider.notifier).state = i,
      screens: const [
        CoachHome(),
        CoachMembers(),
        CoachCheckin(),
        CoachProfile(),
      ],
      destinations: const [
        AdaptiveDestination(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Trainees',
        ),
        AdaptiveDestination(
          icon: Icon(Icons.access_time_outlined),
          activeIcon: Icon(Icons.access_time_filled),
          label: 'Check In',
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
