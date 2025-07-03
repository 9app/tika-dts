# React Native & Expo Development Instructions

## Overview
This document provides specific instructions for GitHub Copilot when working on React Native and Expo projects.

## Core Development Principles

### Architecture
- Use feature-based folder structure
- Implement clean architecture with clear separation of concerns
- Use dependency injection for better testability
- Follow SOLID principles

### Code Organization
```
src/
├── components/
│   ├── common/
│   └── screens/
├── features/
│   └── feature_name/
│       ├── components/
│       ├── hooks/
│       ├── queries/
│       ├── services/
│       └── types/
├── navigation/
├── services/
├── stores/
├── queries/
├── utils/
└── types/
```

### Component Development
- Use functional components with hooks
- Implement proper TypeScript typing
- Extract reusable logic into custom hooks
- Use React.memo for performance optimization
- Handle all component states (loading, error, success)

### State Management
- Use React Query for server state management and data fetching
- Use Zustand for client-side global state
- Use local component state for UI-specific state
- Implement proper caching and background refetching strategies

### Navigation
- Use React Navigation v6 with TypeScript
- Implement proper navigation typing
- Handle deep linking appropriately
- Use proper navigation patterns

## Specific Instructions for Copilot

### When generating components:
```tsx
interface Props {
  title: string;
  onPress?: () => void;
}

const MyComponent: React.FC<Props> = ({ title, onPress }) => {
  return (
    <TouchableOpacity onPress={onPress}>
      <Text>{title}</Text>
    </TouchableOpacity>
  );
};

export default React.memo(MyComponent);
```

### When generating hooks:
```tsx
// Custom hook combining React Query with component logic
const useUserProfile = (userId: string) => {
  const { data: user, isLoading, error, refetch } = useUser(userId);
  const updateUserMutation = useUpdateUser();

  const updateProfile = useCallback(
    (userData: Partial<User>) => {
      updateUserMutation.mutate({ id: userId, userData });
    },
    [userId, updateUserMutation]
  );

  const isUpdating = updateUserMutation.isLoading;

  return {
    user,
    isLoading,
    error: error?.message || updateUserMutation.error?.message,
    updateProfile,
    isUpdating,
    refetch,
  };
};

// Custom hook for local state management
const useToggle = (initialValue = false) => {
  const [value, setValue] = useState(initialValue);

  const toggle = useCallback(() => setValue(v => !v), []);
  const setTrue = useCallback(() => setValue(true), []);
  const setFalse = useCallback(() => setValue(false), []);

  return { value, toggle, setTrue, setFalse, setValue };
};
```

### When generating services:
```tsx
class UserService {
  private apiClient: ApiClient;

  constructor(apiClient: ApiClient) {
    this.apiClient = apiClient;
  }

  async getUser(id: string): Promise<User> {
    try {
      const response = await this.apiClient.get<User>(`/users/${id}`);
      return response.data;
    } catch (error) {
      throw new Error(`Failed to fetch user: ${error}`);
    }
  }

  async updateUser(id: string, userData: Partial<User>): Promise<User> {
    try {
      const response = await this.apiClient.put<User>(`/users/${id}`, userData);
      return response.data;
    } catch (error) {
      throw new Error(`Failed to update user: ${error}`);
    }
  }
}
```

### When generating React Query hooks:
```tsx
// Query hooks for data fetching
const useUser = (userId: string, options?: UseQueryOptions<User>) => {
  return useQuery({
    queryKey: ['user', userId],
    queryFn: () => userService.getUser(userId),
    enabled: !!userId,
    ...options,
  });
};

const useUsers = (filters?: UserFilters) => {
  return useQuery({
    queryKey: ['users', filters],
    queryFn: () => userService.getUsers(filters),
    keepPreviousData: true,
  });
};

// Mutation hooks for data modification
const useCreateUser = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (userData: CreateUserRequest) => userService.createUser(userData),
    onSuccess: (newUser) => {
      // Invalidate users list to refetch
      queryClient.invalidateQueries({ queryKey: ['users'] });
      // Optimistically update cache
      queryClient.setQueryData(['user', newUser.id], newUser);
    },
  });
};

const useUpdateUser = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, userData }: { id: string; userData: Partial<User> }) =>
      userService.updateUser(id, userData),
    onSuccess: (updatedUser, { id }) => {
      queryClient.setQueryData(['user', id], updatedUser);
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
};
```

### When setting up React Query provider:
```tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
      retry: (failureCount, error) => {
        // Don't retry on 4xx errors
        if (error instanceof Error && error.message.includes('4')) {
          return false;
        }
        return failureCount < 3;
      },
    },
    mutations: {
      retry: 1,
    },
  },
});

export const App: React.FC = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <AppNavigator />
    </QueryClientProvider>
  );
};
```

### When generating navigation:
```tsx
export type RootStackParamList = {
  Home: undefined;
  Profile: { userId: string };
  Settings: undefined;
};

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}

const Stack = createNativeStackNavigator<RootStackParamList>();

const AppNavigator: React.FC = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="Profile" component={ProfileScreen} />
        <Stack.Screen name="Settings" component={SettingsScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};
```

### When generating tests:
```tsx
describe('UserComponent', () => {
  it('should render user name correctly', () => {
    const mockUser = { id: '1', name: 'John Doe', email: 'john@example.com' };

    render(<UserComponent user={mockUser} />);

    expect(screen.getByText('John Doe')).toBeTruthy();
  });

  it('should call onPress when pressed', () => {
    const mockOnPress = jest.fn();
    const mockUser = { id: '1', name: 'John Doe', email: 'john@example.com' };

    render(<UserComponent user={mockUser} onPress={mockOnPress} />);

    fireEvent.press(screen.getByText('John Doe'));

    expect(mockOnPress).toHaveBeenCalledWith(mockUser);
  });
});
```

## Dependencies to Prefer
- `@tanstack/react-query` for server state management and data fetching
- `zustand` for client-side global state
- `react-navigation` for navigation
- `axios` for HTTP requests
- `react-hook-form` for form handling
- `zod` for schema validation
- `react-native-reanimated` for animations
- `expo-router` for file-based routing (Expo projects)
- `@expo/vector-icons` for icons

## Platform-Specific Considerations
- Use `Platform.OS` for platform detection
- Create `.ios.tsx` and `.android.tsx` files for platform-specific components
- Handle safe areas properly with `react-native-safe-area-context`
- Use appropriate platform design patterns

## Performance Best Practices
- Use `FlatList` for large lists
- Implement `getItemLayout` when possible
- Use `React.memo` for expensive components
- Implement proper key props for list items
- Use `useMemo` and `useCallback` appropriately

## Security Guidelines
- Use `@react-native-async-storage/async-storage` for non-sensitive data
- Use `expo-secure-store` or `react-native-keychain` for sensitive data
- Validate all user inputs
- Implement proper authentication flows
- Use HTTPS for all API calls
