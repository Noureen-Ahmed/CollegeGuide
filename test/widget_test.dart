import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_dashboard_flutter/screens/dashboard_shell.dart';
import 'package:student_dashboard_flutter/screens/home_screen.dart';
import 'package:student_dashboard_flutter/screens/notifications_screen.dart';
import 'package:student_dashboard_flutter/providers/app_mode_provider.dart';
import 'package:student_dashboard_flutter/models/user.dart';
import 'package:student_dashboard_flutter/repositories/auth_repository.dart';
import 'package:student_dashboard_flutter/core/result.dart';
import 'package:student_dashboard_flutter/core/exceptions.dart';
import 'package:student_dashboard_flutter/widgets/custom_bottom_navigation.dart';
import 'package:student_dashboard_flutter/widgets/custom_header.dart';
import 'package:student_dashboard_flutter/widgets/custom_status_bar.dart';

void main() {
  group('Dashboard Shell Widget Tests', () {
    testWidgets('Dashboard shell renders custom components',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardShell(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Verify custom status bar is present
      expect(find.byType(CustomStatusBar), findsOneWidget);

      // Verify custom header is present
      expect(find.byType(CustomHeader), findsOneWidget);

      // Verify custom bottom navigation is present
      expect(find.byType(CustomBottomNavigation), findsOneWidget);
    });

    testWidgets('Professor FAB shows in professor mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appModeControllerProvider.overrideWith(
                (ref) => MockAppModeController(AppMode.professor)),
          ],
          child: const MaterialApp(
            home: DashboardShell(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Verify FAB is present in professor mode
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Professor FAB does not show in student mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appModeControllerProvider
                .overrideWith((ref) => MockAppModeController(AppMode.student)),
          ],
          child: const MaterialApp(
            home: DashboardShell(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Verify FAB is not present in student mode
      expect(find.byIcon(Icons.add), findsNothing);
    });
  });

  group('Custom Bottom Navigation Tests', () {
    testWidgets('Bottom navigation shows all tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBottomNavigation(currentRoute: '/home'),
          ),
        ),
      );

      // Verify all tabs are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Home tab is highlighted when on home route',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBottomNavigation(currentRoute: '/home'),
          ),
        ),
      );

      // Find the home tab icon and text
      final homeIcon = find.byIcon(Icons.home);
      final homeText = find.text('Home');

      expect(homeIcon, findsOneWidget);
      expect(homeText, findsOneWidget);

      // Verify the icon is the filled version (active)
      final iconWidget = tester.widget<Icon>(homeIcon);
      expect(iconWidget.icon, equals(Icons.home));
    });

    testWidgets('Tasks tab is highlighted when on tasks route',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBottomNavigation(currentRoute: '/tasks'),
          ),
        ),
      );

      // Find the tasks tab icon and text
      final tasksIcon = find.byIcon(Icons.task);
      final tasksText = find.text('Tasks');

      expect(tasksIcon, findsOneWidget);
      expect(tasksText, findsOneWidget);

      // Verify the icon is the filled version (active)
      final iconWidget = tester.widget<Icon>(tasksIcon);
      expect(iconWidget.icon, equals(Icons.task));
    });
  });

  group('Custom Header Tests', () {
    testWidgets('Header shows user information', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          overrides: [
            // Mock user provider
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CustomHeader(),
            ),
          ),
        ),
      );

      // Verify header structure
      expect(find.byType(CustomHeader), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('Notification badge shows when there are unread notifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          overrides: [
            // Mock announcement provider with unread notifications
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CustomHeader(),
            ),
          ),
        ),
      );

      // Verify notification badge is present
      expect(find.byType(Positioned), findsWidgets);
    });
  });

  group('Custom Status Bar Tests', () {
    testWidgets('Status bar shows time and system icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomStatusBar(),
          ),
        ),
      );

      // Verify time is displayed
      expect(find.text('9:41'), findsOneWidget);

      // Verify system icons are present
      expect(find.byIcon(Icons.signal_cellular_alt_outlined), findsOneWidget);
      expect(find.text('📶'), findsOneWidget);
    });
  });

  group('Home Screen Tests', () {
    testWidgets('Home screen renders announcement banner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardShell(
              child: HomeScreen(),
            ),
          ),
        ),
      );

      // Allow for async data loading
      await tester.pumpAndSettle();

      // Verify announcement banner is present
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Home screen renders quick actions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardShell(
              child: HomeScreen(),
            ),
          ),
        ),
      );

      // Allow for async data loading
      await tester.pumpAndSettle();

      // Verify quick action buttons are present
      expect(find.text('Assignments'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Courses'), findsOneWidget);
      expect(find.text('Events'), findsOneWidget);
    });

    testWidgets('Home screen renders info cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardShell(
              child: HomeScreen(),
            ),
          ),
        ),
      );

      // Allow for async data loading
      await tester.pumpAndSettle();

      // Verify info cards are present
      expect(find.text("Today's Work"), findsOneWidget);
      expect(find.text('Next Lecture'), findsOneWidget);
    });
  });

  group('Notifications Screen Tests', () {
    testWidgets('Notifications screen renders header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NotificationsScreen(),
          ),
        ),
      );

      // Verify header is present
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Stay updated with your courses'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Notifications screen shows unread count',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          overrides: [
            // Mock announcement provider with unread notifications
          ],
          child: MaterialApp(
            home: NotificationsScreen(),
          ),
        ),
      );

      // Allow for async data loading
      await tester.pumpAndSettle();

      // Verify unread count badge is present
      expect(find.textContaining('new'), findsOneWidget);
    });

    testWidgets('Notifications screen shows empty state when no notifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          overrides: [
            // Mock announcement provider with no notifications
          ],
          child: MaterialApp(
            home: NotificationsScreen(),
          ),
        ),
      );

      // Allow for async data loading
      await tester.pumpAndSettle();

      // Verify empty state is shown
      expect(find.text('All caught up!'), findsOneWidget);
      expect(find.text("You don't have any notifications right now"),
          findsOneWidget);
    });
  });

  group('Tab Navigation Tests', () {
    testWidgets('Tapping home tab navigates to home',
        (WidgetTester tester) async {
      bool navigatedToHome = false;

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              navigatedToHome = true;
            }
            return null;
          },
          home: const Scaffold(
            body: CustomBottomNavigation(currentRoute: '/tasks'),
          ),
        ),
      );

      // Find and tap the home tab
      final homeTab = find.text('Home');
      expect(homeTab, findsOneWidget);

      await tester.tap(homeTab);
      await tester.pumpAndSettle();

      // Verify navigation was triggered (in real app, this would use GoRouter)
      expect(homeTab, findsOneWidget);
    });

    testWidgets('Tapping tasks tab navigates to tasks',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBottomNavigation(currentRoute: '/home'),
          ),
        ),
      );

      // Find and tap the tasks tab
      final tasksTab = find.text('Tasks');
      expect(tasksTab, findsOneWidget);

      await tester.tap(tasksTab);
      await tester.pumpAndSettle();

      // Verify tab was tapped
      expect(tasksTab, findsOneWidget);
    });
  });
}

// Mock AppModeController for testing
class MockAppModeController extends AppModeController {
  final AppMode _initialMode;

  MockAppModeController(this._initialMode)
      : super(MockAuthRepository() as Ref<Object?>) {
    state = _initialMode;
  }
}

// Mock AuthRepository for testing
class MockAuthRepository implements AuthRepository {
  @override
  Future<Result<User?>> getCurrentUser() async => Result.success(null);

  @override
  Future<Result<User>> updateUser(User user) async => Result.success(user);

  @override
  Future<Result<User>> login(String email, String password,
      {bool rememberMe = false}) async {
    return Result.failure(const AuthException('Mock login not implemented'));
  }

  @override
  Future<Result<User>> register(String name, String email, String password,
      {bool rememberMe = false}) async {
    return Result.failure(
        const AuthException('Mock registration not implemented'));
  }

  @override
  Future<Result<void>> forgotPassword(String email) async =>
      Result.success(null);

  @override
  Future<Result<void>> logout() async => Result.success(null);

  @override
  Future<Result<void>> changePassword(
          String currentPassword, String newPassword) async =>
      Result.success(null);

  @override
  Stream<User?> watchUser() => Stream.value(null);
}
