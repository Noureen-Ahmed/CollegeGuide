import '../models/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<void> updateUser(User user);
  Future<void> switchMode(AppMode mode);
  Stream<User?> watchUser();
}

class MockUserRepository implements UserRepository {
  User _currentUser = const User(
    id: '1',
    name: 'Michael Jordan',
    email: 'michaeljordan@gmail.com',
    avatar: 'https://picsum.photos/seed/user123/200/200.jpg',
    studentId: 'STU001234',
    program: 'Computer Science',
    enrolledCourses: const ['1', '4'], // Enrolled in COMP101 and COMP201
    mode: AppMode.student,
  );

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = user;
  }

  @override
  Future<void> switchMode(AppMode mode) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = _currentUser.copyWith(mode: mode);
  }

  @override
  Stream<User?> watchUser() {
    return Stream.value(_currentUser);
  }
}