# Flutter App trong Apps Directory

## 🚀 Cách chạy Flutter App

### Bước 1: Cài đặt dependencies
```bash
# Từ thư mục root của project
mise run deps:flutter

# Hoặc thủ công
cd apps/flutter_app
flutter pub get
```

### Bước 2: Kiểm tra devices có sẵn
```bash
cd apps/flutter_app
flutter devices
```

### Bước 3: Chạy app
```bash
# Từ thư mục root - sử dụng mise tasks
mise run flutter          # Chạy trên device mặc định
mise run flutter:android  # Chạy trên Android
mise run flutter:ios      # Chạy trên iOS (macOS only)

# Hoặc chạy trực tiếp từ thư mục app
cd apps/flutter_app
flutter run               # Chạy trên device mặc định
flutter run -d android    # Chạy trên Android
flutter run -d ios        # Chạy trên iOS
```

### Bước 4: Khởi động emulator/simulator nếu cần
```bash
# Android emulator
mise run emulator

# iOS Simulator (macOS only)
mise run simulator
```

## 🛠 Các lệnh hữu ích khác

### Testing
```bash
mise run test:flutter      # Chạy tests
cd apps/flutter_app && flutter test
```

### Building
```bash
mise run build:flutter     # Build cho tất cả platforms
cd apps/flutter_app && flutter build apk       # Build Android APK
cd apps/flutter_app && flutter build ios       # Build iOS
```

### Debugging & Maintenance
```bash
mise run clean:flutter     # Clean và reinstall dependencies
cd apps/flutter_app && flutter clean
cd apps/flutter_app && flutter doctor          # Kiểm tra environment
cd apps/flutter_app && flutter analyze         # Static analysis
```

## 📁 Cấu trúc Flutter App

```
apps/flutter_app/
├── lib/                    # Dart source code
│   └── main.dart          # Entry point
├── android/               # Android-specific code
├── ios/                   # iOS-specific code
├── test/                  # Unit tests
├── pubspec.yaml           # Dependencies
└── README.md              # Flutter app documentation
```

## 🔧 Cấu hình trong mise.toml

Tất cả các task Flutter đã được cấu hình sẵn:
- `flutter` - Chạy app với device tự động detect
- `flutter:android` - Chạy trên Android
- `flutter:ios` - Chạy trên iOS
- `test:flutter` - Chạy tests
- `build:flutter` - Build app
- `clean:flutter` - Clean project
- `deps:flutter` - Cài đặt dependencies

## 💡 Tips

1. **Kiểm tra devices trước khi chạy**: `flutter devices`
2. **Hot reload**: Nhấn `r` trong terminal khi app đang chạy
3. **Hot restart**: Nhấn `R` trong terminal
4. **Quit**: Nhấn `q` để thoát
5. **Chạy trên web**: `flutter run -d chrome` (nếu web được enable)
