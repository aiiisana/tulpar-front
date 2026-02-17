import 'package:flutter/material.dart';
import 'app_storage.dart';
import '../features/onboarding/splash_screen.dart';
import '../features/setup/home_shell.dart';

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AppStorage.isLoggedIn(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SplashScreen();
        }
        final loggedIn = snap.data!;
        return loggedIn ? const HomeShell() : const SplashScreen();
      },
    );
  }
}
