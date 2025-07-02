# React Native Navigation Instructions

## React Navigation v6 Setup

### Navigation Container Setup
```tsx
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createDrawerNavigator } from '@react-navigation/drawer';

// Type definitions
export type RootStackParamList = {
  Home: undefined;
  Profile: { userId: string };
  Settings: undefined;
  Auth: undefined;
};

export type TabParamList = {
  HomeTab: undefined;
  ProfileTab: undefined;
  SettingsTab: undefined;
};

// Global navigation types
declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<TabParamList>();
const Drawer = createDrawerNavigator();

const AppNavigator: React.FC = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator 
        initialRouteName="Home"
        screenOptions={{
          headerStyle: {
            backgroundColor: '#6200ea',
          },
          headerTintColor: '#fff',
          headerTitleStyle: {
            fontWeight: 'bold',
          },
        }}
      >
        <Stack.Screen 
          name="Home" 
          component={HomeScreen}
          options={{ title: 'Home Screen' }}
        />
        <Stack.Screen 
          name="Profile" 
          component={ProfileScreen}
          options={({ route }) => ({ 
            title: `Profile ${route.params.userId}` 
          })}
        />
        <Stack.Screen 
          name="Settings" 
          component={SettingsScreen}
          options={{
            presentation: 'modal',
            headerShown: false,
          }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};
```

### Tab Navigator Implementation
```tsx
import { Ionicons } from '@expo/vector-icons';

const TabNavigator: React.FC = () => {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName: keyof typeof Ionicons.glyphMap;

          if (route.name === 'HomeTab') {
            iconName = focused ? 'home' : 'home-outline';
          } else if (route.name === 'ProfileTab') {
            iconName = focused ? 'person' : 'person-outline';
          } else if (route.name === 'SettingsTab') {
            iconName = focused ? 'settings' : 'settings-outline';
          } else {
            iconName = 'help-circle-outline';
          }

          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: '#6200ea',
        tabBarInactiveTintColor: 'gray',
        headerShown: false,
      })}
    >
      <Tab.Screen 
        name="HomeTab" 
        component={HomeScreen}
        options={{ tabBarLabel: 'Home' }}
      />
      <Tab.Screen 
        name="ProfileTab" 
        component={ProfileScreen}
        options={{ tabBarLabel: 'Profile' }}
      />
      <Tab.Screen 
        name="SettingsTab" 
        component={SettingsScreen}
        options={{ tabBarLabel: 'Settings' }}
      />
    </Tab.Navigator>
  );
};
```

### Navigation Hooks Usage
```tsx
import React from 'react';
import { View, Text, Button } from 'react-native';
import { useNavigation, useRoute, RouteProp } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';

type HomeScreenNavigationProp = NativeStackNavigationProp<RootStackParamList, 'Home'>;

const HomeScreen: React.FC = () => {
  const navigation = useNavigation<HomeScreenNavigationProp>();

  const navigateToProfile = () => {
    navigation.navigate('Profile', { userId: '123' });
  };

  const navigateToSettings = () => {
    navigation.navigate('Settings');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Home Screen</Text>
      <Button title="Go to Profile" onPress={navigateToProfile} />
      <Button title="Go to Settings" onPress={navigateToSettings} />
    </View>
  );
};

// Screen with route params
type ProfileScreenRouteProp = RouteProp<RootStackParamList, 'Profile'>;

const ProfileScreen: React.FC = () => {
  const route = useRoute<ProfileScreenRouteProp>();
  const navigation = useNavigation();
  const { userId } = route.params;

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Profile Screen</Text>
      <Text>User ID: {userId}</Text>
      <Button title="Go Back" onPress={() => navigation.goBack()} />
    </View>
  );
};
```

### Deep Linking Configuration
```tsx
import { LinkingOptions } from '@react-navigation/native';
import * as Linking from 'expo-linking';

const prefix = Linking.createURL('/');

const linking: LinkingOptions<RootStackParamList> = {
  prefixes: [prefix, 'myapp://'],
  config: {
    screens: {
      Home: '',
      Profile: 'profile/:userId',
      Settings: 'settings',
      Auth: 'auth',
    },
  },
};

const AppNavigator: React.FC = () => {
  return (
    <NavigationContainer linking={linking}>
      {/* Your navigation structure */}
    </NavigationContainer>
  );
};
```

