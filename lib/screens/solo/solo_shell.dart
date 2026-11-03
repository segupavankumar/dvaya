import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'home.dart';
import 'workouts.dart';
import 'diet.dart';
import 'progress.dart';
import 'profile.dart';

class SoloShell extends StatefulWidget {
  const SoloShell({super.key});

  @override
  State<SoloShell> createState() => _SoloShellState();
}

class _SoloShellState extends State<SoloShell> {
  int _currentIndex = 0;

  final _screens = const [
    SoloHome(),
    SoloWorkouts(),
    SoloDiet(),
    SoloProgress(),
    SoloProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center_outlined), activeIcon: Icon(Icons.fitness_center), label: 'Workouts'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_outlined), activeIcon: Icon(Icons.restaurant), label: 'Diet'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up_outlined), activeIcon: Icon(Icons.trending_up), label: 'Progress'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
