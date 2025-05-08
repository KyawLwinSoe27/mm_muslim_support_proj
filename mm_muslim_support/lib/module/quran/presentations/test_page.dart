// import 'dart:io';
//
// import 'package:audio_session/audio_session.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:mm_muslim_support/model/quran_song_model.dart';
// import 'package:path_provider/path_provider.dart';
//
// class SurahListenPage extends StatefulWidget {
//   const SurahListenPage({super.key, required this.quranSongModel});
//   static const String routeName = '/surah_listen_page';
//
//   final QuranSongModel quranSongModel;
//
//   @override
//   State<SurahListenPage> createState() => _SurahListenPageState();
// }
//
// class _SurahListenPageState extends State<SurahListenPage> {
//   final AudioPlayer _player = AudioPlayer();
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     playFromUrl();
//     // Or use: _setupPlayer(); to test downloaded playback
//   }
//
//   Future<void> playFromUrl() async {
//     print("Initializing audio session...");
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.music());
//
//     try {
//       print("Setting audio URL: ${widget.quranSongModel.mp3Url}");
//       await _player.setUrl(widget.quranSongModel.mp3Url);
//       print("Audio is ready to play. Starting playback...");
//       await _player.play();
//       print("Playback started!");
//     } catch (e) {
//       print("Error setting or playing audio from URL: $e");
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Future<void> _setupPlayer() async {
//     print("Initializing audio session...");
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.music());
//
//     try {
//       final filePath = await _downloadFile(widget.quranSongModel.mp3Url, '${widget.quranSongModel.name}.mp3');
//       if (filePath.isEmpty) {
//         print("Failed to download audio file. Aborting.");
//         return;
//       }
//
//       print("Setting audio from local file: $filePath");
//       await _player.setFilePath(filePath);
//       print("Audio file loaded. Starting playback...");
//       await _player.play();
//       print("Playback started from local file.");
//     } catch (e) {
//       print("Error setting or playing audio from file: $e");
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Future<String> _downloadFile(String url, String fileName) async {
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = '${dir.path}/$fileName';
//     final file = File(filePath);
//
//     if (!await file.exists()) {
//       print("Downloading file from: $url");
//       try {
//         await Dio().download(url, filePath);
//         print("Download complete: $filePath");
//       } catch (e) {
//         print("Error downloading file: $e");
//         return '';
//       }
//     } else {
//       print("File already exists at: $filePath");
//     }
//
//     return filePath;
//   }
//
//   @override
//   void dispose() {
//     print("Disposing audio player.");
//     _player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.quranSongModel.name)),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : StreamBuilder<PlayerState>(
//           stream: _player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final playing = playerState?.playing ?? false;
//             print("Player state updated: playing = $playing");
//
//             return IconButton(
//               iconSize: 64,
//               icon: Icon(playing ? Icons.pause : Icons.play_arrow),
//               onPressed: () {
//                 if (playing) {
//                   print("Pausing audio...");
//                   _player.pause();
//                 } else {
//                   print("Resuming audio...");
//                   _player.play();
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
