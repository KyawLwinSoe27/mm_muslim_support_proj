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
    required this.fileName
  });
}

class QuranListPage extends StatelessWidget {
   QuranListPage({super.key});

  static const String routeName = '/quran_list_page';


  final List<QuranModel> quranList = [
    const QuranModel(title: 'Quran', link: AppConstants.quranUrl, fileName: 'quran_downloaded.pdf'),
    const QuranModel(title: 'Quran Myanmar 1', link: AppConstants.quranMM1Url, fileName: 'quran_mm_1_downloaded.pdf'),
    const QuranModel(title: 'Quran Myanmar 2', link: AppConstants.quranMM2Url, fileName: 'quran_mm_2_downloaded.pdf'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran List'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: quranList.length,
        itemBuilder: (context, index) {
          final quran = quranList[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(Icons.menu_book_rounded, color: Colors.teal, size: 32),
              title: Text(
                quran.title,
                style: context.textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => context.navigateWithPushNamed(QuranScreen.routeName, extra: quran),
            ),
          );
        },
      ),
    );
  }
}
