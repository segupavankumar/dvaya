import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/dummy_data.dart';

class AuthState {
  final UserRole? role;
  final Gym? selectedGym;
  final Member? selectedMember;
  final Coach? selectedCoach;
  final bool isSoloUser;

  const AuthState({this.role, this.selectedGym, this.selectedMember, this.selectedCoach, this.isSoloUser = false});

  AuthState copyWith({UserRole? role, Gym? selectedGym, Member? selectedMember, Coach? selectedCoach, bool? isSoloUser}) {
    return AuthState(
      role: role ?? this.role,
      selectedGym: selectedGym ?? this.selectedGym,
      selectedMember: selectedMember ?? this.selectedMember,
      selectedCoach: selectedCoach ?? this.selectedCoach,
      isSoloUser: isSoloUser ?? this.isSoloUser,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void loginAsOwner(Gym gym) {
    state = AuthState(role: UserRole.owner, selectedGym: gym);
  }

  void loginAsMember(Gym gym, Member member) {
    state = AuthState(role: UserRole.member, selectedGym: gym, selectedMember: member);
  }

  void loginAsCoach(Gym gym, Coach coach) {
    state = AuthState(role: UserRole.coach, selectedGym: gym, selectedCoach: coach);
  }

  void loginAsSolo() {
    state = const AuthState(role: UserRole.solo, isSoloUser: true);
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

final currentGymMembersProvider = Provider<List<Member>>((ref) {
  final auth = ref.watch(authProvider);
  if (auth.selectedGym == null) return [];
  return members.where((m) => m.gymId == auth.selectedGym!.id).toList();
});

final allGymMembersProvider = Provider.family<List<Member>, String>((ref, gymId) {
  return members.where((m) => m.gymId == gymId).toList();
});

final coachAssignedMembersProvider = Provider<List<Member>>((ref) {
  final auth = ref.watch(authProvider);
  if (auth.selectedCoach == null) return [];
  return members.where((m) => auth.selectedCoach!.assignedMemberIds.contains(m.id)).toList();
});
