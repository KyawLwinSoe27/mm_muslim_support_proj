import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/bloc/surah_audio_bloc/surah_audio_bloc.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';

class SurahListenPage extends StatelessWidget {
  QuranSongModel quranSongModel;
  SurahListenPage({super.key, required this.quranSongModel});

  static const String routeName = '/surah_listen_page';

  String _format(Duration d) => '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SurahAudioBloc()..add(SurahAudioLoad(quranSongModel.mp3Url, quranSongModel.name)),
      child: Scaffold(
        body: Center(
          child: BlocListener<SurahAudioBloc, SurahAudioState>(
            listener: (context, state) {
              if (state is SurahAudioError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red, duration: Duration(minutes: 1)));
              } else if (state is SurahAudioLoading) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Loading audio...'), backgroundColor: Colors.blue));
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ImageConstants.kaaba, height: 250),
                const SizedBox(height: 10),
                BlocBuilder<SurahAudioBloc, SurahAudioState>(
                  builder: (context, state) {
                    if (state is SurahAudioNameChanged) {
                      return Text(state.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                    } else {
                      return Text(quranSongModel.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                    }
                  },
                ),
                const SizedBox(height: 20),

                BlocBuilder<SurahAudioBloc, SurahAudioState>(
                  buildWhen: (prev, current) {
                    return current is SurahAudioPlaying ||
                        current is SurahAudioPaused ||
                        current is SurahAudioFinished ||
                        current is SurahAudioLoading;
                  },
                  builder: (context, state) {
                    if (state is SurahAudioLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is SurahAudioPlaying) {
                      return Column(
                        children: [
                          IconButton(icon: const Icon(Icons.pause_circle, size: 64), onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioPause())),
                          Column(
                            children: [
                              LinearProgressIndicator(value: state.duration.inMilliseconds == 0 ? 0 : state.position.inMilliseconds / state.duration.inMilliseconds),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: state.duration.inMilliseconds == 0 ? 0 : state.buffered.inMilliseconds / state.duration.inMilliseconds,
                                color: Colors.grey.withOpacity(0.5),
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(height: 8),
                              Text('${_format(state.position)} / ${_format(state.duration)}'),
                            ],
                          ),
                        ],
                      );
                    } else if (state is SurahAudioPaused) {
                      return Column(
                        children: [
                          IconButton(icon: const Icon(Icons.play_circle, size: 64), onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioPlay())),
                          Column(
                            children: [
                              LinearProgressIndicator(value: state.duration.inMilliseconds == 0 ? 0 : state.position.inMilliseconds / state.duration.inMilliseconds),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: state.duration.inMilliseconds == 0 ? 0 : state.buffered.inMilliseconds / state.duration.inMilliseconds,
                                color: Colors.grey.withOpacity(0.5),
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(height: 8),
                              Text('${_format(state.position)} / ${_format(state.duration)}'),
                            ],
                          ),
                        ],
                      );
                    } else if (state is SurahAudioFinished) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.replay, size: 64), onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioLoad(quranSongModel.mp3Url, quranSongModel.name))),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, size: 64),
                            onPressed: () {
                              int currentId = quranSongModel.number;
                              if(currentId == 114) {
                                currentId = 0;
                              }
                              quranSongModel = surahList.firstWhere((element) => element.number == currentId + 1);
                              context.read<SurahAudioBloc>().add(SurahAudioLoad(quranSongModel.mp3Url, quranSongModel.name));
                            },
                          ),
                        ],
                      );
                    } else {
                      return IconButton(icon: const Icon(Icons.play_circle, size: 64), onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioPlay()));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
