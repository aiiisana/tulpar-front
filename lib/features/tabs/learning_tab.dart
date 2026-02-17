import 'package:flutter/material.dart';
import '../../app/theme.dart';

class LearningTab extends StatelessWidget {
  const LearningTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        children: [
          _RowCard(
            leftTitle: 'Карточки',
            rightTitle: 'Разговорные клубы',
          ),
          const SizedBox(height: 16),
          _RowCard(
            leftTitle: 'Статьи',
            rightTitle: 'ИИ помощник',
          ),
          const SizedBox(height: 16),
          _RowCard(
            leftTitle: 'Грамматика',
            rightTitle: 'sample',
          ),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;

  const _RowCard({required this.leftTitle, required this.rightTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD8D6CE),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x22000000)),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _MiniTile(title: leftTitle)),
          const SizedBox(width: 12),
          Expanded(child: _MiniTile(title: rightTitle)),
        ],
      ),
    );
  }
}

class _MiniTile extends StatelessWidget {
  final String title;
  const _MiniTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E4DC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 10,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          const Center(
            child: Icon(Icons.image_outlined, color: AppTheme.textSecondary, size: 36),
          ),
        ],
      ),
    );
  }
}
