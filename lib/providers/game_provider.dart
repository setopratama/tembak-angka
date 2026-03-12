import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

class GameState {
  final int secretNumber;
  final int attempts;
  final bool isWon;
  final String lastHint;
  final List<GuessResult> guessHistory;
  final bool isMuted;
  final double volume;

  GameState({
    required this.secretNumber,
    this.attempts = 1,
    this.isWon = false,
    this.lastHint = '',
    this.guessHistory = const [],
    this.isMuted = false,
    this.volume = 0.5,
  });

  GameState copyWith({
    int? secretNumber,
    int? attempts,
    bool? isWon,
    String? lastHint,
    List<GuessResult>? guessHistory,
    bool? isMuted,
    double? volume,
  }) {
    return GameState(
      secretNumber: secretNumber ?? this.secretNumber,
      attempts: attempts ?? this.attempts,
      isWon: isWon ?? this.isWon,
      lastHint: lastHint ?? this.lastHint,
      guessHistory: guessHistory ?? this.guessHistory,
      isMuted: isMuted ?? this.isMuted,
      volume: volume ?? this.volume,
    );
  }
}

class GuessResult {
  final int number;
  final String status;
  final int attemptNumber;

  GuessResult({
    required this.number,
    required this.status,
    required this.attemptNumber,
  });
}

class GameNotifier extends StateNotifier<GameState> {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  GameNotifier() : super(GameState(secretNumber: _generateRandomNumber())) {
    _setupAudio();
    _initGame();
  }

  Future<void> _setupAudio() async {
    // Memberitahu sistem Android agar musik aplikasi bisa jalan berbarengan dengan sfx dan tidak saling menggantikan
    final audioContext = AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.gainTransientMayDuck,
    );
    
    AudioLogger.logLevel = AudioLogLevel.error;
    AudioPlayer.global.setAudioContext(AudioContext(android: audioContext));
  }

  static int _generateRandomNumber() {
    return Random().nextInt(100) + 1;
  }

  void _initGame() {
    state = GameState(secretNumber: _generateRandomNumber());
    _playBgm();
  }

  Future<void> _playBgm() async {
    try {
      if (_bgmPlayer.state == PlayerState.playing) return;
      
      await _bgmPlayer.setVolume(state.isMuted ? 0 : state.volume * 0.4);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
    } catch (e) {
      debugPrint('Audio Error (BGM): $e');
    }
  }

  void makeGuess(int guess) async {
    if (state.isWon) return;

    String hint;
    bool isWon = false;

    if (guess == state.secretNumber) {
      hint = 'Selamat! Anda menemukan angka $guess 🎉';
      isWon = true;

      // Play Win Sound (70% of master volume)
      if (!state.isMuted) {
        _sfxPlayer.setVolume(state.volume * 0.7);
        _sfxPlayer.play(AssetSource('audio/win.mp3'));
      }
    } else if (guess < state.secretNumber) {
      hint = 'Terlalu Kecil! Coba angka yang lebih besar 📈';
      // Play Low Sound (70% of master volume)
      if (!state.isMuted) {
        _sfxPlayer.setVolume(state.volume * 0.7);
        _sfxPlayer.play(AssetSource('audio/low.mp3'));
      }
    } else {
      hint = 'Terlalu Besar! Coba angka yang lebih kecil 📉';
      // Play High Sound (70% of master volume)
      if (!state.isMuted) {
        _sfxPlayer.setVolume(state.volume * 0.7);
        _sfxPlayer.play(AssetSource('audio/high.mp3'));
      }
    }

    final newHistory = [
      GuessResult(
        number: guess,
        status: hint.split('!')[0].toUpperCase(),
        attemptNumber: state.attempts,
      ),
      ...state.guessHistory
    ];

    state = state.copyWith(
      attempts: isWon ? state.attempts : state.attempts + 1,
      isWon: isWon,
      lastHint: hint,
      guessHistory: newHistory,
    );
  }

  void resetGame() {
    _initGame();
    if (!state.isMuted) {
      if (_bgmPlayer.state != PlayerState.playing) {
        _bgmPlayer.resume();
      }
    }
  }

  void toggleMute() {
    final newMuteStatus = !state.isMuted;
    state = state.copyWith(isMuted: newMuteStatus);
    if (newMuteStatus) {
      _bgmPlayer.pause();
    } else {
      _bgmPlayer.setVolume(state.volume * 0.4);
      _bgmPlayer.resume();
    }
  }

  void setVolume(double value) {
    state = state.copyWith(volume: value);
    if (!state.isMuted) {
      _bgmPlayer.setVolume(value * 0.4); // BGM 40% dari Master
      _sfxPlayer.setVolume(value * 0.7); // SFX 70% dari Master
    }
  }

  void handleAppLifecycle(bool isResumed) {
    if (isResumed) {
      // Hanya resume jika tidak dimute dan permainan belum dimenangkan
      if (!state.isMuted && !state.isWon) {
        _bgmPlayer.resume();
      }
    } else {
      _bgmPlayer.pause();
    }
  }

  @override
  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
