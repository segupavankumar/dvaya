import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/dummy_data.dart';

final gymsProvider = Provider<List<Gym>>((ref) => gyms);
final soloUserProvider = Provider<SoloUser>((ref) => soloUser);

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
