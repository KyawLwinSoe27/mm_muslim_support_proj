import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/module/quran/presentations/quran_screen.dart';
import 'package:mm_muslim_support/utility/constants.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class QuranModel {
  final String title;
  final String link;
  final String fileName;

  const QuranModel({
    required this.title,
    required this.link,
    required this.fileName,
  });
}

class QuranListPage extends StatelessWidget {
  QuranListPage({super.key});

  static const String routeName = '/quran_list_page';

  final List<QuranModel> quranList = [
    const QuranModel(
      title: 'Quran',
      link: AppConstants.quranUrl,
      fileName: 'quran_downloaded.pdf',
    ),
    const QuranModel(
      title: 'Quran Color coded Tajweed Rules',
      link: AppConstants.quranTajweed,
      fileName: 'quran_tajweed_downloaded.pdf',
    ),
    const QuranModel(
      title: 'Quran Myanmar 1',
      link: AppConstants.quranMM1Url,
      fileName: 'quran_mm_1_downloaded.pdf',
    ),
    const QuranModel(
      title: 'Quran Myanmar 2',
      link: AppConstants.quranMM2Url,
      fileName: 'quran_mm_2_downloaded.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.textTheme;
    final colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran List'),
        centerTitle: true,
        backgroundColor: colors.primary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: quranList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final quran = quranList[index];
          return InkWell(
            onTap: () => context.navigateWithPushNamed(
              QuranScreen.routeName,
              extra: quran,
            ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [colors.primary.withOpacity(0.1), colors.primary.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: colors.primary,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      quran.title,
                      style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: colors.primary, size: 18),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}