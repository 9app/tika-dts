# Template Architecture

This document explains the template-based architecture for mobile development projects.

## Overview

The workspace now supports template-based project creation for different mobile development frameworks. This allows developers to quickly spin up new projects with pre-configured development environments.

## Template Structure

```
templates/
├── README.md               # Template overview and usage
├── flutter-mise/           # Flutter development template
│   ├── mise.toml          # Flutter-specific mise configuration
│   └── README.md          # Flutter template documentation
└── rn-expo-mise/          # React Native/Expo template
    ├── mise.toml          # React Native/Expo mise configuration
    └── README.md          # React Native template documentation
```

## Available Templates

### 1. Flutter Template (`flutter-mise/`)

**Purpose:** Complete Flutter development environment

**Features:**
- Flutter SDK management (3.32.5-stable)
- Android/iOS/Web development support
- Comprehensive build tasks (APK, App Bundle, iOS, Web)
- Testing automation (unit, widget, integration)
- Code formatting and linting
- Development tools integration

**Key Tasks:**
- `mise run dev` - Development mode
- `mise run build:apk` - Android APK build
- `mise run build:ios` - iOS build
- `mise run test` - Run all tests
- `mise run lint` - Code analysis

### 2. React Native/Expo Template (`rn-expo-mise/`)

**Purpose:** React Native and Expo development environment

**Features:**
- React Native & Expo CLI setup
- EAS Build & Submit integration
- Local and cloud builds
- Over-the-air updates (EAS Update)
- Testing automation
- Development server management

**Key Tasks:**
- `mise run dev` - Start Metro bundler
- `mise run build:eas:android` - EAS Android build
- `mise run build:eas:ios` - EAS iOS build
- `mise run submit:eas:android` - Submit to Google Play
- `mise run update:publish` - Publish OTA update

## Project Creation Workflow

### 1. Using Scripts (Recommended)

```bash
# Create Flutter project (default name: my_flutter_app)
./scripts/create-new-project.sh --template flutter

# Create Expo project (default name: my-expo-app)
./scripts/create-new-project.sh --template expo

# Create with custom names
./scripts/create-new-project.sh --template flutter --name my_custom_flutter_app
./scripts/create-new-project.sh --template expo --name my-custom-expo-app
```

**Process:**
1. Validates template and project name
2. Creates project using framework CLI (`flutter create` or `npx create-expo-app`)
3. Copies template mise.toml configuration
4. Creates basic setup scripts
5. Provides next steps instructions

### 2. Using Mise Tasks

```bash
# Quick project creation
mise run project:create:flutter -- my-flutter-app
mise run project:create:expo -- my-expo-app

# Interactive creation
mise run project:create
```

### 3. Manual Template Application

```bash
# Copy template to existing project
cp templates/flutter-mise/mise.toml your-existing-project/
cd your-existing-project
mise install
```

## Template Management

### Management Script

The `scripts/manage-templates.sh` script provides template management capabilities:

```bash
# List all templates
./scripts/manage-templates.sh list

# Validate template syntax and structure
./scripts/manage-templates.sh validate

# Sync templates with main configuration
./scripts/manage-templates.sh sync

# Create backup of templates
./scripts/manage-templates.sh backup

# Restore from backup
./scripts/manage-templates.sh restore <backup-name>
```

### Mise Tasks for Template Management

```bash
mise run template:list      # List templates
mise run template:validate # Validate templates
mise run template:sync     # Sync with main config
mise run template:backup   # Create backup
```

## Customization

### Adding New Templates

1. Create new template directory in `templates/`
2. Add `mise.toml` with framework-specific configuration
3. Add `README.md` with usage instructions
4. Update `scripts/create-new-project.sh` to support new template
5. Test with `mise run template:validate`

### Modifying Existing Templates

1. Edit template `mise.toml` files
2. Update template documentation
3. Run `mise run template:validate` to verify changes
4. Use `mise run template:sync` to propagate tool version updates

### Template Configuration

Each template includes:

- **Tool Versions:** Node.js, Python, Java, framework-specific tools
- **Environment Variables:** SDK paths, development settings
- **Tasks:** Development, build, test, deployment tasks
- **Paths:** Tool and SDK paths configuration

## Best Practices

### Template Development

1. **Consistency:** Keep tool versions synchronized across templates
2. **Documentation:** Maintain comprehensive README for each template
3. **Validation:** Regular validation checks to ensure template integrity
4. **Testing:** Test template-generated projects thoroughly

### Project Creation

1. **Naming:** Use descriptive, valid project names
2. **Setup:** Always run `mise install` and `mise run doctor` after creation
3. **Verification:** Test core functionality before development
4. **Documentation:** Follow template README for framework-specific setup

### Maintenance

1. **Regular Updates:** Keep templates updated with latest tool versions
2. **Sync Operations:** Use sync commands to maintain consistency
3. **Backups:** Create backups before major template changes
4. **Validation:** Regular validation to catch configuration issues

## Integration with Main Workspace

The template system integrates with the main workspace through:

- **Shared Tool Versions:** Templates sync with main `mise.toml` versions
- **Common Scripts:** Shared utility scripts in `scripts/` directory
- **VS Code Configuration:** Templates work with workspace VS Code settings
- **Documentation:** Unified documentation system

## Future Enhancements

Potential improvements to the template system:

1. **Web Templates:** Add React/Next.js web development templates
2. **Backend Templates:** Node.js, Python API development templates
3. **CI/CD Templates:** GitHub Actions, GitLab CI configurations
4. **Docker Templates:** Containerized development environments
5. **Version Management:** Automated tool version updates
6. **Template Validation:** Enhanced validation and testing
7. **Interactive Setup:** More guided project creation flows
