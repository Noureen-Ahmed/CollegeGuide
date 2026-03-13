/// App Session Provider - Clean state management without freezed
/// Handles authentication state for both students and professors
library;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../core/api_config.dart';
import '../services/data_service.dart';

// ============ STATE CLASSES ============

/// Authentication session state
abstract class AppSessionState {
  const AppSessionState();
}

class AppSessionInitial extends AppSessionState {
  const AppSessionInitial();
}

class AppSessionLoading extends AppSessionState {
  const AppSessionLoading();
}

class AppSessionAuthenticated extends AppSessionState {
  final User user;
  const AppSessionAuthenticated(this.user);
}

class AppSessionUnauthenticated extends AppSessionState {
  const AppSessionUnauthenticated();
}

class AppSessionError extends AppSessionState {
  final String message;
  const AppSessionError(this.message);
}

/// Auth state (for route guards)
abstract class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthOnboardingRequired extends AuthState {
  final User user;
  const AuthOnboardingRequired(this.user);
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

// ============ PROVIDERS ============

final appSessionControllerProvider = StateNotifierProvider<AppSessionController, AppSessionState>((ref) {
  return AppSessionController();
});

final authStateProvider = Provider<AuthState>((ref) {
  final sessionState = ref.watch(appSessionControllerProvider);
  
  if (sessionState is AppSessionAuthenticated) {
    final user = sessionState.user;
    if (user.isOnboardingComplete) {
      return AuthAuthenticated(user);
    } else {
      return AuthOnboardingRequired(user);
    }
  }
  
  return const AuthUnauthenticated();
});

final currentUserProvider = Provider<AsyncValue<User?>>((ref) {
  final state = ref.watch(appSessionControllerProvider);
  
  if (state is AppSessionAuthenticated) {
    return AsyncValue.data(state.user);
  } else if (state is AppSessionLoading) {
    return const AsyncValue.loading();
  } else if (state is AppSessionError) {
    return AsyncValue.error(state.message, StackTrace.current);
  }
  
  return const AsyncValue.data(null);
});

// ============ CONTROLLER ============

class AppSessionController extends StateNotifier<AppSessionState> {
  static const String _userKey = 'saved_user';
  static const String _tokenKey = 'auth_token';
  
  AppSessionController() : super(const AppSessionInitial()) {
    _initializeSession();
  }

  /// Initialize session from saved state
  Future<void> _initializeSession() async {
    state = const AppSessionLoading();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserJson = prefs.getString(_userKey);
      final savedToken = prefs.getString(_tokenKey);
      
      if (savedToken != null) {
        ApiConfig.setAuthToken(savedToken);
      }
      
      if (savedUserJson != null) {
        final userMap = jsonDecode(savedUserJson);
        final user = User.fromJson(userMap);
        state = AppSessionAuthenticated(user);
      } else {
        state = const AppSessionUnauthenticated();
      }
    } catch (e) {
      print('[AppSession] Init error: $e');
      state = const AppSessionUnauthenticated();
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password, {bool rememberMe = true}) async {
    state = const AppSessionLoading();
    
    try {
      final user = await DataService.login(email, password);
      
      if (user != null) {
        if (rememberMe) {
          await _saveSession(user);
        }
        state = AppSessionAuthenticated(user);
        return true;
      } else {
        state = const AppSessionError('Invalid email or password');
        return false;
      }
    } catch (e) {
      print('[AppSession] Login error: $e');
      state = AppSessionError(e.toString());
      return false;
    }
  }

  /// Register new user
  Future<bool> register(String name, String email, String password) async {
    state = const AppSessionLoading();
    
    try {
      final user = await DataService.register(
        name: name,
        email: email,
        password: password,
      );
      
      if (user != null) {
        await _saveSession(user);
        state = AppSessionAuthenticated(user);
        return true;
      } else {
        state = const AppSessionError('Registration failed');
        return false;
      }
    } catch (e) {
      print('[AppSession] Register error: $e');
      state = AppSessionError(e.toString());
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
      ApiConfig.clearAuth();
    } catch (e) {
      print('[AppSession] Logout error: $e');
    }
    
    state = const AppSessionUnauthenticated();
  }

  /// Update current user
  Future<bool> updateUser(User user) async {
    try {
      // Optimistic update
      state = AppSessionAuthenticated(user);
      await _saveSession(user);
      
      final updatedUser = await DataService.updateUser(user);
      if (updatedUser != null) {
         // The backend standard profile update might omit UMS-specific fields
         // (like faculty, nameAr, semester, etc.) since they aren't explicitly 
         // stored in the native DB schema (except as relations or not at all).
         // So, we merge any missing fields from the optimistic user copy.
         final mergedUser = updatedUser.copyWith(
           faculty: updatedUser.faculty ?? user.faculty,
           nameAr: updatedUser.nameAr ?? user.nameAr,
           phone: updatedUser.phone ?? user.phone,
           semester: updatedUser.semester ?? user.semester,
           academicYear: updatedUser.academicYear ?? user.academicYear,
           advisorName: updatedUser.advisorName ?? user.advisorName,
           advisorEmail: updatedUser.advisorEmail ?? user.advisorEmail,
         );

         // Update with merged response
         state = AppSessionAuthenticated(mergedUser);
         await _saveSession(mergedUser);
         return true;
      }
      return false;
    } catch (e) {
      print('[AppSession] Update user error: $e');
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (state is! AppSessionAuthenticated) return false;
    final user = (state as AppSessionAuthenticated).user;
    
    try {
      final success = await DataService.changePassword(user.email, currentPassword, newPassword);
      return success;
    } catch (e) {
      print('[AppSession] Change password error: $e');
      return false;
    }
  }

  /// Complete onboarding
  Future<void> completeOnboarding(List<String> selectedCourses) async {
    if (state is AppSessionAuthenticated) {
      final currentUser = (state as AppSessionAuthenticated).user;
      final updatedUser = currentUser.copyWith(
        isOnboardingComplete: true,
        enrolledCourses: selectedCourses,
      );
      await updateUser(updatedUser);
    }
  }

  /// Save session to storage
  Future<void> _saveSession(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      
      if (ApiConfig.authToken != null) {
        await prefs.setString(_tokenKey, ApiConfig.authToken!);
      }
    } catch (e) {
      print('[AppSession] Save error: $e');
    }
  }
}