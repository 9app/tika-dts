# React Native State Management Instructions

## React Query (TanStack Query) Implementation

### Provider Setup
```tsx
import React from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { focusManager, onlineManager } from '@tanstack/react-query';
import { AppState, Platform } from 'react-native';
import NetInfo from '@react-native-community/netinfo';

// Configure focus and online managers for React Native
function onAppStateChange(status: string) {
  if (Platform.OS !== 'web') {
    focusManager.setFocused(status === 'active');
  }
}

AppState.addEventListener('change', onAppStateChange);

// Set up network state managemen
onlineManager.setEventListener((setOnline) => {
  return NetInfo.addEventListener((state) => {
    setOnline(!!state.isConnected);
  });
});

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      gcTime: 1000 * 60 * 10, // 10 minutes (formerly cacheTime)
      retry: (failureCount, error: any) => {
        // Don't retry on 4xx errors (client errors)
        if (error?.status >= 400 && error?.status < 500) {
          return false;
        }
        // Don't retry more than 3 times
        return failureCount < 3;
      },
      retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
      refetchOnWindowFocus: false,
      refetchOnMount: true,
      refetchOnReconnect: 'always',
      // Network mode for better offline handling
      networkMode: 'online',
    },
    mutations: {
      retry: 1,
      networkMode: 'online',
      onError: (error) => {
        console.error('Mutation error:', error);
        // You can add global error handling here
      },
    },
  },
});

export const QueryProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      {__DEV__ && <ReactQueryDevtools initialIsOpen={false} />}
    </QueryClientProvider>
  );
};
```

### Query Key Factory Pattern
```tsx
// queries/keys.ts
export const queryKeys = {
  all: ['app'] as const,
  users: () => [...queryKeys.all, 'users'] as const,
  user: (id: string) => [...queryKeys.users(), id] as const,
  userProfile: (id: string) => [...queryKeys.user(id), 'profile'] as const,
  userPosts: (id: string, filters?: PostFilters) =>
    [...queryKeys.user(id), 'posts', filters] as const,
  posts: () => [...queryKeys.all, 'posts'] as const,
  post: (id: string) => [...queryKeys.posts(), id] as const,
  infinite: {
    posts: (filters?: PostFilters) =>
      [...queryKeys.posts(), 'infinite', filters] as const,
  },
} as const;
```

### Service Layer with Error Handling
```tsx
// services/api.ts
import axios, { AxiosResponse } from 'axios';

export interface ApiError {
  message: string;
  status: number;
  code?: string;
}

class ApiClient {
  private client = axios.create({
    baseURL: process.env.EXPO_PUBLIC_API_URL || 'https://api.example.com',
    timeout: 10000,
  });

  constructor() {
    this.setupInterceptors();
  }

  private setupInterceptors() {
    this.client.interceptors.request.use(
      (config) => {
        // Add auth token if available
        const token = this.getAuthToken();
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    this.client.interceptors.response.use(
      (response) => response,
      (error) => {
        const apiError: ApiError = {
          message: error.response?.data?.message || error.message || 'Network error',
          status: error.response?.status || 0,
          code: error.response?.data?.code,
        };
        return Promise.reject(apiError);
      }
    );
  }

  private getAuthToken(): string | null {
    // Implement token retrieval logic
    return null;
  }

  async get<T>(url: string): Promise<T> {
    const response: AxiosResponse<T> = await this.client.get(url);
    return response.data;
  }

  async post<T>(url: string, data?: any): Promise<T> {
    const response: AxiosResponse<T> = await this.client.post(url, data);
    return response.data;
  }

  async put<T>(url: string, data?: any): Promise<T> {
    const response: AxiosResponse<T> = await this.client.put(url, data);
    return response.data;
  }

  async delete<T>(url: string): Promise<T> {
    const response: AxiosResponse<T> = await this.client.delete(url);
    return response.data;
  }
}

export const apiClient = new ApiClient();
```

