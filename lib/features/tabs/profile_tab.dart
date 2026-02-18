import 'package:flutter/material.dart';
import '../../app/app_storage.dart';
import '../../app/theme.dart';
import '../settings/settings_screen.dart';
import '../onboarding/splash_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String firstName = '...';
  String lastName = '';
  int goalMin = 15;
  String uiLang = 'ru';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final f = await AppStorage.getFirstName();
    final l = await AppStorage.getLastName();
    final g = await AppStorage.getGoalMinutes();
    final lang = await AppStorage.getUiLang();

    if (!mounted) return;
    setState(() {
      firstName = (f == null || f.trim().isEmpty) ? 'Пользователь' : f.trim();
      lastName = (l ?? '').trim();
      goalMin = g ?? 15;
      uiLang = lang;
    });
  }

  Future<void> _editName() async {
    final controllerFirst = TextEditingController(text: firstName == 'Пользователь' ? '' : firstName);
    final controllerLast = TextEditingController(text: lastName);

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Редактировать имя'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Имя'), controller: controllerFirst),
            TextField(decoration: const InputDecoration(labelText: 'Фамилия'), controller: controllerLast),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Сохранить')),
        ],
      ),
    );

    if (saved != true) return;

    final f = controllerFirst.text.trim();
    final l = controllerLast.text.trim();

    await AppStorage.saveProfile(
      firstName: f.isEmpty ? 'Пользователь' : f,
      lastName: l,
    );

    await _load();
  }

  Future<void> _changeGoal() async {
    final options = [15, 30, 45, 60, 90, 120];

    final chosen = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text('Ежедневная цель'),
              subtitle: Text('Выберите время в день'),
            ),
            for (final m in options)
              ListTile(
                title: Text('$m минут'),
                trailing: m == goalMin ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(context, m),
              ),
          ],
        ),
      ),
    );

    if (chosen == null) return;

    await AppStorage.setGoalMinutes(chosen);
    await _load();
  }

  Future<void> _changeLang() async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Язык приложения'),
              subtitle: Text('Пока только RU/EN'),
            ),
            ListTile(
              title: const Text('Русский'),
              trailing: uiLang == 'ru' ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, 'ru'),
            ),
            ListTile(
              title: const Text('English'),
              trailing: uiLang == 'en' ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, 'en'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    if (chosen == null) return;

    await AppStorage.setUiLang(chosen);
    await _load();
  }

  Future<void> _logout() async {
    await AppStorage.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName = (lastName.isEmpty) ? firstName : '$firstName $lastName';
    final goalText = '$goalMin МИН';
    final langText = uiLang == 'ru' ? 'Русский' : 'English';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Профиль',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                    icon: const Icon(Icons.settings, color: AppTheme.textPrimary),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x22000000))
                        ],
                      ),
                      child: const Center(child: Icon(Icons.person, color: AppTheme.textSecondary)),
                    ),
                    const SizedBox(height: 8),
                    Text(fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    const Text('Начинающий', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _editName,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        side: const BorderSide(color: AppTheme.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Редактировать', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              _SectionTitle('Прогресс'),
              const SizedBox(height: 8),
              _InfoCard(
                items: const [
                  _InfoRow(icon: Icons.local_fire_department_outlined, text: '1 день подряд'),
                  _InfoRow(icon: Icons.check_circle_outline, text: '1 урок пройден'),
                  _InfoRow(icon: Icons.timer_outlined, text: '0 ч 5 мин занятий'),
                ],
              ),

              const SizedBox(height: 14),

              _SectionTitle('Достижения'),
              const SizedBox(height: 8),
              _InfoCard(
                items: const [
                  _InfoRow(icon: Icons.emoji_events_outlined, text: '1 день подряд'),
                  _InfoRow(icon: Icons.star_border, text: 'Пройди первый урок'),
                ],
              ),

              const SizedBox(height: 14),

              _SettingsRow(
                title: 'Ежедневная цель',
                value: goalText,
                onTap: _changeGoal,
              ),
              const SizedBox(height: 10),
              _SettingsRow(
                title: 'Язык приложения',
                value: langText,
                onTap: _changeLang,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Выйти'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.chipFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: items
            .map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(e.icon, size: 18, color: AppTheme.textPrimary),
              const SizedBox(width: 10),
              Expanded(child: Text(e.text, style: const TextStyle(fontSize: 12))),
            ],
          ),
        ))
            .toList()
          ..removeLast(),
      ),
    );
  }
}

class _InfoRow {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.chipFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),
            Text(value, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
