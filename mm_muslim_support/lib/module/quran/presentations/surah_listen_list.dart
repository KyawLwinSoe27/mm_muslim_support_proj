import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/presentations/surah_listen_page.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

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
    _scrollController.dispose(); // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surah List',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        thickness: 10,
        radius: const Radius.circular(4),
        interactive: true,
        thumbVisibility: false, // Set to true to always show the scrollbar
        child: ListView.separated(
          controller: _scrollController,
          itemCount: surahList.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final surah = surahList[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.music_note)),
              trailing: Text(surah.number.toString()),
              title: Text(surah.name, style: context.textTheme.titleMedium),
              onTap: () => context.navigateWithPushNamed(
                SurahListenPageContent.routeName,
                extra: surah,
              ),
            );
          },
        ),
      )
    );
  }
}
