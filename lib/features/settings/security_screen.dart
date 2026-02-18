import 'package:flutter/material.dart';
import '../../app/security_service.dart';
import '../../app/theme.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

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
                      child: Text('Конфиденциальность и безопасность',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Сменить PIN-код'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  // сначала попросим старый PIN
                  final ok = await _askOldPin(context);
                  if (ok != true) return;

                  // потом новый PIN (SetPinScreen) — но он у нас сразу после сохранения ведёт на DailyGoal
                  // поэтому: используем его только как “установку”, а потом возвращаемся назад.
                  // Проще: открываем отдельный экран смены PIN (ниже).
                  if (!context.mounted) return;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePinFlowScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _askOldPin(BuildContext context) async {
    final sec = SecurityService();
    final ctrl = TextEditingController();
    String? error;

    return showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Введите текущий PIN'),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
              hintText: '••••',
              errorText: error,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () async {
                final ok = await sec.verifyPin(ctrl.text);
                if (!ok) {
                  setState(() => error = 'Неверный PIN-код');
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text('Далее'),
            ),
          ],
        ),
      ),
    );
  }
}

// отдельный flow смены PIN без переходов на DailyGoal
class ChangePinFlowScreen extends StatefulWidget {
  const ChangePinFlowScreen({super.key});

  @override
  State<ChangePinFlowScreen> createState() => _ChangePinFlowScreenState();
}

class _ChangePinFlowScreenState extends State<ChangePinFlowScreen> {
  final sec = SecurityService();

  String first = '';
  String second = '';
  bool confirm = false;
  String? error;

  void tap(String d) {
    setState(() {
      error = null;
      if (!confirm) {
        if (first.length < 4) first += d;
        if (first.length == 4) confirm = true;
      } else {
        if (second.length < 4) second += d;
      }
    });
  }

  void back() {
    setState(() {
      error = null;
      if (!confirm) {
        if (first.isNotEmpty) first = first.substring(0, first.length - 1);
      } else {
        if (second.isNotEmpty) {
          second = second.substring(0, second.length - 1);
        } else {
          confirm = false;
        }
      }
    });
  }

  Future<void> save() async {
    if (first.length != 4 || second.length != 4) return;

    if (first != second) {
      setState(() {
        error = 'PIN-коды не совпадают';
        first = '';
        second = '';
        confirm = false;
      });
      return;
    }

    await sec.setPin(first);
    if (!mounted) return;
    Navigator.pop(context); // назад в SecurityScreen
  }

  @override
  Widget build(BuildContext context) {
    final title = confirm ? 'Повторите новый PIN' : 'Введите новый PIN';
    final val = confirm ? second : first;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back)),
                  const Spacer(),
                ],
              ),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              _Dots(val.length),
              if (error != null) ...[
                const SizedBox(height: 10),
                Text(error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
              const Spacer(),
              if (confirm)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: second.length == 4 ? save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    child: const Text('Сохранить'),
                  ),
                ),
              const SizedBox(height: 12),
              _Keypad(onDigit: tap, onBackspace: back),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  const _Dots(this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final filled = i < count;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppTheme.primary : AppTheme.border,
          ),
        );
      }),
    );
  }
}

class _Keypad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onBackspace;

  const _Keypad({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    Widget btn(String t, {VoidCallback? onTap}) {
      return InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap ?? () => onDigit(t),
        child: Container(
          width: 70,
          height: 56,
          alignment: Alignment.center,
          child: Text(t, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ),
      );
    }

    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [btn('1'), btn('2'), btn('3')]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [btn('4'), btn('5'), btn('6')]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [btn('7'), btn('8'), btn('9')]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 70, height: 56),
            btn('0'),
            btn('⌫', onTap: onBackspace),
          ],
        ),
      ],
    );
  }
}
