# React Native & Expo Development Instructions Index

This directory contains comprehensive instructions for GitHub Copilot when working on React Native and Expo projects. Each file provides specific guidance for different aspects of development.

## 📋 Instructions Overview

### 🚀 [React Native Development](./react-native-development.instructions.md)
**Core development patterns and best practices**

- **Architecture**: Feature-based folder structure, clean architecture, SOLID principles
- **Component Development**: Functional components, hooks, TypeScript patterns
- **State Management**: React Query for server state, Zustand for client state
- **Navigation**: React Navigation v6 with TypeScript
- **Dependencies**: Preferred libraries and tools
- **Platform Considerations**: iOS/Android specific patterns
- **Performance**: Optimization strategies
- **Security**: Best practices for secure development

**Key Sections:**
- Component patterns with TypeScript
- Custom hook implementations
- Service layer architecture
- React Query integration
- Testing patterns
- Performance optimization

---

### 🗂️ [State Management](./state-management.instructions.md)
**Advanced React Query (TanStack Query) patterns and state management**

- **React Query Implementation**: Provider setup, configuration
- **Query Patterns**: Basic queries, infinite queries, parallel queries
- **Mutation Patterns**: Optimistic updates, batch operations
- **Advanced Patterns**: Dependent queries, suspense, real-time updates
- **Performance Optimization**: Caching, prefetching, memory management
- **Error Handling**: Retry strategies, error boundaries
- **Best Practices**: Network handling, testing, debugging

**Key Sections:**
- Provider setup with React Native optimizations
- Query key factory patterns
- Advanced mutation hooks with rollback
- Performance optimization techniques
- Offline/online handling
- Memory management strategies

---

### 🧭 [Navigation](./navigation.instructions.md)
**React Navigation v6 patterns and routing strategies**

- **Navigation Setup**: Stack, Tab, Drawer navigators
- **TypeScript Integration**: Proper type safety for routes
- **Deep Linking**: URL handling and navigation
- **Authentication Flow**: Protected routes and auth navigation
- **Performance**: Navigation optimization strategies

**Key Sections:**
- Navigation structure setup
- TypeScript route typing
- Authentication navigation flows
- Deep linking configuration
- Performance best practices

---

### ⚠️ [AI Terminal Safety](../../../.github/instructions/ai-in-terminal.instructions.md)
**Critical safety guidelines for AI assistants when using terminal commands**

- **Safe Command Patterns**: Incremental commands, proper shell syntax
- **Dangerous Patterns**: Complex regex, shell escaping, chained operations
- **Tool Priority**: VS Code integrated tools over terminal when possible
- **Error Prevention**: Testing commands, avoiding hangs, proper escaping

**Key Sections:**
- Terminal command best practices
- Common pitfalls and how to avoid them
- Safe alternatives to complex operations
- VS Code tool integration

---

## 🎯 Usage Guidelines

### For GitHub Copilot:
1. **Primary Reference**: Start with `react-native-development.instructions.md` for general patterns
2. **Specific Domains**: Refer to specialized files for detailed implementations
3. **State Management**: Always use `state-management.instructions.md` for React Query patterns
4. **Navigation**: Follow `navigation.instructions.md` for routing implementations

### For Developers:
1. **Project Setup**: Follow the main development instructions first
2. **Feature Development**: Reference specific instruction files as needed
3. **Code Reviews**: Use instructions as quality guidelines
4. **Architecture Decisions**: Align with patterns described in instructions

## 🏗️ Architecture Overview

```
React Native App Architecture
├── src/
│   ├── components/          # Reusable UI components
│   │   ├── common/         # Shared components
│   │   └── screens/        # Screen-specific components
│   ├── features/           # Feature-based modules
│   │   └── feature_name/
│   │       ├── components/ # Feature components
│   │       ├── hooks/      # Feature hooks
│   │       ├── queries/    # React Query hooks
│   │       ├── services/   # API services
│   │       └── types/      # TypeScript types
│   ├── navigation/         # Navigation configuration
│   ├── services/           # Shared services
│   ├── stores/            # Zustand stores (client state)
│   ├── queries/           # Global React Query hooks
│   ├── utils/             # Utility functions
│   └── types/             # Global TypeScript types
```

## 🔧 Technology Stack

### Core Technologies:
- **React Native**: Mobile app framework
- **Expo**: Development platform and tools
- **TypeScript**: Type safety and developer experience
- **React Query**: Server state management
- **Zustand**: Client state management
- **React Navigation**: Navigation library
- **Biome**: Code formatting and linting

### Development Tools:
- **VS Code**: Primary IDE with extensions
- **Flipper**: Debugging and development
- **React Query DevTools**: Query debugging
- **TypeScript**: Static type checking
- **ESLint/Biome**: Code quality

## 📚 Quick Reference

### Common Patterns:
- **Components**: Functional components with TypeScript
- **Hooks**: Custom hooks for business logic
- **Queries**: React Query for API data
- **State**: Zustand for UI state
- **Navigation**: Typed navigation patterns
- **Testing**: Jest and React Native Testing Library

### Code Quality:
- TypeScript strict mode
- Biome formatting and linting
- Component testing
- Hook testing
- E2E testing with Detox

---

*This index is maintained to ensure consistent development patterns across React Native and Expo projects. Update instructions as new patterns and best practices emerge.*
