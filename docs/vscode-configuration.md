# VS Code Configuration per Template

Mỗi template trong repository này có VS Code configuration riêng biệt được tối ưu hóa cho framework tương ứng.

## 📁 Template Structure

```
templates/
├── flutter-mise/
│   ├── .vscode/
│   │   ├── tasks.json       # Flutter-specific tasks
│   │   ├── settings.json    # Dart/Flutter settings
│   │   ├── extensions.json  # Flutter/Dart extensions
│   │   └── launch.json      # Flutter debug configs
│   ├── mise.toml
│   └── README.md
└── rn-expo-mise/
    ├── .vscode/
    │   ├── tasks.json       # React Native/Expo tasks
    │   ├── settings.json    # TypeScript/RN settings
    │   ├── extensions.json  # React Native/Expo extensions
    │   └── launch.json      # Expo debug configs
    ├── mise.toml
    └── README.md
```

## 🎯 Flutter Template VS Code Config

### Tasks (tasks.json)
- **mise: Setup Flutter Environment** - Install và setup Flutter SDK
- **mise: Flutter Doctor** - Kiểm tra môi trường Flutter
- **mise: Flutter Run** - Chạy app trong development mode
- **mise: Flutter Run Android** - Chạy specifically trên Android
- **mise: Flutter Run iOS** - Chạy specifically trên iOS
- **mise: Flutter Test** - Chạy tests
- **mise: Flutter Build** - Build production
- **mise: Flutter Clean** - Clean project

### Settings (settings.json)
- Dart SDK auto-detection từ mise
- Flutter formatter settings
- Hot reload configurations
- Dart analyzer settings
- File associations và exclusions

### Extensions (extensions.json)
- `dart-code.flutter` - Flutter support
- `dart-code.dart-code` - Dart language support
- `esbenp.prettier-vscode` - Code formatting
- `usernamehw.errorlens` - Error highlighting
- VS Code essentials

### Launch Configurations (launch.json)
- **Flutter: Debug** - Debug mode với development flavor
- **Flutter: Profile** - Profile mode for performance testing
- **Flutter: Release** - Release mode với production flavor
- **Flutter: Debug (Android)** - Android-specific debug
- **Flutter: Debug (iOS)** - iOS-specific debug

## 🎯 React Native/Expo Template VS Code Config

### Tasks (tasks.json)
- **mise: Setup React Native Environment** - Setup Node.js, npm, Expo CLI
- **mise: Verify Environment** - Verify all tools
- **mise: Environment Doctor** - Comprehensive environment check
- **mise: Start Development Server** - Start Metro bundler
- **mise: Run Android** - Run on Android emulator/device
- **mise: Run iOS** - Run on iOS simulator/device
- **mise: Run Web** - Run on web browser
- **mise: EAS Build** - Build với EAS
- **mise: EAS Submit** - Submit to stores

### Settings (settings.json)
- TypeScript/JavaScript intellisense
- Import management
- Emmet configurations
- File associations cho React Native
- Metro bundler settings
- File exclusions (.expo, node_modules, etc.)

### Extensions (extensions.json)
- `expo.vscode-expo-tools` - Expo development tools
- `ms-vscode.vscode-react-native` - React Native support
- `msjsdiag.vscode-react-native` - React Native debugger
- `ms-vscode.vscode-typescript-next` - TypeScript support
- `esbenp.prettier-vscode` - Code formatting
- `dbaeumer.vscode-eslint` - ESLint integration
- `styled-components.vscode-styled-components` - Styled components

### Launch Configurations (launch.json)
- **Expo: Debug** - Start Expo development server
- **Expo: Debug (Android)** - Launch on Android
- **Expo: Debug (iOS)** - Launch on iOS
- **Expo: Debug (Web)** - Launch on web
- **Expo: Debug with Tunnel** - Development with tunnel

## 🚀 Automatic VS Code Config Setup

Khi sử dụng script `create-new-project.sh`, VS Code configuration và GitHub Copilot instructions sẽ được tự động copy:

```bash
# Tạo Flutter project với VS Code config và Copilot instructions
./scripts/create-new-project.sh --template flutter --name my_flutter_app

# Tạo Expo project với VS Code config và Copilot instructions
./scripts/create-new-project.sh --template expo --name my-expo-app
```

### What Gets Copied:
1. **mise.toml** - Environment và tool configuration
2. **.vscode/** directory - Complete VS Code workspace configuration
3. **.github/instructions/** - Framework-specific Copilot instructions
4. **.github/prompts/** - Development prompts for Copilot
5. **.github/copilot-instructions.md** - Main Copilot instructions file
6. **Basic scripts** - Setup và utility scripts

## 🤖 GitHub Copilot Integration

Mỗi template bao gồm comprehensive GitHub Copilot instructions:

### Flutter Template Copilot Files:
- `.github/copilot-instructions.md` - Main Flutter development instructions
- `.github/instructions/flutter-development.instructions.md` - Core Flutter guidelines
- `.github/instructions/state-management.instructions.md` - Riverpod/BLoC patterns
- `.github/instructions/ui-ux.instructions.md` - Material Design 3 & UI guidelines
- `.github/prompts/flutter-development.prompt.md` - Development prompts
- `.github/prompts/testing.prompt.md` - Testing prompts

### React Native/Expo Template Copilot Files:
- `.github/copilot-instructions.md` - Main React Native/Expo instructions
- `.github/instructions/react-native-development.instructions.md` - Core RN guidelines
- `.github/instructions/state-management.instructions.md` - Redux/Zustand patterns
- `.github/instructions/navigation.instructions.md` - React Navigation patterns
- `.github/prompts/react-native-development.prompt.md` - Development prompts
- `.github/prompts/testing.prompt.md` - Testing prompts

These instructions help GitHub Copilot provide better, more accurate suggestions that follow framework best practices.

## 🔧 Customization

Sau khi tạo project, bạn có thể customize VS Code config:

### Flutter Projects:
- Adjust Dart analyzer settings trong `settings.json`
- Add thêm Flutter-specific extensions
- Customize debug configurations

### React Native/Expo Projects:
- Configure TypeScript settings
- Add thêm React Native extensions
- Customize Metro bundler settings
- Setup EAS configurations

## 💡 Best Practices

1. **Keep template configs minimal** - Chỉ include essential settings
2. **Document customizations** - Note any project-specific changes
3. **Update templates regularly** - Keep extensions và settings up-to-date
4. **Test configurations** - Verify settings work across team members
5. **Version control** - Include `.vscode` in project git repository

## 🔄 Template Maintenance

Use `manage-templates.sh` script để maintain templates:

```bash
# Validate all templates
./scripts/manage-templates.sh --action validate

# List available templates
./scripts/manage-templates.sh --action list

# Backup templates
./scripts/manage-templates.sh --action backup
```

## 📚 See Also

- [Template Architecture Documentation](./template-architecture.md)
- [Project Creation Guide](../QUICKSTART.md)
- [Flutter Template README](../templates/flutter-mise/README.md)
- [React Native Template README](../templates/rn-expo-mise/README.md)
