import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/adaptive_shell.dart';
import 'home.dart';
import 'workouts.dart';
import 'diet.dart';
import 'progress.dart';
import 'profile.dart';

class SoloShell extends ConsumerWidget {
  const SoloShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(soloTabProvider);

    return AdaptiveShell(
      currentIndex: currentIndex,
      onTap: (i) => ref.read(soloTabProvider.notifier).state = i,
      screens: const [
        SoloHome(),
        SoloWorkouts(),
        SoloDiet(),
        SoloProgress(),
        SoloProfile(),
      ],
      destinations: const [
        AdaptiveDestination(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
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
          icon: Icon(Icons.trending_up_outlined),
          activeIcon: Icon(Icons.trending_up),
          label: 'Progress',
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
