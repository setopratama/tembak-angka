import 'package:flutter/material.dart';

import '../providers/version_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Jalankan pengecekan versi saat splash screen muncul
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionService().checkVersion(context);
    });

    // Simulasi loading selama 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark Overlay for readability
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                  const Color(0xFF2E0249).withOpacity(0.9),
                ],
              ),
            ),
          ),
          SafeArea(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD4AAFF),
                  ),
                ),
              if (!_isLoading) ...[
                const Text(
                  'TEBAK ANGKA',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              // Help/Instruction Area
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    if (!_isLoading) ...[
                      const Text(
                        'Cara Bermain:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStep(Icons.looks_one, 'Pikirkan angka antara 1-100'),
                      _buildStep(Icons.input, 'Masukkan tebakanmu di kolom'),
                      _buildStep(Icons.tips_and_updates, 'Ikuti petunjuk "Lebih Besar" atau "Lebih Kecil"'),
                      _buildStep(Icons.emoji_events, 'Temukan angkanya sesegera mungkin!'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Action Button
              if (!_isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AAFF),
                    foregroundColor: const Color(0xFF2E0249),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                  ),
                  child: const Text(
                    'MULAI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ), // End of SafeArea
      ],
    ), // End of Stack
  );
}

  Widget _buildStep(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD4AAFF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
