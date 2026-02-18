import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/presentations/surah_listen_page.dart';

class SurahListenList extends StatefulWidget {
  const SurahListenList({super.key});

  static const String routeName = '/surah_listen_list';

  @override
  State<SurahListenList> createState() => _SurahListenListState();
}

class _SurahListenListState extends State<SurahListenList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surah List',
          style: theme.textTheme.titleLarge?.copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Scrollbar(
        controller: _scrollController,
        thickness: 8,
        radius: const Radius.circular(8),
        thumbVisibility: true, // always show thumb
        trackVisibility: false,
        interactive: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView.separated(
            controller: _scrollController,
            itemCount: surahList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final surah = surahList[index];

              return GestureDetector(
                onTap: () => context.navigateWithPushNamed(
                  SurahListenPageContent.routeName,
                  extra: surah,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: surfaceColor,
                        child: Text(
                          surah.number.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          surah.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: onPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.play_circle_fill,
                        color: onPrimary,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}