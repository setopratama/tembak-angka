📱 **TEBAK ANGKA - FLUTTER**
============================

A modern number guessing game built with Flutter for Android devices.

## 📋 Prerequisites

- **Flutter SDK** (version 3.0.0 or higher)
- **Android SDK** (minimum API level 21)
- **Dart** (included with Flutter)

## 🚀 Installation & Setup

### 1. Clone or Extract Project
```bash
cd tebak_angka_flutter
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

### 4. Build APK (Release)
```bash
flutter build apk --release
```

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── screens/
│   └── game_screen.dart        # Main game UI
├── providers/
│   └── game_provider.dart      # State management with Riverpod
└── widgets/
    ├── guess_input_field.dart      # Input widget
    ├── hint_display_widget.dart    # Hint display
    ├── guess_history_widget.dart   # History display
    └── game_stats_widget.dart      # Stats display
```

## 🎮 Features

✅ Random number generation (1-100)
✅ Smart hints (Too big/Too small)
✅ Attempt counter
✅ Guess history with status
✅ Beautiful gradient UI
✅ Confetti celebration animation
✅ Responsive design
✅ Dark/Light theme support
✅ Score calculation system

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Riverpod** - State management
- **Confetti** - Animation effects

## 📝 How to Play

1. Enter a number between 1-100
2. Tap "Tebak!" button
3. Read the hint (Too big/Too small)
4. Use history to narrow down possibilities
5. Win when you find the secret number!
6. Tap "Main Lagi" to play again

## 📱 Supported Devices

- Android 5.0+ (API 21+)
- Responsive for phones and tablets

## 🔧 Troubleshooting

**Build issues:**
```bash
flutter clean
flutter pub get
flutter run
```

**Connection issues:**
```bash
flutter doctor
```

---
*Made with ❤️ for learning Flutter development*
