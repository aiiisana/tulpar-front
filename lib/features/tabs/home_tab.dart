import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/primary_button.dart';
import '../../app/app_storage.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<String> _loadName() async {
    final first = await AppStorage.getFirstName();
    if (first == null || first.trim().isEmpty) return 'Пользователь';
    return first.trim();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadName(),
      builder: (context, snap) {
        final name = snap.data ?? '...';

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Қайырлы таң!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(0, 6),
                          color: Color(0x22000000),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: AppTheme.textSecondary),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 22),

              const Text(
                'Ежедневная практика',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _DayCell(day: 'ПН', date: '15', active: false),
                  _DayCell(day: 'ВТ', date: '16', active: false),
                  _DayCell(day: 'СР', date: '17', active: false),
                  _DayCell(day: 'ЧТ', date: '18', active: true),
                  _DayText(day: 'ПТ', date: '19'),
                  _DayText(day: 'СБ', date: '20'),
                  _DayText(day: 'ВС', date: '21'),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                'Вы занимаетесь уже: 1 день',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),

              const SizedBox(height: 14),
              PrimaryButton(
                text: 'Начать урок',
                onPressed: () {},
              ),

              const SizedBox(height: 18),

              Container(
                height: 360,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1F4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  children: const [
                    Positioned(left: 40, top: 70, child: _StarBubble(size: 64)),
                    Positioned(right: 70, top: 40, child: _StarBubble(size: 78)),
                    Positioned(right: 60, bottom: 120, child: _StarBubble(size: 64)),
                    Positioned(left: 120, bottom: 60, child: _StarBubble(size: 72)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  final String day;
  final String date;
  final bool active;
  const _DayCell({required this.day, required this.date, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppTheme.chipFill : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? AppTheme.primary : AppTheme.border),
      ),
      child: Column(
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
          const SizedBox(height: 3),
          Text(date, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _DayText extends StatelessWidget {
  final String day;
  final String date;
  const _DayText({required this.day, required this.date});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      child: Column(
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
          const SizedBox(height: 6),
          Text(date, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _StarBubble extends StatelessWidget {
  final double size;
  const _StarBubble({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(blurRadius: 8, offset: Offset(0, 5), color: Color(0x22000000))
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.55,
          height: size * 0.55,
          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
          child: const Icon(Icons.star, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
