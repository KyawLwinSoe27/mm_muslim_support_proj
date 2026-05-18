import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/themes/text_theme.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';
import 'package:mm_muslim_support/module/home/cubit/daily_quran_dua_cubit.dart';
import 'package:mm_muslim_support/repository/content_repository.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class DailyContentSection extends StatefulWidget {
  const DailyContentSection({super.key});

  @override
  State<DailyContentSection> createState() => _DailyContentSectionState();
}

class _DailyContentSectionState extends State<DailyContentSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (!mounted) return;
              setState(() => _currentPage = index);
            },
            children: [
              _QuranVerseCard(),
              _DuaCard(),
              _HadithCard(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(right: index == 2 ? 0 : 6),
              child: _dot(context, isActive: _currentPage == index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot(BuildContext context, {bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? context.colorScheme.primary
            : context.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _QuranVerseCard extends StatefulWidget {
  @override
  State<_QuranVerseCard> createState() => _QuranVerseCardState();
}

class _QuranVerseCardState extends State<_QuranVerseCard> {
  final ContentRepository _repository = ContentRepository();
  late Future<List<DailyQuranDuaModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getQuranVerses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyQuranDuaModel>>(
      future: _future,
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: context.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  'Quran verse coming soon',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocProvider(
            create: (_) => DailyQuranDuaCubit(items),
            child: BlocBuilder<DailyQuranDuaCubit, DailyQuranDuaModel>(
              builder: (context, state) => _ContentCard(
                icon: Icons.auto_stories_rounded,
                title: 'Quran Verse',
                arabic: state.arabic,
                translation: state.translation,
                mmTranslation: state.mmTranslation,
                reference: state.reference,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DuaCard extends StatefulWidget {
  @override
  State<_DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<_DuaCard> {
  final ContentRepository _repository = ContentRepository();
  late Future<List<DailyQuranDuaModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getDailyDuas();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyQuranDuaModel>>(
      future: _future,
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: context.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  'Daily dua coming soon',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocProvider(
            create: (_) => DailyQuranDuaCubit(items),
            child: BlocBuilder<DailyQuranDuaCubit, DailyQuranDuaModel>(
              builder: (context, state) => _ContentCard(
                icon: Icons.menu_book_rounded,
                title: 'Daily Dua',
                arabic: state.arabic,
                translation: state.translation,
                mmTranslation: state.mmTranslation,
                reference: state.reference,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HadithCard extends StatefulWidget {
  @override
  State<_HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<_HadithCard> {
  final ContentRepository _repository = ContentRepository();
  late Future<List<DailyQuranDuaModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getHadiths();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyQuranDuaModel>>(
      future: _future,
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: context.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  'Hadith coming soon',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocProvider(
            create: (_) => DailyQuranDuaCubit(items),
            child: BlocBuilder<DailyQuranDuaCubit, DailyQuranDuaModel>(
              builder: (context, state) => _ContentCard(
                icon: Icons.format_quote_rounded,
                title: 'Hadith of the Day',
                arabic: state.arabic,
                translation: state.translation,
                mmTranslation: state.mmTranslation,
                reference: state.reference,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ContentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String arabic;
  final String translation;
  final String mmTranslation;
  final String reference;

  const _ContentCard({
    required this.icon,
    required this.title,
    required this.arabic,
    required this.translation,
    required this.mmTranslation,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: context.colorScheme.onPrimary),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (reference.isNotEmpty)
                  Text(
                    reference,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    arabic,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: arabicTextStyle(color: context.colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (mmTranslation.isNotEmpty)
              Text(
                mmTranslation,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (mmTranslation.isEmpty)
              Text(
                translation,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