### Nested Navigation
```tsx
const MainStack = createNativeStackNavigator();
const AuthStack = createNativeStackNavigator();

const AuthNavigator: React.FC = () => {
  return (
    <AuthStack.Navigator screenOptions={{ headerShown: false }}>
      <AuthStack.Screen name="Login" component={LoginScreen} />
      <AuthStack.Screen name="Register" component={RegisterScreen} />
      <AuthStack.Screen name="ForgotPassword" component={ForgotPasswordScreen} />
    </AuthStack.Navigator>
  );
};

const MainNavigator: React.FC = () => {
  return (
    <MainStack.Navigator>
      <MainStack.Screen name="HomeTabs" component={TabNavigator} />
      <MainStack.Screen name="Profile" component={ProfileScreen} />
      <MainStack.Screen name="Settings" component={SettingsScreen} />
    </MainStack.Navigator>
  );
};

const RootNavigator: React.FC = () => {
  const { isAuthenticated } = useAuth();

  return (
    <NavigationContainer>
      {isAuthenticated ? <MainNavigator /> : <AuthNavigator />}
    </NavigationContainer>
  );
};
```

### Conditional Navigation
```tsx
const ConditionalNavigator: React.FC = () => {
  const { isAuthenticated, isLoading } = useAuth();

  if (isLoading) {
    return <SplashScreen />;
  }

  return (
    <Stack.Navigator>
      {isAuthenticated ? (
        // Authenticated stack
        <>
          <Stack.Screen name="Home" component={HomeScreen} />
          <Stack.Screen name="Profile" component={ProfileScreen} />
        </>
      ) : (
        // Authentication stack
        <>
          <Stack.Screen 
            name="Login" 
            component={LoginScreen}
            options={{ headerShown: false }}
          />
          <Stack.Screen 
            name="Register" 
            component={RegisterScreen}
            options={{ headerShown: false }}
          />
        </>
      )}
    </Stack.Navigator>
  );
};
```

### Navigation with State Management
```tsx
import { useAppSelector } from '../hooks/redux';

const NavigationWithRedux: React.FC = () => {
  const { isAuthenticated, user } = useAppSelector(state => state.auth);

  return (
    <NavigationContainer>
      <Stack.Navigator>
        {isAuthenticated && user ? (
          <Stack.Group>
            <Stack.Screen name="Home" component={HomeScreen} />
            <Stack.Screen name="Profile" component={ProfileScreen} />
          </Stack.Group>
        ) : (
          <Stack.Group screenOptions={{ headerShown: false }}>
            <Stack.Screen name="Login" component={LoginScreen} />
            <Stack.Screen name="Register" component={RegisterScreen} />
          </Stack.Group>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
};
```

### Custom Header Components
```tsx
const CustomHeader: React.FC<{ title: string }> = ({ title }) => {
  const navigation = useNavigation();

  return (
    <View style={styles.header}>
      <TouchableOpacity onPress={() => navigation.goBack()}>
        <Ionicons name="arrow-back" size={24} color="#fff" />
      </TouchableOpacity>
      <Text style={styles.headerTitle}>{title}</Text>
      <TouchableOpacity onPress={() => navigation.navigate('Settings')}>
        <Ionicons name="settings" size={24} color="#fff" />
      </TouchableOpacity>
    </View>
  );
};

// Usage in screen options
<Stack.Screen 
  name="Profile" 
  component={ProfileScreen}
  options={{
    header: ({ route }) => (
      <CustomHeader title={`Profile ${route.params?.userId}`} />
    ),
  }}
/>
```

### Navigation with Expo Router (Alternative)
```tsx
// app/_layout.tsx
import { Stack } from 'expo-router';

export default function RootLayout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Home' }} />
      <Stack.Screen name="profile/[id]" options={{ title: 'Profile' }} />
      <Stack.Screen name="settings" options={{ presentation: 'modal' }} />
    </Stack>
  );
}

// app/profile/[id].tsx
import { useLocalSearchParams } from 'expo-router';

export default function ProfileScreen() {
  const { id } = useLocalSearchParams();

  return (
    <View>
      <Text>Profile ID: {id}</Text>
    </View>
  );
}
```
