import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/common/bloc/download_file_bloc/download_file_bloc.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_cubit.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_state.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';

class SurahListenPageContent extends StatelessWidget {
  final QuranSongModel quranSongModel;

  static const String routeName = '/surah-listen';

  const SurahListenPageContent({super.key, required this.quranSongModel});

  String _format(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final outlineVariant = theme.colorScheme.outlineVariant;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Download / progress
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: BlocBuilder<DownloadFileBloc, DownloadFileState>(
                    builder: (context, state) {
                      if (state is DownloadInProgress) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                value: state.progress / 100,
                                strokeWidth: 4,
                                color: primary,
                              ),
                            ),
                            Text(
                              '${state.progress}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: primary,
                              ),
                            ),
                          ],
                        );
                      } else if (state is DownloadSuccess ||
                          (state is FileExist && state.isExist)) {
                        return Icon(
                          Icons.check_circle,
                          color: primary,
                          size: 48,
                        );
                      } else {
                        return IconButton(
                          icon: Icon(Icons.download, color: primary, size: 32),
                          onPressed: () => context.read<DownloadFileBloc>().add(
                            StartDownload(
                              url: quranSongModel.mp3Url,
                              fileName: quranSongModel.filePath,
                              folder: Folder.quranRecitation,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),

              // Quran Image
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(ImageConstants.kaaba, height: 180),
              ),

              // Audio Player Controls
              BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                builder: (context, state) {
                  bool isPrevVisible = state.currentSurahId > 1;
                  bool isNextVisible = state.currentSurahId != 114;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Slider with buffer
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 8,
                            thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 8),
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 16),
                            activeTrackColor: primary,
                            inactiveTrackColor: outlineVariant.withOpacity(0.3),
                            thumbColor: primary,
                            overlayColor: primary.withOpacity(0.2),
                          ),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // Buffered Layer
                              FractionallySizedBox(
                                widthFactor: state.duration.inMilliseconds == 0
                                    ? 0
                                    : state.buffered.inMilliseconds /
                                    state.duration.inMilliseconds,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: outlineVariant.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              // Slider
                              Slider(
                                value: state.duration.inMilliseconds == 0
                                    ? 0
                                    : state.position.inMilliseconds
                                    .clamp(0, state.duration.inMilliseconds)
                                    .toDouble(),
                                min: 0,
                                max: state.duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  context
                                      .read<AudioPlayerCubit>()
                                      .seek(Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        '${_format(state.position)} / ${_format(state.duration)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      // Playback Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: isPrevVisible,
                            child: IconButton(
                              icon: const Icon(Icons.skip_previous_rounded, size: 36),
                              onPressed: () {
                                final cubit = context.read<AudioPlayerCubit>();
                                final surah = surahList[state.currentSurahId - 2];
                                cubit.setAudio(surah);
                                context.read<DownloadFileBloc>().add(
                                  CheckFileExist(
                                    fileName: surah.filePath,
                                    folder: Folder.quranRecitation,
                                  ),
                                );
                              },
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              state.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 64,
                              color: primary,
                            ),
                            onPressed: () {
                              final cubit = context.read<AudioPlayerCubit>();
                              state.isPlaying ? cubit.pause() : cubit.play();
                            },
                          ),

                          Visibility(
                            visible: isNextVisible,
                            child: IconButton(
                              icon: const Icon(Icons.skip_next_rounded, size: 36),
                              onPressed: () {
                                final cubit = context.read<AudioPlayerCubit>();
                                final surah = surahList[state.currentSurahId];
                                cubit.setAudio(surah);
                                context.read<DownloadFileBloc>().add(
                                  CheckFileExist(
                                    fileName: surah.filePath,
                                    folder: Folder.quranRecitation,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}