# Packages

This directory contains shared packages and libraries used across applications.

## Structure

```
packages/
├── shared-ui/           # Shared UI components
├── shared-utils/        # Utility functions and helpers
├── shared-types/        # TypeScript type definitions
├── shared-config/       # Shared configurations
├── shared-api/          # API clients and schemas
└── ...                  # Other shared packages
```

## Package Types

### Frontend Packages
- **shared-ui**: Reusable UI components for React/React Native
- **shared-types**: TypeScript interfaces and types
- **shared-utils**: Common utility functions
- **shared-config**: Configuration files and constants

### Backend Packages
- **shared-api**: API clients, schemas, and types
- **shared-auth**: Authentication utilities
- **shared-db**: Database models and utilities

## Developmen

Each package should have:
- `package.json` with proper dependencies
- `tsconfig.json` for TypeScript configuration
- Export configuration in `index.ts`
- README.md with usage examples

## Usage

Import packages in your apps:
```typescrip
// In your app
import { Button } from '@tika/shared-ui';
import { formatDate } from '@tika/shared-utils';
import { User } from '@tika/shared-types';
```
