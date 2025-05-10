import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_cubit.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_state.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';

class SurahListenPageContent extends StatelessWidget {
  final QuranSongModel quranSongModel;

  static const String routeName = '/surah-listen';

  const SurahListenPageContent({super.key, required this.quranSongModel});

  String _format(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageConstants.kaaba),
            Text(
              quranSongModel.name,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20),
            BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 6,
                      child: Stack(
                        children: [
                          // Buffered progress (bottom layer)
                          LinearProgressIndicator(
                            value: state.duration.inMilliseconds == 0
                                ? 0
                                : state.buffered.inMilliseconds / state.duration.inMilliseconds,
                            valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.outlineVariant),
                            backgroundColor: Colors.transparent,
                          ),
                          // Played progress (top layer)
                          LinearProgressIndicator(
                            value: state.duration.inMilliseconds == 0
                                ? 0
                                : state.position.inMilliseconds / state.duration.inMilliseconds,
                            valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.primary),
                            backgroundColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${_format(state.position)} / ${_format(state.duration)}'),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: Icon(state.isPlaying ? Icons.pause_circle : Icons.play_circle, size: 64),
                      onPressed: () {
                        final cubit = context.read<AudioPlayerCubit>();
                        state.isPlaying ? cubit.pause() : cubit.play();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
