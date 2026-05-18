import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/routing/app_router.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_cubit.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_state.dart';
import 'package:mm_muslim_support/module/quran/presentation/surah_listen_page.dart';

class GlobalMiniPlayer extends StatelessWidget {
  const GlobalMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (context, state) {
        final currentSong = context.read<AudioPlayerCubit>().currentSong;
        if (currentSong == null) return const SizedBox.shrink();

        final theme = Theme.of(context);
        return SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () {
              // We use AppRouter.router instead of context.pushNamed because 
              // this widget sits outside the GoRouter context in MaterialApp.builder
              AppRouter.router.pushNamed(
                SurahListenPageContent.routeName,
                extra: currentSong,
              );
            },
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.audiotrack_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                state.name.isNotEmpty ? state.name : currentSong.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: state.sourceType == AudioSourceType.local
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    state.sourceType == AudioSourceType.local
                                        ? Icons.storage_rounded
                                        : Icons.cloud_outlined,
                                    size: 10,
                                    color: state.sourceType == AudioSourceType.local
                                        ? Colors.green
                                        : Colors.blue,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    state.sourceType == AudioSourceType.local ? 'Local' : 'Stream',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 9,
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
                        Text(
                          'Surah ${currentSong.number}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                    onPressed: () {
                      final cubit = context.read<AudioPlayerCubit>();
                      state.isPlaying ? cubit.pause() : cubit.play();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                    ),
                    onPressed: () {
                      context.read<AudioPlayerCubit>().stopAndClear();
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
