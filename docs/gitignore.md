# .gitignore Generator Specification

## Tool Reference
Based on: https://www.toptal.com/developers/gitignore

## Purpose
This specification serves as a **source of truth** for generating project-specific `.gitignore` files. Use this document to instruct AI tools to create consistent `.gitignore` configurations.

## Standard Fields to Track

### Core Technologies
- `git` - Git version control
- `node` - Node.js runtime
- `npm` - NPM package manager
- `yarn` - Yarn package manager
- `pnpm` - PNPM package manager

### Mobile Development
- `android` - Android development
- `flutter` - Flutter framework
- `dart` - Dart language
- `reactnative` - React Native
- `expo` - Expo framework
- `ios` - iOS development
- `xcode` - Xcode IDE

### IDEs and Editors
- `vscode` - Visual Studio Code
- `intellij` - IntelliJ IDEA
- `androidstudio` - Android Studio
- `sublimetext` - Sublime Text

### Operating Systems
- `macos` - macOS
- `windows` - Windows
- `linux` - Linux

## Custom/Override Sections

### Mise Tool Management
```gitignore
# Mise (formerly asdf-vm)
.mise/
.tool-versions
```

### Project-Specific Overrides
Custom patterns for specific project requirements that aren't covered by standard templates.

### Monorepo Structure
App-specific ignores organized by directory structure (e.g., `apps/`, `packages/`).

## Usage Instructions
When generating a `.gitignore` file, specify:
1. Required standard fields from the lists above
2. Any custom sections needed
3. Project structure (monorepo, single app, etc.)

AI will combine the appropriate templates from toptal.com/developers/gitignore with custom overrides.
