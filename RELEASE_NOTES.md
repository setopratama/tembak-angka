# v1.0.4+11 - Internet Permission Fix 🌐🛠️

## 📝 Catatan Rilis

### **Apa yang Baru di Versi ini?**
*   **Perbaikan Izin Internet (Internet Permission):** Menambahkan izin akses `INTERNET` pada konfigurasi Android (`AndroidManifest.xml`) untuk memastikan aplikasi dapat mengambil data dari Firebase/Firestore dengan lancar.
*   **Stabilitas Konektivitas:** Memperbaiki masalah di mana aplikasi terkadang tidak dapat melakukan pengecekan pembaruan versi (Force Update) secara online akibat tidak adanya izin jaringan.
*   **Build Baru:** Versi 1.0.4 Build **11**.

---

# v1.0.4+10 - Version Control & Stability 🔒🛠️

## 📝 Catatan Rilis

### **Apa yang Baru di Versi ini?**
*   **Perbaikan Versi Kontrol:** Logika pengecekan versi kini lebih tangguh dengan fitur pembersihan metadata (build number) sebelum dibandingkan, sehingga deteksi update dari Firestore menjadi 100% akurat.
*   **Optimalisasi Force Update:** Peringatan "Wajib Update" kini tampil lebih konsisten sesuai dengan flag yang diatur di Firebase.
*   **Logging Debug:** Penambahan sistem log internal untuk memudahkan pelacakan status koneksi Firestore.
*   **Build Baru:** Versi 1.0.4 Build **10**.

---

# v1.0.3+9 - Splash Screen Refinement 🖼️✨

## 📝 Catatan Rilis

### **Apa yang Baru di Versi ini?**
*   **Pembaruan Splash Screen:** Logo aplikasi pada layar awal (native splash) telah dihilangkan dan diganti dengan gambar splash full-screen agar transisi ke aplikasi terasa lebih mulus dan estetik.
*   **Optimalisasi Asset:** Penyesuaian konfigurasi splash screen untuk mendukung sinkronisasi visual antara sistem Android/iOS dan aplikasi Flutter.
*   **Build Baru:** Versi 1.0.3 Build **9**.

---

# v1.0.3+8 - Audio Balance & Bug Fixes 🎵🛠️

## 📝 Catatan Rilis

### **Apa yang Baru di Versi ini?**
*   **Keseimbangan Audio (Audio Balance):** Musik latar (BGM) kini lebih pelan (25%) agar Efek Suara (SFX) terdengar lebih mendominasi dan jelas.
*   **Perbaikan Bug SFX:** Memperbaiki masalah di mana suara tebakan (Low/High) hilang setelah diputar beberapa kali. Sekarang suara akan selalu muncul setiap kali Anda menebak.
*   **Stabilitas Pemutaran:** Menggunakan pemutar audio yang lebih stabil untuk memastikan suara tidak terputus di tengah permainan.
*   **Build Baru:** Versi 1.0.3 Build **8**.

---

# v1.0.2+3 - Visual & Security Update 🛡️✨

## 📝 Catatan Rilis

### **Apa yang Baru di Versi ini?**
*   **Wallpaper Splash Screen:** Latar belakang layar awal kini menggunakan gambar `splash.jpeg` yang lebih estetik dan premium.
*   **Keamanan API Key:** Perbaikan keamanan dengan menyembunyikan file konfigurasi Firebase (`firebase_options.dart`) dari repositori publik untuk mencegah penyalahgunaan.
*   **Pembaruan UI:** Penyesuaian tombol navigasi menjadi lebih simpel ("MULAI") dan penambahan overlay gradasi untuk keterbacaan yang lebih baik.

---

### **✨ Fitur Utama (Rekap)**
*   **Modern UI/UX:** Desain **Material 3** dengan transisi yang mulus.
*   **Sistem Hint Cerdas:** Indikator warna ("Terlalu Besar/Kecil") yang responsif.
*   **Efek Suara:** Audio imersif untuk setiap aksi dalam game.
*   **Perayaan Confetti:** Animasi kemenangan yang meriah! 🥳

---

### **🛠️ Informasi Teknis**
*   **Versi:** 1.0.4+11
*   **Min. Android SDK:** 21 (Android 5.0)
*   **Status Build:** Internal Testing Track
*   **Ukuran Aplikasi:** Sangat Optimal

---

**Cara Melakukan Build:**
1. Gunakan perintah: `flutter build apk --release` atau `flutter build appbundle`.
2. Jika ada masalah ikon: `flutter build apk --release --no-tree-shake-icons`.

---
*Terakhir Diperbarui: 13 Maret 2026 - Prabu Nusantara Studio*
