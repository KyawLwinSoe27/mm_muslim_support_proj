import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_muslim_support/module/home/cubit/bottom_navigation_bar_cubit.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.auto_stories_rounded,
        label: 'Quran',
        color: const Color(0xFF1B7A4A),
        onTap: () => context.push('/quran_list_page'),
      ),
      _ActionItem(
        icon: Icons.diamond_rounded,
        label: 'Tasbih',
        color: const Color(0xFF0E6B58),
        onTap: () => context.read<BottomNavigationBarCubit>().changePage(2),
      ),
      _ActionItem(
        icon: Icons.explore_rounded,
        label: 'Qibla',
        color: const Color(0xFF006877),
        onTap: () => context.push('/compass'),
      ),
      _ActionItem(
        icon: Icons.menu_book_rounded,
        label: '99 Names',
        color: const Color(0xFF1B7A4A),
        onTap: () => context.push('/allah_names'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: actions.map((item) => Expanded(child: _ActionCard(item: item))).toList(),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _ActionCard extends StatelessWidget {
  final _ActionItem item;
  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: item.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  item.label,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
