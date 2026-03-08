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
    _initGame();
    _playBgm();
  }

  static int _generateRandomNumber() {
    return Random().nextInt(100) + 1;
  }

  void _initGame() {
    state = GameState(secretNumber: _generateRandomNumber());
  }

  Future<void> _playBgm() async {
    try {
      // Pastikan volume diatur SEBELUM play
      await _bgmPlayer.setVolume(state.isMuted ? 0 : state.volume * 0.5);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      // Mulai putar musik latar secara loop
      await _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
    } catch (e) {
      // Menghindari crash jika audio gagal dimuat di platform tertentu
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

      // Play Win Sound
      if (!state.isMuted) {
        _bgmPlayer.pause(); // Jeda musik latar saat menang agar suara kemenangan jelas
        _sfxPlayer.setVolume(state.volume);
        _sfxPlayer.play(AssetSource('audio/win.mp3'));
      }
    } else if (guess < state.secretNumber) {
      hint = 'Terlalu Kecil! Coba angka yang lebih besar 📈';
    } else {
      hint = 'Terlalu Besar! Coba angka yang lebih kecil 📉';
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
    // Memutar kembali musik latar saat permainan diulang
    if (!state.isMuted) {
      _bgmPlayer.resume();
    }
  }

  void toggleMute() {
    final newMuteStatus = !state.isMuted;
    state = state.copyWith(isMuted: newMuteStatus);
    if (newMuteStatus) {
      _bgmPlayer.pause();
    } else {
      _bgmPlayer.setVolume(state.volume * 0.5);
      _bgmPlayer.resume();
    }
  }

  void setVolume(double value) {
    state = state.copyWith(volume: value);
    if (!state.isMuted) {
      _bgmPlayer.setVolume(value * 0.5);
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
