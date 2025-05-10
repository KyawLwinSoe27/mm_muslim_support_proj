import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/presentations/surah_listen_page.dart';

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
            title: Text(surah.name),
            subtitle: Text(surah.number.toString()),
            // trailing: SizedBox(
            //   width: 100,
            //   child: Row(
            //     children: [
            //       IconButton(
            //         icon: const Icon(Icons.play_arrow),
            //         onPressed: () async{
            //           Directory appDocDir = await getApplicationDocumentsDirectory();
            //           String filePath = '${appDocDir.path}/${Folder.quranRecitation}/${surah.filePath}';
            //           try {
            //             await _player.setFilePath(filePath); // filePath from Bloc state
            //             await _player.play();
            //           } catch (e) {
            //             print("Error playing audio: $e");
            //           }
            //         },
            //       ),
            //       BlocBuilder<DownloadFileBloc, DownloadFileState>(
            //         builder: (context, state) {
            //           if (state is DownloadInProgress) {
            //             // Circular progress with percent inside
            //             return Stack(
            //               alignment: Alignment.center,
            //               children: [
            //                 SizedBox(
            //                   width: 48,
            //                   height: 48,
            //                   child: CircularProgressIndicator(
            //                     value: state.progress / 100,
            //                     strokeWidth: 4,
            //                   ),
            //                 ),
            //                 Text(
            //                   '${state.progress}%',
            //                   style: const TextStyle(fontSize: 12),
            //                 ),
            //               ],
            //             );
            //           } else if (state is DownloadSuccess) {
            //             // Full circle with checkmark
            //             return const Icon(
            //               Icons.check_circle,
            //               color: Colors.green,
            //               size: 48,
            //             );
            //           } else {
            //             // Default download button
            //             return IconButton(
            //               icon: const Icon(Icons.download, size: 32),
            //               onPressed: () {
            //                 context.read<DownloadFileBloc>().add(
            //                   StartDownload(
            //                     url: surah.mp3Url,
            //                     fileName: surah.filePath,
            //                     folder: Folder.quranRecitation,
            //                   ),
            //                 );
            //               },
            //             );
            //           }
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            onTap: () => context.navigateWithPushNamed(SurahListenPageContent.routeName, extra: surah),
          );
        },
      ),
    );
  }
}
