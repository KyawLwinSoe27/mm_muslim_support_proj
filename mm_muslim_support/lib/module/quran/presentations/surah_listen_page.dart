import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/bloc/surah_audio_bloc/surah_audio_bloc.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';

class SurahListenPage extends StatelessWidget {
  final QuranSongModel quranSongModel;
  const SurahListenPage({super.key, required this.quranSongModel});

  static const String routeName = '/surah_listen_page';

  String _format(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SurahAudioBloc()..add(SurahAudioLoad(quranSongModel.mp3Url)),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<SurahAudioBloc, SurahAudioState>(
            builder: (context, state) {
              if (state is SurahAudioPlaying) {
                if(state.position == Duration.zero) {
                  context.read<SurahAudioBloc>().add(SurahAudioPause());
                }
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(ImageConstants.kaaba, height: 250),
                  const SizedBox(height: 10),
                  Text(
                    'Surah ${quranSongModel.name}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (state is SurahAudioLoading)
                    const CircularProgressIndicator()
                  else if (state is SurahAudioPlaying)
                    IconButton(
                      icon: const Icon(Icons.pause_circle, size: 64),
                      onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioPause()),
                    )
                  else if (state is SurahAudioPaused)
                      IconButton(
                        icon: const Icon(Icons.play_circle, size: 64),
                        onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioPlay()),
                      )
                  else if (state is SurahAudioFinished) 
                    IconButton(
                      icon: const Icon(Icons.replay, size: 64),
                      onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioLoad(quranSongModel.mp3Url)),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.play_circle, size: 64),
                      onPressed: () => context.read<SurahAudioBloc>().add(SurahAudioPlay()),
                    ),
                  const SizedBox(height: 20),
                  if (state is SurahAudioPlaying)
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: state.duration.inMilliseconds == 0
                              ? 0
                              : state.position.inMilliseconds / state.duration.inMilliseconds,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: state.duration.inMilliseconds == 0
                              ? 0
                              : state.buffered.inMilliseconds / state.duration.inMilliseconds,
                          color: Colors.grey.withOpacity(0.5),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 8),
                        Text('${_format(state.position)} / ${_format(state.duration)}'),
                      ],
                    ),
                  if (state is SurahAudioPaused)
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: state.duration.inMilliseconds == 0
                              ? 0
                              : state.position.inMilliseconds / state.duration.inMilliseconds,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: state.duration.inMilliseconds == 0
                              ? 0
                              : state.buffered.inMilliseconds / state.duration.inMilliseconds,
                          color: Colors.grey.withOpacity(0.5),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 8),
                        Text('${_format(state.position)} / ${_format(state.duration)}'),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
