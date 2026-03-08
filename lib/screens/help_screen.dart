import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF190019),
      appBar: AppBar(
        title: const Text('Bantuan & FAQ'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E0249),
              Color(0xFF0F0C29),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSection(
              'Cara Bermain',
              Icons.play_arrow,
              [
                '1. Masukkan angka antara 1 sampai 100 pada kolom tebakan.',
                '2. Tekan tombol "Tebak!" untuk mengirim jawaban.',
                '3. Perhatikan petunjuk yang muncul: "Terlalu Besar" atau "Terlalu Kecil".',
                '4. Gunakan petunjuk tersebut untuk menyesuaikan tebakan Anda berikutnya.',
                '5. Menangkan permainan dengan menemukan angka rahasia dalam percobaan sesedikit mungkin!',
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'FAQ',
              Icons.quiz,
              [
                'Q: Berapa angka maksimal yang bisa ditebak?\nA: Angka rahasia selalu berada di rentang 1 sampai 100.',
                'Q: Apakah skor dipengaruhi jumlah percobaan?\nA: Ya, semakin sedikit percobaan, semakin tinggi skor yang Anda peroleh.',
                'Q: Apakah game ini memerlukan koneksi internet?\nA: Tidak, game ini dapat dimainkan sepenuhnya secara offline.',
                'Q: Bagaimana cara memulai game baru?\nA: Tombol "Ulang Permainan" akan muncul setelah Anda berhasil menebak angka.',
              ],
            ),
            const SizedBox(height: 32),
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFD4AAFF), size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item,
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
              ),
            )),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        children: [
          Text(
            'Informasi Game',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          SizedBox(height: 4),
          Text(
            'Tebak Angka - Flutter Edition',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'Versi 1.0.0',
            style: TextStyle(color: Color(0xFFD4AAFF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
