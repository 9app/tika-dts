# Playground & Experimentation Directory

This directory contains experimental projects, testing applications, and serves as the source of truth for template validation.

## 📁 Directory Structure

```
playground/
├── apps/                    # Test applications and experiments
│   ├── flutter_app/        # Flutter test application
│   ├── mobile-app/         # React Native test application
│   └── web-app/            # Web test application
├── packages/               # Shared packages and libraries for testing
├── scripts/                # Testing and template management scripts
│   ├── manage-templates.sh    # Template management utilities
│   ├── test-runner.sh         # Automated template validation
│   └── verify.sh             # Template verification script
└── README.md              # This file
```

## 🎯 Purpose

### 1. Template Validation
- **Source of Truth**: Reference implementations showing how templates should work
- **Testing Ground**: Validate template changes before deploying to production
- **Integration Testing**: Test cross-template compatibility and shared components

### 2. Experimentation
- **New Features**: Test new development patterns and tools
- **Technology Evaluation**: Experiment with new libraries and frameworks
- **Performance Testing**: Benchmark different approaches and optimizations

### 3. Development Workflows
- **Script Testing**: Validate automation scripts in isolated environment
- **Build Process**: Test build and deployment pipelines
- **CI/CD**: Validate continuous integration workflows

## 🚀 Usage

### Testing Template Changes
```bash
# Test Flutter template
cd playground/apps/flutter_app
mise install
mise run setup:android
mise run test

# Test React Native template
cd playground/apps/mobile-app
npm install
npm run android
npm test
```

### Creating Test Projects
```bash
# Create new test project from template
cd playground
../scripts/create-new-project.sh --template flutter --name test-flutter-app --path ./apps/
../scripts/create-new-project.sh --template expo --name test-expo-app --path ./apps/
```

### Verifying Templates
```bash
# Verify template integrity
cd playground
./scripts/verify.sh
```

## 📋 Test Applications

### 🔵 Flutter App (`apps/flutter_app/`)
- **Purpose**: Reference Flutter implementation
- **Features**: Demonstrates all template capabilities
- **Testing**: Validates Flutter mise configuration
- **Architecture**: Clean architecture with BLoC pattern

### 🟢 Mobile App (`apps/mobile-app/`)
- **Purpose**: Reference React Native/Expo implementation
- **Features**: Demonstrates React Query patterns
- **Testing**: Validates React Native template configuration
- **Architecture**: Feature-based with TypeScript

### 🌐 Web App (`apps/web-app/`)
- **Purpose**: Web-specific testing and experiments
- **Features**: Progressive Web App capabilities
- **Testing**: Cross-platform compatibility validation

## 🔧 Scripts

### `manage-templates.sh`
- **Purpose**: Template management and synchronization
- **Usage**: Keep test projects in sync with template changes
- **Features**: Batch operations on multiple test projects

### `verify.sh`
- **Purpose**: Comprehensive template and project verification
- **Usage**: Automated testing of template integrity
- **Features**: Multi-platform validation checks

### `test-runner.sh`
- **Purpose**: Automated template validation and testing
- **Usage**: Continuous integration and comprehensive validation
- **Features**: Multi-template testing with different scenarios

> **📝 Note**: Production scripts for project creation, environment setup and build automation are located in the root `../scripts/` directory:
> - `create-new-project.sh` - General project creation from templates
> - `setup.sh`, `setup-android.sh`, `setup-ios.sh` - Development environment setup
> - `build.sh` - Production build automation
>
> Test scripts in this directory focus specifically on template validation and experimentation workflows.

## 🧪 Testing Workflows

### 1. Template Development Cycle
```bash
# 1. Make changes to templates/
# 2. Test changes in playground environment
cd playground
../scripts/create-new-project.sh --template flutter --name validation-test --path apps/
cd apps/validation-test
mise install && mise run test

# 3. Verify all existing test apps still work
./scripts/verify.sh

# 4. Deploy template changes if validation passes
```

### 2. Feature Experimentation
```bash
# 1. Create experimental branch
git checkout -b experiment/new-feature

# 2. Implement in playground apps first
cd playground/apps/flutter_app
# Add experimental feature

# 3. Validate and refine
mise run test
mise run lint

# 4. Extract to template if successful
```

### 3. Cross-Platform Validation
```bash
# Test same feature across platforms
cd playground/apps/flutter_app && mise run test
cd playground/apps/mobile-app && npm test
cd playground/apps/web-app && npm test
```

## 📊 Best Practices

### 1. Keep Test Apps Updated
- Regularly sync with latest template changes
- Update dependencies and configurations
- Validate against real-world usage patterns

### 2. Document Experiments
- Add README files for experimental features
- Document learning outcomes and decisions
- Share findings with the team

### 3. Automated Validation
- Run verification scripts before template releases
- Include test apps in CI/CD pipeline
- Monitor for breaking changes

### 4. Isolation
- Keep experimental code separate from production templates
- Use feature flags for risky experiments
- Clean up abandoned experiments regularly

## 🔄 Maintenance

### Regular Tasks
- **Weekly**: Update dependencies in test apps
- **Before Releases**: Run full verification suite
- **After Template Changes**: Validate all test applications
- **Monthly**: Clean up old experiments and unused code

### Monitoring
- Track test app performance metrics
- Monitor build success rates
- Validate cross-platform compatibility
- Check template generation success

---

*This test directory ensures template quality and provides a safe environment for experimentation and validation.*
