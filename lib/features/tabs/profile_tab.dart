import 'package:flutter/material.dart';
import '../../app/app_storage.dart';
import '../onboarding/splash_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AppStorage.logout();
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
              (_) => false,
        );
      },
      child: const Text('Выйти'),
    );
  }

}
