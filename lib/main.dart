import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/owner/owner_shell.dart';
import 'screens/member/member_shell.dart';
import 'screens/solo/solo_shell.dart';
import 'data/models.dart';

void main() {
  runApp(const ProviderScope(child: DvayaApp()));
}

class DvayaApp extends ConsumerWidget {
  const DvayaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return MaterialApp(
      title: 'Dvaya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _buildHome(auth),
    );
  }

  Widget _buildHome(AuthState auth) {
    if (auth.role == null) return const LoginScreen();
    switch (auth.role!) {
      case UserRole.owner:
        return const OwnerShell();
      case UserRole.member:
        return const MemberShell();
      case UserRole.solo:
        return const SoloShell();
    }
  }
}
