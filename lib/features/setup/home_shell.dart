import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../tabs/home_tab.dart';
import '../tabs/learning_tab.dart';
import '../tabs/tasks_tab.dart';
import '../tabs/profile_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final pages = const [
    HomeTab(),
    LearningTab(),
    TasksTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.75),
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Дом'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Обучение'),
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department_outlined), label: 'Задание'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
      ),
    );
  }
}
