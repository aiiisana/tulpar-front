import 'package:flutter/material.dart';
import 'theme.dart';

import '../features/onboarding/splash_screen.dart';

class TulparApp extends StatelessWidget {
  const TulparApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tulpar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const SplashScreen(),
    );
  }
}