### Query Hooks with Best Practices
```tsx
// hooks/queries/useUsers.ts
import { useQuery, useQueryClient, UseQueryOptions } from '@tanstack/react-query';
import { useCallback } from 'react';
import { queryKeys } from '../keys';
import { userService } from '../../services/userService';
import type { User, UserFilters } from '../../types/user';

export const useUser = (
  userId: string,
  options?: Omit<UseQueryOptions<User, ApiError>, 'queryKey' | 'queryFn'>
) => {
  return useQuery({
    queryKey: queryKeys.user(userId),
    queryFn: () => userService.getUser(userId),
    enabled: !!userId,
    // Prevent unnecessary re-renders
    select: useCallback((user: User) => user, []),
    ...options,
  });
};

export const useUsers = (
  filters?: UserFilters,
  options?: Omit<UseQueryOptions<User[], ApiError>, 'queryKey' | 'queryFn'>
) => {
  return useQuery({
    queryKey: queryKeys.users(),
    queryFn: () => userService.getUsers(filters),
    // Keep previous data while fetching new data
    placeholderData: (previousData) => previousData,
    // Transform data if needed
    select: useCallback((users: User[]) => {
      return users.filter(user => user.isActive);
    }, []),
    ...options,
  });
};

// Suspense-enabled query hook
export const useSuspenseUser = (userId: string) => {
  return useSuspenseQuery({
    queryKey: queryKeys.user(userId),
    queryFn: () => userService.getUser(userId),
  });
};

// Prefetch query for performance optimization
export const usePrefetchUser = () => {
  const queryClient = useQueryClient();

  return useCallback(
    (userId: string) => {
      queryClient.prefetchQuery({
        queryKey: queryKeys.user(userId),
        queryFn: () => userService.getUser(userId),
        staleTime: 5 * 60 * 1000,
      });
    },
    [queryClient]
  );
};

// Status-based hooks for better UX
export const useUserStatus = (userId: string) => {
  const query = useUser(userId);

  return {
    ...query,
    isEmpty: !query.data,
    isStale: query.isStale,
    isFetching: query.isFetching,
    isRefetching: query.isRefetching,
  };
};
```

### Mutation Hooks with Advanced Patterns
```tsx
// hooks/mutations/useUserMutations.ts
import { useMutation, useQueryClient, MutationOptions } from '@tanstack/react-query';
import { queryKeys } from '../keys';
import { userService } from '../../services/userService';
import type { User, CreateUserRequest, UpdateUserRequest } from '../../types/user';

export const useCreateUser = (
  options?: Omit<MutationOptions<User, ApiError, CreateUserRequest>, 'mutationFn'>
) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (userData: CreateUserRequest) => userService.createUser(userData),
    // Optimistic updates with proper rollback
    onMutate: async (newUser) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: queryKeys.users() });

      // Snapshot previous value
      const previousUsers = queryClient.getQueryData<User[]>(queryKeys.users());

      // Optimistically update cache
      queryClient.setQueryData<User[]>(queryKeys.users(), (old) => {
        const optimisticUser: User = {
          id: `temp-${Date.now()}`,
          ...newUser,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
          isActive: true,
        };
        return old ? [optimisticUser, ...old] : [optimisticUser];
      });

      return { previousUsers };
    },
    onError: (error, variables, context) => {
      // Rollback on error
      if (context?.previousUsers) {
        queryClient.setQueryData(queryKeys.users(), context.previousUsers);
      }
    },
    onSuccess: (newUser, variables, context) => {
      // Replace temp user with real user
      queryClient.setQueryData<User[]>(queryKeys.users(), (old) => {
        return old?.map(user =>
          user.id.startsWith('temp-') ? newUser : user
        );
      });

      // Set individual user cache
      queryClient.setQueryData(queryKeys.user(newUser.id), newUser);
    },
    onSettled: (data, error, variables, context) => {
      // Always refetch to ensure consistency
      queryClient.invalidateQueries({
        queryKey: queryKeys.users(),
        refetchType: 'active'
      });
    },
    ...options,
  });
};

export const useUpdateUser = (
  options?: Omit<MutationOptions<User, ApiError, { id: string; data: UpdateUserRequest }>, 'mutationFn'>
) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: UpdateUserRequest }) =>
      userService.updateUser(id, data),
    onMutate: async ({ id, data }) => {
      await queryClient.cancelQueries({ queryKey: queryKeys.user(id) });

      const previousUser = queryClient.getQueryData<User>(queryKeys.user(id));

      // Optimistic update with validation
      queryClient.setQueryData<User>(queryKeys.user(id), (old) => {
        if (!old) return old;
        return {
          ...old,
          ...data,
          updatedAt: new Date().toISOString()
        };
      });

      return { previousUser, id };
    },
    onError: (error, { id }, context) => {
      if (context?.previousUser) {
        queryClient.setQueryData(queryKeys.user(id), context.previousUser);
      }
    },
    onSuccess: (updatedUser, { id }) => {
      // Update both individual and list caches
      queryClient.setQueryData(queryKeys.user(id), updatedUser);

      queryClient.setQueryData<User[]>(queryKeys.users(), (old) => {
        return old?.map(user => user.id === id ? updatedUser : user);
      });
    },
    ...options,
  });
};

export const useDeleteUser = (
  options?: Omit<MutationOptions<void, ApiError, string>, 'mutationFn'>
) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (userId: string) => userService.deleteUser(userId),
    onMutate: async (userId) => {
      await queryClient.cancelQueries({ queryKey: queryKeys.user(userId) });
      await queryClient.cancelQueries({ queryKey: queryKeys.users() });

      const previousUser = queryClient.getQueryData<User>(queryKeys.user(userId));
      const previousUsers = queryClient.getQueryData<User[]>(queryKeys.users());

      // Optimistically remove user
      queryClient.setQueryData<User[]>(queryKeys.users(), (old) => {
        return old?.filter(user => user.id !== userId);
      });

      return { previousUser, previousUsers, userId };
    },
    onError: (error, userId, context) => {
      // Rollback changes
      if (context?.previousUser) {
        queryClient.setQueryData(queryKeys.user(userId), context.previousUser);
      }
      if (context?.previousUsers) {
        queryClient.setQueryData(queryKeys.users(), context.previousUsers);
      }
    },
    onSuccess: (_, userId) => {
      // Remove from cache permanently
      queryClient.removeQueries({ queryKey: queryKeys.user(userId) });

      // Invalidate related queries
      queryClient.invalidateQueries({
        queryKey: queryKeys.users(),
        refetchType: 'active'
      });
    },
    ...options,
  });
};

// Batch mutations for multiple operations
export const useBatchUpdateUsers = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (updates: Array<{ id: string; data: Partial<User> }>) => {
      const results = await Promise.allSettled(
        updates.map(({ id, data }) => userService.updateUser(id, data))
      );

      return results.map((result, index) => ({
        id: updates[index].id,
        result: result.status === 'fulfilled' ? result.value : null,
        error: result.status === 'rejected' ? result.reason : null,
      }));
    },
    onSuccess: (results) => {
      // Update successful operations
      results.forEach(({ id, result }) => {
        if (result) {
          queryClient.setQueryData(queryKeys.user(id), result);
        }
      });

      // Invalidate users lis
      queryClient.invalidateQueries({ queryKey: queryKeys.users() });
    },
  });
};
```

