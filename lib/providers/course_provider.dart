import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../models/user.dart';
import '../services/data_service.dart';
import 'app_session_provider.dart';

/// Current user's enrolled courses provider
final enrolledCoursesProvider = AsyncNotifierProvider<EnrolledCoursesNotifier, List<Course>>(EnrolledCoursesNotifier.new);

class EnrolledCoursesNotifier extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user == null) return [];
    
    // Fetch app enrolled courses and UMS courses in parallel
    final results = await Future.wait([
      DataService.getEnrolledCourses(user.email),
      DataService.getUmsCourses(),
    ]);
    
    final appCourses = results[0];
    final umsCourses = results[1];
    
    // Merge: add UMS courses that aren't already in app courses (by code)
    // Normalize codes by removing whitespace
    final appCourseCodes = appCourses.map((c) => c.code.replaceAll(' ', '').toLowerCase()).toSet();
    final uniqueUmsCourses = umsCourses
        .where((c) => !appCourseCodes.contains(c.code.replaceAll(' ', '').toLowerCase()))
        .toList();
    
    return [...appCourses, ...uniqueUmsCourses];
  }

  Future<void> enroll(String courseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final success = await DataService.enrollInCourse(courseId);
      if (!success) throw Exception('Failed to enroll in course');
      return _fetchCourses();
    });
  }

  Future<void> drop(String courseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final success = await DataService.dropCourse(courseId);
      if (!success) throw Exception('Failed to drop course');
      return _fetchCourses();
    });
  }

  Future<List<Course>> _fetchCourses() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return [];
    
    final results = await Future.wait([
      DataService.getEnrolledCourses(user.email),
      DataService.getUmsCourses(),
    ]);
    
    final appCourses = results[0];
    final umsCourses = results[1];
    
    // Normalize codes by removing whitespace
    final appCourseCodes = appCourses.map((c) => c.code.replaceAll(' ', '').toLowerCase()).toSet();
    final uniqueUmsCourses = umsCourses
        .where((c) => !appCourseCodes.contains(c.code.replaceAll(' ', '').toLowerCase()))
        .toList();
    
    return [...appCourses, ...uniqueUmsCourses];
  }
}

/// Professor's assigned courses provider
final professorCoursesProvider = AsyncNotifierProvider<ProfessorCoursesNotifier, List<Course>>(ProfessorCoursesNotifier.new);

class ProfessorCoursesNotifier extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user == null || user.mode != AppMode.professor) return [];
    
    return DataService.getProfessorCourses(user.email);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

/// All courses provider (Cache-able)
final coursesProvider = FutureProvider<List<Course>>((ref) async {
  return DataService.getCourses();
});

/// Course by ID provider
final courseByIdProvider = FutureProvider.family<Course?, String>((ref, courseId) async {
  return DataService.getCourse(courseId);
});

/// Course filter state
final courseFilterProvider = StateProvider<CourseFilter>((ref) {
  return CourseFilter();
});

class CourseFilter {
  final EnrollmentStatus? enrollmentStatus;
  final CourseCategory? category;
  final String searchTerm;

  CourseFilter({
    this.enrollmentStatus,
    this.category,
    this.searchTerm = '',
  });

  CourseFilter copyWith({
    EnrollmentStatus? enrollmentStatus,
    CourseCategory? category,
    String? searchTerm,
  }) {
    return CourseFilter(
      enrollmentStatus: enrollmentStatus ?? this.enrollmentStatus,
      category: category ?? this.category,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}