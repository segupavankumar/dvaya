import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';

final dashboardConfigProvider = StateNotifierProvider<DashboardConfigNotifier, Map<String, bool>>(
  (ref) => DashboardConfigNotifier(),
);

class DashboardConfigNotifier extends StateNotifier<Map<String, bool>> {
  DashboardConfigNotifier() : super(Map.from(defaultDashboardConfig));

  void toggle(String key) {
    state = {...state, key: !(state[key] ?? true)};
  }
}

final selectedMemberFilterProvider = StateProvider<String>((ref) => 'All');
final memberSearchProvider = StateProvider<String>((ref) => '');
