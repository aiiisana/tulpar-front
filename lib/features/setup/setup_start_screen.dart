import 'package:flutter/material.dart';
import 'package:tulpar_front/features/auth/login_screen.dart';
import 'package:tulpar_front/features/auth/signup_screen.dart';
import '../../widgets/primary_button.dart';
import '../../app/theme.dart';
import 'choose_level_screen.dart';

class SetupStartScreen extends StatelessWidget {
  const SetupStartScreen({super.key});

  void _go(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ChooseLevelScreen()),
    );
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 26),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Начнем путь изучения\nязыка.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 22),
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Center(
                        child: Icon(Icons.phone_iphone, size: 44, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(text: 'НАЧАТЬ', onPressed: () => _go(context)),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => _goToLogin(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: AppTheme.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('У МЕНЯ УЖЕ ЕСТЬ АККАУНТ'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
