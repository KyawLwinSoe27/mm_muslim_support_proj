import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _player.playbackEventStream.listen((event) {
      final processingState = _transformState(_player.processingState);

      // if (processingState == AudioProcessingState.completed) {
      //   _player.seek(Duration.zero); // ✅ Reset to start
      // }

      playbackState.add(PlaybackState(
        controls: [
          MediaControl.rewind,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: processingState,
        playing: processingState != AudioProcessingState.completed && _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    });

  }

  AudioProcessingState _transformState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  Future<void> setUrl(QuranSongModel quranSongModel) async {
    final duration = await _player.setUrl(quranSongModel.mp3Url);
    final mediaItem = MediaItem(
      id: quranSongModel.number.toString(),
      album: 'Quran',
      title: 'Surah ${quranSongModel.name}', // Optionally pass dynamic title
      duration: duration,
      artUri: Uri.parse('https://example.com/quran_cover.jpg'), // Optional image
    );

    this.mediaItem.add(mediaItem); // ✅ CORRECT — update the stream
  }

  @override
  Future<void> play() async {
    // If playback has completed, seek to the beginning before playing again
    if (_player.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }
    await _player.play();
  }


  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  Future<void> replay() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }
}
