#!/bin/bash

# Production Build Script

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "other"
    fi
}

build_react_native_android() {
    print_status "Building React Native Android app..."
    
    if [[ ! -f "android/build.gradle" ]]; then
        print_warning "No React Native Android project found"
        return
    fi
    
    cd android
    
    # Clean previous builds
    print_status "Cleaning previous builds..."
    if ! ./gradlew clean; then
        print_error "Failed to clean previous builds"
        cd ..
        return 1
    fi
    
    # Build release APK
    print_status "Building release APK..."
    if ./gradlew assembleRelease; then
        print_success "✓ Android APK built successfully"
        echo "APK location: android/app/build/outputs/apk/release/"
        ls -la app/build/outputs/apk/release/*.apk 2>/dev/null || true
    else
        print_error "Failed to build Android APK"
        cd ..
        return 1
    fi
    
    # Build release AAB (for Play Store)
    print_status "Building release AAB..."
    if ./gradlew bundleRelease; then
        print_success "✓ Android AAB built successfully"
        echo "AAB location: android/app/build/outputs/bundle/release/"
        ls -la app/build/outputs/bundle/release/*.aab 2>/dev/null || true
    else
        print_error "Failed to build Android AAB"
        cd ..
        return 1
    fi
    
    cd ..
}

build_react_native_ios() {
    OS=$(detect_os)
    if [[ "$OS" != "macos" ]]; then
        print_warning "iOS builds are only available on macOS"
        return
    fi
    
    print_status "Building React Native iOS app..."
    
    if [[ ! -f "ios/Podfile" ]]; then
        print_warning "No React Native iOS project found"
        return
    fi
    
    cd ios
    
    # Install pods
    print_status "Installing/updating CocoaPods..."
    if ! pod install; then
        print_error "Failed to install CocoaPods dependencies"
        cd ..
        return 1
    fi
    
    # Clean previous builds
    print_status "Cleaning previous builds..."
    rm -rf build
    
    # Build for release
    print_status "Building iOS app for release..."
    if xcodebuild -workspace *.xcworkspace \
                  -scheme "$(ls *.xcworkspace | sed 's/.xcworkspace//')" \
                  -configuration Release \
                  -destination generic/platform=iOS \
                  -archivePath build/Release.xcarchive \
                  archive; then
        print_success "✓ iOS app archived successfully"
        echo "Archive location: ios/build/Release.xcarchive"
    else
        print_error "Failed to build iOS app"
        cd ..
        return 1
    fi
    
    cd ..
}

build_flutter() {
    print_status "Building Flutter apps..."
    
    if [[ ! -f "pubspec.yaml" ]]; then
        print_warning "No Flutter project found"
        return
    fi
    
    # Clean and get dependencies
    print_status "Cleaning Flutter project..."
    if ! flutter clean || ! flutter pub get; then
        print_error "Failed to clean Flutter project or get dependencies"
        return 1
    fi
    
    # Build Android APK
    print_status "Building Flutter Android APK..."
    if flutter build apk --release; then
        print_success "✓ Flutter Android APK built successfully"
        echo "APK location: build/app/outputs/flutter-apk/"
        ls -la build/app/outputs/flutter-apk/*.apk 2>/dev/null || true
    else
        print_error "Failed to build Flutter Android APK"
        return 1
    fi
    
    # Build Android AAB
    print_status "Building Flutter Android AAB..."
    if flutter build appbundle --release; then
        print_success "✓ Flutter Android AAB built successfully"
        echo "AAB location: build/app/outputs/bundle/release/"
        ls -la build/app/outputs/bundle/release/*.aab 2>/dev/null || true
    else
        print_error "Failed to build Flutter Android AAB"
        return 1
    fi
    
    # Build iOS (macOS only)
    local os_type=$(detect_os)
    if [[ "$os_type" == "macos" ]]; then
        print_status "Building Flutter iOS app..."
        if flutter build ios --release --no-codesign; then
            print_success "✓ Flutter iOS app built successfully"
            echo "iOS build location: build/ios/iphoneos/"
        else
            print_error "Failed to build Flutter iOS app"
            return 1
        fi
    else
        print_warning "Skipping iOS build (not on macOS)"
    fi
}

run_tests() {
    print_status "Running tests before build..."
    
    local test_failed=false
    
    # Run React Native tests
    if [[ -f "package.json" ]] && command -v npm >/dev/null 2>&1; then
        print_status "Running React Native tests..."
        if ! npm test -- --watchAll=false; then
            test_failed=true
        fi
    fi
    
    # Run Flutter tests
    if [[ -f "pubspec.yaml" ]] && command -v flutter >/dev/null 2>&1; then
        print_status "Running Flutter tests..."
        if ! flutter test; then
            test_failed=true
        fi
    fi
    
    if [[ "$test_failed" == "true" ]]; then
        print_error "Some tests failed!"
        read -p "Continue with build anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Build cancelled due to test failures"
            exit 1
        fi
    else
        print_success "All tests passed"
    fi
}

check_environment() {
    print_status "Checking build environment..."
    
    # Check if mise is activated
    if [[ -z "$MISE_SHELL" ]]; then
        print_error "Mise is not activated. Please run: eval \"\$(mise activate)\""
        exit 1
    fi
    
    # Check required tools
    local missing_tools=()
    
    if [[ -f "package.json" ]]; then
        if ! command -v node >/dev/null; then
            missing_tools+=("node")
        fi
        if ! command -v npm >/dev/null; then
            missing_tools+=("npm")
        fi
    fi
    
    if [[ -f "pubspec.yaml" ]]; then
        if ! command -v flutter >/dev/null; then
            missing_tools+=("flutter")
        fi
    fi
    
    if ! command -v java >/dev/null; then
        missing_tools+=("java")
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_status "Run 'mise install' to install missing tools"
        exit 1
    fi
    
    print_success "Build environment looks good"
}

create_output_summary() {
    print_status "Build output summary:"
    echo
    echo "📦 Generated files:"
    
    # React Native outputs
    if [[ -d "android/app/build/outputs" ]]; then
        echo "React Native Android:"
        find android/app/build/outputs -name "*.apk" -o -name "*.aab" 2>/dev/null | while read -r file; do
            size=$(du -h "$file" | cut -f1)
            echo "  • $file ($size)"
        done
    fi
    
    if [[ -d "ios/build" ]]; then
        echo "React Native iOS:"
        find ios/build -name "*.xcarchive" 2>/dev/null | while read -r file; do
            echo "  • $file"
        done
    fi
    
    # Flutter outputs
    if [[ -d "build/app/outputs" ]]; then
        echo "Flutter Android:"
        find build/app/outputs -name "*.apk" -o -name "*.aab" 2>/dev/null | while read -r file; do
            size=$(du -h "$file" | cut -f1)
            echo "  • $file ($size)"
        done
    fi
    
    if [[ -d "build/ios/iphoneos" ]]; then
        echo "Flutter iOS:"
        echo "  • build/ios/iphoneos/Runner.app"
    fi
}

main() {
    echo
    echo "🏗️ Production Build Script"
    echo "=========================="
    echo
    
    # Parse arguments
    SKIP_TESTS=false
    BUILD_TARGET="all"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-tests)
                SKIP_TESTS=true
                shift
                ;;
            --android-only)
                BUILD_TARGET="android"
                shift
                ;;
            --ios-only)
                BUILD_TARGET="ios"
                shift
                ;;
            --flutter-only)
                BUILD_TARGET="flutter"
                shift
                ;;
            --rn-only)
                BUILD_TARGET="react-native"
                shift
                ;;
            --help|-h)
                echo "🏗️ Production Build Script"
                echo "=========================="
                echo
                echo "Usage: $0 [options]"
                echo
                echo "Options:"
                echo "  --skip-tests           Skip running tests before build"
                echo "  --android-only         Build only Android apps"
                echo "  --ios-only             Build only iOS apps (macOS only)"
                echo "  --flutter-only         Build only Flutter apps"
                echo "  --rn-only              Build only React Native apps"
                echo "  --help, -h             Show this help message"
                echo
                echo "Examples:"
                echo "  $0                     # Build all apps with tests"
                echo "  $0 --skip-tests        # Build all apps without tests"
                echo "  $0 --flutter-only      # Build only Flutter apps"
                echo "  $0 --android-only      # Build only Android apps"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Usage: $0 [--skip-tests] [--android-only|--ios-only|--flutter-only|--rn-only]"
                echo "Use --help for more information"
                exit 1
                ;;
        esac
    done
    
    check_environment
    
    if [[ "$SKIP_TESTS" != "true" ]]; then
        run_tests
    else
        print_warning "Skipping tests as requested"
    fi
    
    case $BUILD_TARGET in
        "android")
            build_react_native_android || print_error "Android build failed"
            ;;
        "ios")
            build_react_native_ios || print_error "iOS build failed"
            ;;
        "flutter")
            build_flutter || print_error "Flutter build failed"
            ;;
        "react-native")
            build_react_native_android || print_error "Android build failed"
            build_react_native_ios || print_error "iOS build failed"
            ;;
        "all")
            local android_success=true
            local ios_success=true
            local flutter_success=true
            
            build_react_native_android || android_success=false
            build_react_native_ios || ios_success=false
            build_flutter || flutter_success=false
            
            if [[ "$android_success" == "false" ]] || [[ "$ios_success" == "false" ]] || [[ "$flutter_success" == "false" ]]; then
                print_warning "Some builds failed. Check the output above for details."
            fi
            ;;
    esac
    
    create_output_summary
    
    echo
    print_success "🎉 Build process completed!"
    echo
    echo "Next steps:"
    echo "• Test the built apps on devices/emulators"
    echo "• Sign iOS builds for distribution (if needed)"
    echo "• Upload to app stores"
    echo
}

main "$@"
