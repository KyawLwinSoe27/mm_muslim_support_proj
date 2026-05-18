import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/common/bloc/download_file_bloc/download_file_bloc.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_cubit.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_state.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';

class SurahListenPageContent extends StatelessWidget {
  final QuranSongModel quranSongModel;

  static const String routeName = '/surah-listen';

  const SurahListenPageContent({super.key, required this.quranSongModel});

  String _format(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return d.inHours > 0
        ? "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primary.withValues(alpha: 0.3),
                  theme.colorScheme.surface,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Now Playing',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      _buildDownloadButton(theme, primary),
                    ],
                  ),
                ),
                
                const Spacer(flex: 1),

                // Album Art (Kaaba)
                Hero(
                  tag: 'kaaba_image',
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.75,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(ImageConstants.kaaba),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Audio Player Controls
                BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                  builder: (context, state) {
                    bool isPrevVisible = state.currentSurahId > 1;
                    bool isNextVisible = state.currentSurahId != 114;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title & Subtitle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  state.name,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: state.sourceType == AudioSourceType.local
                                      ? Colors.green.withValues(alpha: 0.2)
                                      : Colors.blue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      state.sourceType == AudioSourceType.local
                                          ? Icons.storage_rounded
                                          : Icons.cloud_outlined,
                                      size: 14,
                                      color: state.sourceType == AudioSourceType.local
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      state.sourceType == AudioSourceType.local ? 'Local' : 'Streaming',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: state.sourceType == AudioSourceType.local
                                            ? Colors.green
                                            : Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Surah ${state.currentSurahId}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Progress Bar
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 6,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                              activeTrackColor: primary,
                              inactiveTrackColor: primary.withValues(alpha: 0.15),
                              thumbColor: primary,
                              overlayColor: primary.withValues(alpha: 0.1),
                            ),
                            child: Slider(
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
                          ),
                          
                          // Timers
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _format(state.position),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                Text(
                                  _format(state.duration),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),

                          // Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.skip_previous_rounded),
                                iconSize: 42,
                                color: isPrevVisible 
                                  ? theme.colorScheme.onSurface 
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                                onPressed: isPrevVisible ? () {
                                  final cubit = context.read<AudioPlayerCubit>();
                                  final surah = surahList[state.currentSurahId - 2];
                                  cubit.setAudio(surah);
                                  context.read<DownloadFileBloc>().add(
                                    CheckFileExist(
                                      fileName: surah.filePath,
                                      folder: Folder.quranRecitation,
                                    ),
                                  );
                                } : null,
                              ),
                              
                              // Play/Pause Button
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  ),
                                  iconSize: 56,
                                  color: theme.colorScheme.onPrimary,
                                  onPressed: () {
                                    final cubit = context.read<AudioPlayerCubit>();
                                    state.isPlaying ? cubit.pause() : cubit.play();
                                  },
                                ),
                              ),

                              IconButton(
                                icon: const Icon(Icons.skip_next_rounded),
                                iconSize: 42,
                                color: isNextVisible 
                                  ? theme.colorScheme.onSurface 
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                                onPressed: isNextVisible ? () {
                                  final cubit = context.read<AudioPlayerCubit>();
                                  final surah = surahList[state.currentSurahId];
                                  cubit.setAudio(surah);
                                  context.read<DownloadFileBloc>().add(
                                    CheckFileExist(
                                      fileName: surah.filePath,
                                      folder: Folder.quranRecitation,
                                    ),
                                  );
                                } : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(ThemeData theme, Color primary) {
    return BlocBuilder<DownloadFileBloc, DownloadFileState>(
      builder: (context, state) {
        if (state is DownloadInProgress) {
          return SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: state.progress / 100,
                  strokeWidth: 3,
                  color: primary,
                ),
                Text(
                  '${state.progress}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        } else if (state is DownloadSuccess || (state is FileExist && state.isExist)) {
          return IconButton(
            icon: Icon(Icons.offline_pin_rounded, color: primary),
            iconSize: 32,
            onPressed: () {},
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.download_rounded),
            iconSize: 32,
            color: theme.colorScheme.onSurface,
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
    );
  }
}
