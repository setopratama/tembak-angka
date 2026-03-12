# v1.0.1+2 - Release Update 🚀

## 📝 Catatan Rilis

### **Apa yang Baru di Versi ini?**
*   **Splash Screen Interaktif:** Penambahan layar awal baru yang tidak lagi tertutup otomatis. Pemain kini bisa membaca panduan cara bermain sebelum menekan tombol "MULAI BERMAIN".
*   **Audio Mixing Fix:** Mengatasi masalah di mana BGM berhenti saat SFX diputar. Kini musik latar dan suara efek bisa berjalan bersamaan tanpa saling mematikan.
*   **Keystore & Signing Konfigurasi:** Penambahan pengaturan keystore (`key.properties`) untuk mendukung proses rilis resmi ke Google Play Store atau distribusi aplikasi yang terverifikasi.
*   **Migrasi Gradle Kotlin:** Pembaruan skrip `build.gradle.kts` ke standar terbaru untuk performa build yang lebih cepat dan stabil.

---

### **✨ Fitur Utama (Rekap)**
*   **Modern UI/UX:** Desain **Material 3** dengan animasi transisi yang mulus.
*   **Sistem Hint Cerdas:** Umpan balik langsung (Terlalu Besar/Kecil) dengan indikator warna.
*   **Efek Suara:** Audio imersif untuk setiap tebakan dan perayaan kemenangan.
*   **Perayaan Confetti:** Animasi meriah saat Anda berhasil menebak angka dengan benar! 🥳
*   **Riwayat Tebakan:** Lacak semua sejarah angka yang sudah dimasukkan dalam satu sesi.
*   **Dukungan Firebase:** Arsitektur siap pakai untuk integrasi cloud di masa depan.

---

### **🛠️ Informasi Teknis**
*   **Versi:** 1.0.1+2
*   **Min. Android SDK:** 21 (Android 5.0)
*   **Status Build:** Release Ready (Signed)
*   **Ukuran Aplikasi:** Sangat Ringan & Optimal

---

**Cara Melakukan Build:**
1. Pastikan file `android/key.properties` sudah diisi dengan benar.
2. Jalankan perintah: `flutter build appbundle` (untuk Play Store) atau `flutter build apk --release`.
3. File hasil build akan berada di folder `build/app/outputs/`.

---
*Terakhir Diperbarui: 10 Maret 2026 - Prabu Nusantara Studio*