### Advanced Query Patterns
```tsx
// hooks/queries/useAdvancedPatterns.ts
import { useQueries, useInfiniteQuery, useSuspenseQuery } from '@tanstack/react-query';
import { queryKeys } from '../keys';
import { userService, postService } from '../../services';

// Parallel queries with useQueries
export const useUserWithPosts = (userId: string) => {
  return useQueries({
    queries: [
      {
        queryKey: queryKeys.user(userId),
        queryFn: () => userService.getUser(userId),
        enabled: !!userId,
      },
      {
        queryKey: queryKeys.userPosts(userId),
        queryFn: () => postService.getUserPosts(userId),
        enabled: !!userId,
      },
    ],
    combine: (results) => {
      return {
        data: {
          user: results[0].data,
          posts: results[1].data,
        },
        isPending: results.some(result => result.isPending),
        isError: results.some(result => result.isError),
        error: results.find(result => result.error)?.error,
      };
    },
  });
};

// Dependent queries
export const useUserProfile = (userId: string) => {
  const userQuery = useUser(userId);

  const profileQuery = useQuery({
    queryKey: queryKeys.userProfile(userId),
    queryFn: () => userService.getUserProfile(userId),
    enabled: !!userQuery.data?.id && userQuery.data.hasProfile,
    // Dependency on user query
    staleTime: 10 * 60 * 1000, // 10 minutes
  });

  return {
    user: userQuery.data,
    profile: profileQuery.data,
    isLoading: userQuery.isLoading || profileQuery.isLoading,
    error: userQuery.error || profileQuery.error,
  };
};

// Infinite query with cursor-based pagination
export const useInfiniteUsers = (filters?: UserFilters) => {
  return useInfiniteQuery({
    queryKey: queryKeys.infinite.users(filters),
    queryFn: ({ pageParam }) =>
      userService.getUsers({ ...filters, cursor: pageParam }),
    initialPageParam: null as string | null,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
    getPreviousPageParam: (firstPage) => firstPage.prevCursor ?? undefined,
    // Performance optimizations
    maxPages: 5, // Limit memory usage
    staleTime: 2 * 60 * 1000, // 2 minutes
    select: (data) => ({
      pages: data.pages,
      pageParams: data.pageParams,
      // Flatten all users for easier consumption
      allUsers: data.pages.flatMap(page => page.users),
    }),
  });
};

// Suspense-enabled query for React 18+
export const useSuspenseUserData = (userId: string) => {
  const userData = useSuspenseQuery({
    queryKey: queryKeys.user(userId),
    queryFn: () => userService.getUser(userId),
  });

  const userPosts = useSuspenseQuery({
    queryKey: queryKeys.userPosts(userId),
    queryFn: () => postService.getUserPosts(userId),
  });

  return {
    user: userData.data,
    posts: userPosts.data,
  };
};

// Query with polling/real-time updates
export const useRealtimeUser = (userId: string) => {
  return useQuery({
    queryKey: queryKeys.user(userId),
    queryFn: () => userService.getUser(userId),
    enabled: !!userId,
    // Poll every 30 seconds when tab is focused
    refetchInterval: (data, query) => {
      if (query.state.error) return false;
      return 30 * 1000;
    },
    refetchIntervalInBackground: false,
  });
};
```

