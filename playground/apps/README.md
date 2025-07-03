# Apps

This directory contains all applications in the monorepo.

## Structure

```
apps/
├── mobile-app/          # React Native or Flutter mobile app
├── web-app/             # Web application (React, Next.js, etc.)
├── admin-dashboard/     # Admin dashboard application
└── ...                  # Other applications
```

## Getting Started

Each app should have its own:
- README.md with setup instructions
- package.json (for Node.js apps) or pubspec.yaml (for Flutter apps)
- Build and deployment configurations

## Developmen

Use the mise commands from the root directory:
```bash
# React Native apps
mise run dev           # Start development server
mise run android       # Run on Android
mise run ios          # Run on iOS

# Flutter apps
mise run flutter       # Run Flutter app
mise run flutter:android
mise run flutter:ios
```
