import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/select_pill.dart';
import 'daily_goal_screen.dart';

class ChooseLevelScreen extends StatefulWidget {
  const ChooseLevelScreen({super.key});

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
  String? selected;

  void _next() {
    if (selected == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DailyGoalScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = const ['Beginner', 'Intermediate', 'Advanced'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 10),
              ProgressHeader(
                progressIndex: 1,
                progressTotal: 2,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 26),
              Text(
                'What is your current\nKazakh level?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the level of your knowledge about\nthat language',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),

              Expanded(
                child: ListView.separated(
                  itemCount: levels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final lvl = levels[i];
                    return SelectPill(
                      text: lvl,
                      leading: null,
                      selected: selected == lvl,
                      onTap: () => setState(() => selected = lvl),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              PrimaryButton(text: 'NEXT', onPressed: selected == null ? null : _next),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
