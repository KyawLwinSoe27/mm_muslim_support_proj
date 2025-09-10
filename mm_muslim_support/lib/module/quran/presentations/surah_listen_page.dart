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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: BlocBuilder<DownloadFileBloc, DownloadFileState>(
                  builder: (context, state) {
                    if (state is DownloadInProgress) {
                      // Circular progress with percent inside
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              value: state.progress / 100,
                              strokeWidth: 4,
                            ),
                          ),
                          Text(
                            '${state.progress}%',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      );
                    } else if (state is DownloadSuccess) {
                      // Full circle with checkmark
                      return Icon(
                        Icons.check_circle,
                        color: context.colorScheme.primary,
                        size: 48,
                      );
                    } else if (state is FileExist) {
                      if (state.isExist) {
                        return Icon(
                          Icons.check_circle,
                          color: context.colorScheme.primary,
                          size: 48,
                        );
                      } else {
                        return IconButton(
                          icon: Icon(
                            Icons.download,
                            color: context.colorScheme.primary,
                            size: 32,
                          ),
                          onPressed: () {
                            context.read<DownloadFileBloc>().add(
                              StartDownload(
                                url: quranSongModel.mp3Url,
                                fileName: quranSongModel.filePath,
                                folder: Folder.quranRecitation,
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      // Default download button
                      return Container();
                    }
                  },
                ),
              ),
            ),
            Image.asset(ImageConstants.kaaba),
            BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
              builder: (context, state) {
                bool isPrevButtonVisible = state.currentSurahId > 1;
                bool isNextButtonVisible = state.currentSurahId != 114;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 10,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        activeTrackColor: context.colorScheme.primary,
                        inactiveTrackColor: context.colorScheme.outlineVariant
                            .withValues(alpha: 0.0),
                        thumbColor: context.colorScheme.onPrimary,
                        overlayColor: context.colorScheme.primary.withValues(
                          alpha: 0.2,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Buffered layer (background)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: FractionallySizedBox(
                                widthFactor:
                                    state.duration.inMilliseconds == 0
                                        ? 0
                                        : state.buffered.inMilliseconds /
                                            state.duration.inMilliseconds,
                                child: Container(
                                  height: 10, // Match your Slider trackHeight
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.outlineVariant
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Slider (played progress + draggable)
                          Slider(
                            value:
                                state.duration.inMilliseconds == 0
                                    ? 0
                                    : state.position.inMilliseconds
                                        .clamp(0, state.duration.inMilliseconds)
                                        .toDouble(),
                            min: 0,
                            max: state.duration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              final position = Duration(
                                milliseconds: value.toInt(),
                              );
                              context.read<AudioPlayerCubit>().seek(position);
                            },
                          ),
                        ],
                      ),
                    ),
                    // Slider(
                    //   value: state.position.inMilliseconds.clamp(0, state.duration.inMilliseconds).toDouble(),
                    //   max: state.duration.inMilliseconds.toDouble(),
                    //   onChanged: (value) {
                    //     // You may optionally emit temp position here if you want to show immediate visual change.
                    //   },
                    //   onChangeEnd: (value) {
                    //     context.read<AudioPlayerCubit>().seek(Duration(milliseconds: value.round()));
                    //   },
                    //   activeColor: context.colorScheme.primary,
                    //   inactiveColor: context.colorScheme.outlineVariant,
                    // ),
                    // SizedBox(
                    //   height: 6,
                    //   child: Stack(
                    //     children: [
                    //       // Buffered progress (bottom layer)
                    //       LinearProgressIndicator(
                    //         value:
                    //             state.duration.inMilliseconds == 0
                    //                 ? 0
                    //                 : state.buffered.inMilliseconds /
                    //                     state.duration.inMilliseconds,
                    //         valueColor: AlwaysStoppedAnimation<Color>(
                    //           context.colorScheme.outlineVariant,
                    //         ),
                    //         backgroundColor: Colors.transparent,
                    //       ),
                    //       // Played progress (top layer)
                    //       LinearProgressIndicator(
                    //         value:
                    //             state.duration.inMilliseconds == 0
                    //                 ? 0
                    //                 : state.position.inMilliseconds /
                    //                     state.duration.inMilliseconds,
                    //         valueColor: AlwaysStoppedAnimation<Color>(
                    //           context.colorScheme.primary,
                    //         ),
                    //         backgroundColor: Colors.transparent,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Text(
                      '${_format(state.position)} / ${_format(state.duration)}',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isPrevButtonVisible,
                          child: IconButton(
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 32,
                            ),
                            onPressed: () {
                              final cubit = context.read<AudioPlayerCubit>();
                              QuranSongModel quranSongModel =
                                  surahList[state.currentSurahId - 2];
                              cubit.setAudio(quranSongModel);
                              context.read<DownloadFileBloc>().add(
                                CheckFileExist(
                                  fileName: quranSongModel.filePath,
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
                          ),
                          onPressed: () {
                            final cubit = context.read<AudioPlayerCubit>();
                            state.isPlaying ? cubit.pause() : cubit.play();
                          },
                        ),

                        Visibility(
                          visible: isNextButtonVisible,
                          child: IconButton(
                            icon: const Icon(Icons.skip_next_rounded, size: 32),
                            onPressed: () {
                              final cubit = context.read<AudioPlayerCubit>();
                              QuranSongModel quranSongModel =
                                  surahList[state.currentSurahId];
                              cubit.setAudio(quranSongModel);
                              context.read<DownloadFileBloc>().add(
                                CheckFileExist(
                                  fileName: quranSongModel.filePath,
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
    );
  }
}