### Performance Optimization Patterns
```tsx
// hooks/optimizations/useQueryOptimizations.ts
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useMemo, useCallback } from 'react';

// Selective data subscription to prevent unnecessary re-renders
export const useUserName = (userId: string) => {
  return useQuery({
    queryKey: queryKeys.user(userId),
    queryFn: () => userService.getUser(userId),
    select: useCallback((user: User) => user.name, []),
    enabled: !!userId,
  });
};

// Background prefetching strategy
export const useSmartPrefetch = () => {
  const queryClient = useQueryClient();

  const prefetchUserOnHover = useCallback(
    (userId: string) => {
      queryClient.prefetchQuery({
        queryKey: queryKeys.user(userId),
        queryFn: () => userService.getUser(userId),
        staleTime: 5 * 60 * 1000,
      });
    },
    [queryClient]
  );

  const prefetchNextPage = useCallback(
    (currentPage: number, filters?: UserFilters) => {
      queryClient.prefetchQuery({
        queryKey: queryKeys.users(filters, currentPage + 1),
        queryFn: () => userService.getUsers({ ...filters, page: currentPage + 1 }),
        staleTime: 2 * 60 * 1000,
      });
    },
    [queryClient]
  );

  return { prefetchUserOnHover, prefetchNextPage };
};

// Memory optimization for large datasets
export const useOptimizedUserList = (filters?: UserFilters) => {
  return useQuery({
    queryKey: queryKeys.users(filters),
    queryFn: () => userService.getUsers(filters),
    select: useMemo(() =>
      (users: User[]) => users.map(user => ({
        id: user.id,
        name: user.name,
        email: user.email,
        // Only select necessary fields to reduce memory usage
      })),
    []),
    // Enable structural sharing for better performance
    structuralSharing: true,
  });
};
```

## Best Practices Summary

### 1. Query Key Managemen
- Use factory pattern for consistent query keys
- Include all dependencies in query keys (filters, pagination, etc.)
- Use hierarchical key structure for easy invalidation
- Consider key normalization for complex relationships

### 2. Error Handling & User Experience
- Implement proper error types and error boundaries
- Provide retry mechanisms with exponential backoff
- Show meaningful error messages with recovery options
- Use optimistic updates for better perceived performance
- Handle offline scenarios gracefully

### 3. Performance Optimization
- Use `select` to prevent unnecessary re-renders
- Implement proper caching strategies with appropriate stale times
- Prefetch data strategically (on hover, route changes)
- Use structural sharing for large datasets
- Limit infinite query pages to prevent memory issues
- Consider data normalization for complex state

### 4. State Separation & Architecture
- React Query for server state (API data)
- Zustand for client UI state (theme, preferences)
- Local component state for UI-specific state
- Context API for dependency injection, not state

### 5. Network & Offline Handling
- Configure focus and online managers for React Native
- Use network-aware query behavior
- Implement proper retry strategies
- Handle background/foreground app state changes

### 6. Testing & Debugging
- Mock React Query hooks in tests
- Test optimistic updates and error scenarios
- Use React Query DevTools for debugging
- Test offline/online transitions
- Verify cache invalidation patterns

### 7. Advanced Patterns
- Use `useQueries` for parallel data fetching
- Implement dependent queries correctly
- Leverage Suspense for better loading states
- Use mutation composition for complex operations
- Implement real-time data with polling or WebSockets

### 8. Code Organization
- Group related queries and mutations
- Create custom hooks for business logic
- Use TypeScript for better developer experience
- Implement consistent error handling patterns
- Document query dependencies and side effects

### 9. Memory Managemen
- Use `gcTime` (formerly `cacheTime`) appropriately
- Implement query cleanup for unused data
- Use `removeQueries` for manual cleanup
- Monitor bundle size and memory usage

### 10. Security Considerations
- Validate and sanitize query parameters
- Implement proper authentication headers
- Handle sensitive data in cache appropriately
- Use HTTPS for all API calls
- Implement proper CORS handling
