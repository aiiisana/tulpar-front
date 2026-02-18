import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'security_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Настройки',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.chipFill,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x22000000)),
                  ],
                ),
                child: Column(
                  children: const [
                    _SettingItem(icon: Icons.person_outline, title: 'Аккаунт'),
                    _Divider(),
                    _SettingItem(icon: Icons.notifications_none, title: 'Уведомления'),
                    _Divider(),
                    _SettingItem(icon: Icons.lock_outline, title: 'Конфиденциальность и\nбезопасность'),
                    _Divider(),
                    _SettingItem(icon: Icons.support_agent, title: 'Помощь и поддержка'),
                    _Divider(),
                    _SettingItem(icon: Icons.description_outlined, title: 'Условия использования'),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Выйти'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppTheme.primary,
                    disabledForegroundColor: Colors.white,
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

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SettingItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()));
      },
      leading: Icon(icon, color: AppTheme.textPrimary),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(height: 1, color: AppTheme.border),
    );
  }
}
