import 'package:flutter/material.dart';
import 'theme.dart';
import 'app_gate.dart';

class TulparApp extends StatelessWidget {
  const TulparApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tulpar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AppGate(),
    );
  }
}
