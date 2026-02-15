import 'package:flutter/material.dart';
import '../../widgets/dots_indicator.dart';
import '../../widgets/primary_button.dart';
import '../../app/theme.dart';
import '../setup/setup_start_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int index = 0;

  void _goNext() {
    if (index < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetupStartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (i) => setState(() => index = i),
                children: const [
                  _OnbPage(
                    title: 'Изучить новый язык\nлегко!',
                    subtitle:
                    'Короткие и интерактивные уроки,\nкоторые помогут быстро освоить\nматериал.',
                  ),
                  _OnbPage(
                    title: 'Практика и тренировка\nкаждый день',
                    subtitle:
                    'Интерактивные тесты и упражнения для\nзакрепления информации.',
                  ),
                  _OnbPage(
                    title: 'Отслеживай прогресс\nи цели',
                    subtitle:
                    'Ставь цель на день и двигайся\nмаленькими шагами.',
                  ),
                ],
              ),
            ),
            DotsIndicator(count: 3, index: index),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: const Text(
                      'Пропустить',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 160,
                    child: PrimaryButton(
                      text: 'Продолжить',
                      onPressed: _goNext,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _OnbPage extends StatelessWidget {
  final String title;
  final String subtitle;

  const _OnbPage({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 14),
          Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 22),
          Container(
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 44, color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
