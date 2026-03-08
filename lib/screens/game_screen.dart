import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../providers/game_provider.dart';
import 'help_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late ConfettiController _confettiController;
  final TextEditingController _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _guessController.dispose();
    super.dispose();
  }

  void _handleGuess() {
    final guessStr = _guessController.text.trim();
    if (guessStr.isEmpty) return;

    final guess = int.tryParse(guessStr);
    if (guess == null || guess < 1 || guess > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan angka valid (1-100)!')),
      );
      return;
    }

    ref.read(gameProvider.notifier).makeGuess(guess);
    _guessController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    // Listen to changes in game state (win event)
    ref.listen(gameProvider, (previous, next) {
      if (next.isWon && (previous == null || !previous.isWon)) {
        _confettiController.play();
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E0249), // Deep Purple
              Color(0xFF0F0C29), // Dark Blue/Black
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main ScrollView
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Dice icon
                    const Icon(Icons.casino, size: 64, color: Colors.white),
                    const SizedBox(height: 16),

                    // Title section
                    const Text(
                      'Tebak Angka',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pikirkan angka antara 1 sampai 100',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 32),

                    // Stats Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7F00FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF7F00FF).withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        'PERCOBAAN KE-${gameState.attempts}',
                        style: const TextStyle(
                          color: Color(0xFFD4AAFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Input Section
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Masukkan Tebakanmu',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _guessController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      enabled: !gameState.isWon,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: '1 - 100',
                        hintStyle: const TextStyle(color: Colors.white24),
                        counterText: "",
                        filled: true,
                        fillColor: Colors.black26,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF7F00FF),
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _handleGuess(),
                    ),
                    const SizedBox(height: 20),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: gameState.isWon ? null : _handleGuess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F00FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Tebak!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Hint card logic
                    if (gameState.lastHint.isNotEmpty)
                      _buildHintCard(gameState),

                    const SizedBox(height: 48),

                    // History Section
                    _buildHistory(gameState),

                    const SizedBox(height: 32),

                    // Reset Button
                    if (gameState.isWon)
                      TextButton.icon(
                        onPressed: () {
                          ref.read(gameProvider.notifier).resetGame();
                          _guessController.clear();
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white70),
                        label: const Text(
                          'Ulang Permainan',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                  ],
                ),
              ),

              // Confetti Overlay
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.purple,
                    Colors.deepPurple,
                    Colors.indigo,
                    Colors.pink,
                  ],
                ),
              ),

              // Audio Control Icon Top Left
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  onPressed: () => _showAudioSettingsEffect(context),
                  icon: Icon(
                    gameState.isMuted
                        ? Icons.volume_off
                        : (gameState.volume > 0.5
                              ? Icons.volume_up
                              : Icons.volume_down),
                    color: Colors.white,
                    size: 28,
                  ),
                  tooltip: 'Settings Audio',
                ),
              ),

              // Help Icon Top Right
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                  tooltip: 'Bantuan & FAQ',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintCard(GameState state) {
    final isError =
        state.lastHint.contains('Besar') || state.lastHint.contains('Kecil');
    final color = state.isWon
        ? Colors.green.withOpacity(0.2)
        : (isError ? const Color(0xFFFF5050).withOpacity(0.2) : Colors.black26);

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? const Color(0xFFFF5050).withOpacity(0.5)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Icon(
            state.isWon
                ? Icons.celebration
                : (state.lastHint.contains('Besar')
                      ? Icons.trending_down
                      : Icons.trending_up),
            color: state.isWon ? Colors.green : const Color(0xFFFF5050),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.lastHint,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(GameState state) {
    if (state.guessHistory.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Tebakan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            itemCount: state.guessHistory.length,
            itemBuilder: (context, index) {
              final item = state.guessHistory[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '#${item.attemptNumber}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${item.number}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.status,
                      style: TextStyle(
                        color: item.status.contains('BENAR')
                            ? Colors.green
                            : (item.status.contains('BESAR')
                                  ? const Color(0xFFFF5050)
                                  : const Color(0xFFFFC000)),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAudioSettingsEffect(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final gameState = ref.watch(gameProvider);
          return AlertDialog(
            backgroundColor: const Color(0xFF2E0249),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Pengaturan Audio',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mute', style: TextStyle(color: Colors.white70)),
                    Switch(
                      value: gameState.isMuted,
                      onChanged: (_) =>
                          ref.read(gameProvider.notifier).toggleMute(),
                      activeThumbColor: const Color(0xFF7F00FF),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Volume',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Slider(
                  value: gameState.volume,
                  onChanged: (val) =>
                      ref.read(gameProvider.notifier).setVolume(val),
                  activeColor: const Color(0xFF7F00FF),
                  inactiveColor: Colors.white12,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Color(0xFFD4AAFF)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
