import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/presentations/surah_listen_page.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class SurahListenList extends StatelessWidget {
  const SurahListenList({super.key});

  static const String routeName = '/surah_listen_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah List'),
      ),
      body: ListView.separated(
        itemCount: surahList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final surah = surahList[index];
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.music_note),
            ),
            trailing: Text(surah.number.toString()),
            title: Text(surah.name, style: context.textTheme.titleMedium),
            onTap: () => context.navigateWithPushNamed(SurahListenPageContent.routeName, extra: surah),
          );
        },
      ),
    );
  }
}
