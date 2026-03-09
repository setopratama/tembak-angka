# Changelog

Semua perubahan penting pada proyek **Tebak Angka** akan didokumentasikan di file ini.

## [1.0.1+2] - 2026-03-09
### Added
- Efek suara baru untuk tebakan yang "Terlalu Kecil" (`low.mp3`).
- Efek suara baru untuk tebakan yang "Terlalu Besar" (`high.mp3`).
- Pendaftaran aset audio baru di `pubspec.yaml`.

### Changed
- Update icon aplikasi (Launcher Icon) menggunakan `flutter_launcher_icons`.
- Build APK sekarang menggunakan flag `--no-tree-shake-icons` untuk kestabilan aset icon.

---

## [1.0.0+1] - 2026-03-09
### Added
- Peluncuran pertama aplikasi **Tebak Angka** versi Flutter.
- Fitur Gameplay: Tebak angka 1-100.
- Fitur UI: Animasi Confetti, Riwayat Tebakan, dan Hint.
- Fitur Audio: Musik latar (BGM) dan efek suara kemenangan (Win SFX).
- Dukungan Mode Gelap (Dark Mode).
