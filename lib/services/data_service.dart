/// Unified Data Service
/// Single point of truth for all API interactions
/// Replaces individual repositories with a clean, consistent interface
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/course.dart';
import '../models/task.dart';
import '../models/announcement.dart';
import '../models/schedule_event.dart';
import '../models/user.dart';

class DataService {
  static Future<User?> login(String email, String password) async {
    try {
      // Route based on email format:
      // Starts with 2 or more letters -> doctor/admin login
      // Starts with 0 or 1 letter (like passport ID 'A123') -> student UMS login
      final isDoctor = RegExp(r'^[a-zA-Z]{2,}').hasMatch(email);
      final isStudent = !isDoctor;
      final endpoint = isStudent ? '/ums/login' : '/auth/login';
      final body = isStudent 
          ? {'loginName': email, 'password': password}
          : {'email': email, 'password': password};

      print('[DataService] Routing login to $endpoint for email: $email');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          ApiConfig.setAuthToken(data['token']);
        }
        // /api/ums/login already scrapes+saves all data and returns the full user
        return _parseUser(data['user']);
      }
      return null;
    } catch (e) {
      print('[DataService] Login error: $e');
      return null;
    }
  }
  
  /// Register new user
  static Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          ApiConfig.setAuthToken(data['token']);
        }
        return _parseUser(data['user']);
      }
      return null;
    } catch (e) {
      print('[DataService] Register error: $e');
      return null;
    }
  }
  
  /// Get current user by email
  static Future<User?> getUser(String email) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/${Uri.encodeComponent(email)}'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseUser(data['user']);
      }
      return null;
    } catch (e) {
      print('[DataService] Get user error: $e');
      return null;
    }
  }

  /// Update user profile
  static Future<User?> updateUser(User user) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/users/${Uri.encodeComponent(user.email)}'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'name': user.name,
          'nameAr': user.nameAr,
          'phone': user.phone,
          'studentId': user.studentId,
          'department': user.department,
          'program': user.program,
          'programId': user.programId,
          'departmentId': user.departmentId,
          'level': user.level,
          'gpa': user.gpa,
          'avatar': user.avatar,
          'isOnboardingComplete': user.isOnboardingComplete,
          'enrolledCourses': user.enrolledCourses,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseUser(data['user']);
      }
      return null;
    } catch (e) {
      print('[DataService] Update user error: $e');
      return null;
    }
  }
  
  /// Change password
  static Future<bool> changePassword(String email, String currentPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/change-password'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Change password error: $e');
      return false;
    }
  }

  /// Get departments and levels metadata
  static Future<Map<String, dynamic>> getDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/metadata/departments'),
        headers: ApiConfig.headers,
      );
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      }
      return {};
    } catch (e) {
      print('[DataService] Get departments error: $e');
      return {};
    }
  }

  /// Logout
  static Future<void> logout() async {
    ApiConfig.clearAuth();
  }
  
  // ============ COURSES ============
  
  /// Get all courses
  static Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List courses = data['courses'] ?? [];
        return courses.map((c) => Course.fromJson(c)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get courses error: $e');
      return [];
    }
  }
  
  /// Get course by ID
  static Future<Course?> getCourse(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses/$id'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Course.fromJson(data['course']);
      }
      return null;
    } catch (e) {
      print('[DataService] Get course error: $e');
      return null;
    }
  }
  
  /// Get student's enrolled courses
  static Future<List<Course>> getEnrolledCourses(String userEmail) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/${Uri.encodeComponent(userEmail)}/enrollments'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List enrollments = data['enrollments'] ?? [];
        return enrollments.map((e) {
          final courseData = e['course'] as Map<String, dynamic>;
          // Add enrollment status
          courseData['enrollmentStatus'] = 'enrolled';
          return Course.fromJson(courseData);
        }).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get enrolled courses error: $e');
      return [];
    }
  }
  
  /// Get professor's assigned courses
  static Future<List<Course>> getProfessorCourses(String email) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/professor/courses?email=${Uri.encodeComponent(email)}'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List courses = data['courses'] ?? [];
        return courses.map((c) => Course.fromJson(c)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get professor courses error: $e');
      return [];
    }
  }
  
  /// Enroll in a course
  static Future<bool> enrollInCourse(String courseId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/courses/$courseId/enroll'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Enroll error: $e');
      return false;
    }
  }
  
  /// Drop a course
  static Future<bool> dropCourse(String courseId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/courses/$courseId/enroll'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Drop course error: $e');
      return false;
    }
  }
  
  // ============ TASKS ============
  
  /// Get all tasks for current user
  static Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List tasks = data['tasks'] ?? [];
        return tasks.map((t) => _parseTask(t)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get tasks error: $e');
      return [];
    }
  }
  
  /// Get pending tasks
  static Future<List<Task>> getPendingTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks?status=pending'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List tasks = data['tasks'] ?? [];
        return tasks.map((t) => _parseTask(t)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get pending tasks error: $e');
      return [];
    }
  }

  /// Get single task by ID
  static Future<Task?> getTask(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseTask(data['task']);
      }
      return null;
    } catch (e) {
      print('[DataService] Get task error: $e');
      return null;
    }
  }
  
  /// Create a personal task
  static Future<Task?> createTask({
    required String title,
    String? description,
    String priority = 'MEDIUM',
    DateTime? dueDate,
    String? courseId,
    String type = 'PERSONAL',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'title': title,
          'description': description,
          'priority': priority,
          'dueDate': dueDate?.toIso8601String(),
          'courseId': courseId,
          'taskType': type,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return _parseTask(data['task']);
      }
      return null;
    } catch (e) {
      print('[DataService] Create task error: $e');
      return null;
    }
  }
  
  /// Update a task
  static Future<bool> updateTask({
    required String id,
    String? title,
    String? description,
    String? priority,
    DateTime? dueDate,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (priority != null) 'priority': priority,
          if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Update task error: $e');
      return false;
    }
  }
  
  /// Toggle task completion
  static Future<bool> toggleTaskComplete(String taskId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/complete'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Toggle task error: $e');
      return false;
    }
  }
  
  /// Delete task
  static Future<bool> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Delete task error: $e');
      return false;
    }
  }

  /// Submit task (assignment)
  static Future<bool> submitTask({
    required String taskId,
    String? fileUrl,
    String? notes,
    Map<String, dynamic>? answers,
    List<Map<String, dynamic>>? snapshots,
    DateTime? startedAt,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/submit'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'fileUrl': fileUrl,
          'notes': notes,
          if (answers != null) 'answers': answers,
          if (snapshots != null) 'snapshots': snapshots,
          if (startedAt != null) 'startedAt': startedAt.toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Submit task error: $e');
      return false;
    }
  }

  /// Unsubmit task (assignment)
  static Future<bool> unsubmitTask(String taskId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/unsubmit'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Unsubmit task error: $e');
      return false;
    }
  }

  /// Get submissions for a task (Professor)
  static Future<List<Map<String, dynamic>>> getTaskSubmissions(String taskId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/submissions'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['submissions']);
      }
      return [];
    } catch (e) {
      print('[DataService] Get submissions error: $e');
      return [];
    }
  }

  /// Grade a submission (Professor)
  static Future<bool> gradeSubmission({
    required String submissionId,
    required double points,
    String? feedback,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/submissions/$submissionId/grade'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'points': points,
          'feedback': feedback,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Grade submission error: $e');
      return false;
    }
  }
  
  // ============ ANNOUNCEMENTS ============
  
  /// Get announcements
  static Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/announcements'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List announcements = data['announcements'] ?? [];
        return announcements.map((a) => _parseAnnouncement(a)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get announcements error: $e');
      return [];
    }
  }
  
  /// Create announcement (professor only)
  static Future<bool> createAnnouncement({
    required String title,
    required String message,
    String? courseId,
    String type = 'GENERAL',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/announcements'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'title': title,
          'message': message,
          'courseId': courseId,
          'type': type,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create announcement error: $e');
      return false;
    }
  }
  
  // ============ SCHEDULE ============
  
  /// Get schedule events
  static Future<List<ScheduleEvent>> getScheduleEvents() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/schedule'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List events = data['events'] ?? [];
        return events.map((e) => _parseScheduleEvent(e)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get schedule error: $e');
      return [];
    }
  }
  
  /// Get upcoming events
  static Future<List<ScheduleEvent>> getUpcomingEvents({int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/schedule/upcoming?days=$days'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List events = data['events'] ?? [];
        return events.map((e) => _parseScheduleEvent(e)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get upcoming events error: $e');
      return [];
    }
  }
  
  /// Create personal schedule event
  static Future<bool> createScheduleEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/schedule'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'title': title,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'description': description,
          'location': location,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create event error: $e');
      return false;
    }
  }
  
  // ============ NOTIFICATIONS ============
  
  /// Get notifications
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifications'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['notifications'] ?? []);
      }
      return [];
    } catch (e) {
      print('[DataService] Get notifications error: $e');
      return [];
    }
  }
  
  /// Mark notification as read
  static Future<bool> markNotificationRead(String id) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notifications/$id/read'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Mark notification read error: $e');
      return false;
    }
  }
  
  // ============ UPLOAD ============
  
  /// Upload file
  /// [type] can be: 'profile', 'submission', 'content', 'lecture', 'attachment'
  static Future<String?> uploadFile(List<int> bytes, String filename, {String? type}) async {
    try {
      final uploadUrl = type != null 
          ? '${ApiConfig.baseUrl}/upload?type=$type'
          : '${ApiConfig.baseUrl}/upload';
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      
      final authHeader = ApiConfig.authHeaders['Authorization'];
      if (authHeader != null) {
         request.headers['Authorization'] = authHeader;
      }

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['fileUrl'] != null) {
          return data['fileUrl'];
        }
      }
      return null;
    } catch (e) {
      print('[DataService] Upload error: $e');
      return null;
    }
  }

  // ============ CONTENT (Professor) ============
  
  /// Create course content (lecture, material)
  static Future<bool> createContent({
    required String courseId,
    required String title,
    String? description,
    String contentType = 'LECTURE',
    int? weekNumber,
    List<String>? attachments,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'courseId': courseId,
        'title': title,
        'description': description,
        'contentType': contentType,
        'weekNumber': weekNumber,
        if (attachments != null) 'attachments': attachments,
      };
      
      // Remove nulls to satisfy backend validators
      body.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/content'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create content error: $e');
      return false;
    }
  }
  
  /// Create assignment
  static Future<bool> createAssignment({
    required String courseId,
    required String title,
    String? description,
    required DateTime dueDate,
    int maxPoints = 100,
    List<String>? attachments,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'courseId': courseId,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'points': maxPoints,
        if (attachments != null) 'attachments': attachments,
      };
      
      body.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/content/assignment'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create assignment error: $e');
      return false;
    }
  }
  
  /// Create exam
  static Future<bool> createExam({
    required String courseId,
    required String title,
    String? description,
    required DateTime examDate,
    int maxPoints = 100,
    List<String>? attachments,
    List<dynamic>? questions,
    Map<String, dynamic>? settings,
    bool? published,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'courseId': courseId,
        'title': title,
        'description': description,
        'examDate': examDate.toIso8601String(),
        'points': maxPoints,
        if (attachments != null) 'attachments': attachments,
        if (questions != null) 'questions': questions,
        if (settings != null) 'settings': settings,
        if (published != null) 'published': published,
      };
      
      body.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/content/exam'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create exam error: $e');
      return false;
    }
  }

  /// Get exam conflicts for a course (dates with student exams in other courses)
  static Future<Map<DateTime, int>> getExamConflicts(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses/$courseId/exam-conflicts'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Map<String, dynamic> conflicts = data['conflicts'] ?? {};
        
        // Convert string dates to DateTime keys
        final Map<DateTime, int> result = {};
        for (final entry in conflicts.entries) {
          final date = DateTime.tryParse(entry.key);
          if (date != null) {
            result[DateTime(date.year, date.month, date.day)] = entry.value as int;
          }
        }
        return result;
      }
      return {};
    } catch (e) {
      print('[DataService] Get exam conflicts error: $e');
      return {};
    }
  }
  
  // ============ UMS PORTAL INTEGRATION ============

  /// Login to UMS portal and sync student data
  static Future<Map<String, dynamic>?> umsLogin({
    required String loginName,
    required String password,
    String domain = 'asu.edu.eg',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ums/login'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'loginName': loginName,
          'password': password,
          'domain': domain,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('[DataService] UMS login error: $e');
      return null;
    }
  }

  /// Re-sync UMS data using stored session
  static Future<Map<String, dynamic>?> umsSync(String email, String password) async {
    try {
      final body = {
        'umsUsername': email,
        'umsPassword': password
      };
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ums/sync'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('[DataService] UMS sync error: $e');
      return null;
    }
  }

  /// Get UMS synced courses
  static Future<List<Course>> getUmsCourses() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ums/courses'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List courses = data['courses'] ?? [];
        return courses.map((c) => Course(
          id: 'ums-${c['id']}',
          code: c['course_code'] ?? c['courseCode'] ?? '',
          name: c['course_name'] ?? c['courseName'] ?? '',
          category: CourseCategory.comp,
          creditHours: c['credit_hours'] ?? c['creditHours'] ?? 3,
          professors: c['instructor_name'] != null ? [c['instructor_name']] 
                     : c['instructorName'] != null ? [c['instructorName']] : [],
          description: 'Synced from UMS Portal',
          schedule: [],
          content: [],
          assignments: [],
          exams: [],
          enrollmentStatus: EnrollmentStatus.enrolled,
        )).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get UMS courses error: $e');
      return [];
    }
  }

  /// Get UMS synced grades
  static Future<List<Map<String, dynamic>>> getUmsGrades() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ums/grades'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['grades'] ?? []);
      }
      return [];
    } catch (e) {
      print('[DataService] Get UMS grades error: $e');
      return [];
    }
  }

  /// Get UMS connection profile status
  static Future<Map<String, dynamic>?> getUmsProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ums/profile'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('[DataService] Get UMS profile error: $e');
      return null;
    }
  }

  // ============ HELPER METHODS ============
  
  static User? _parseUser(Map<String, dynamic>? json) {
    if (json == null) return null;
    return User.fromJson(json);
  }
  
  static Task _parseTask(Map<String, dynamic> json) {
    return Task.fromJson(json);
  }
  
  static Announcement _parseAnnouncement(Map<String, dynamic> json) {
    AnnouncementType type;
    switch ((json['type'] ?? 'GENERAL').toString().toUpperCase()) {
      case 'EXAM':
        type = AnnouncementType.exam;
        break;
      case 'ASSIGNMENT':
        type = AnnouncementType.assignment;
        break;
      case 'LECTURE':
      case 'EVENT':
        type = AnnouncementType.event;
        break;
      default:
        type = AnnouncementType.general;
    }
    
    return Announcement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      type: type,
      isRead: json['isRead'] ?? false,
      courseCode: json['course']?['code'] ?? json['courseCode'],
      courseName: json['course']?['name'] ?? json['courseName'],
    );
  }
  
  static ScheduleEvent _parseScheduleEvent(Map<String, dynamic> json) {
  return ScheduleEvent(
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString() ?? 'Event',
    startTime: json['startTime'] != null 
        ? DateTime.parse(json['startTime'])
        : DateTime.now(),
    endTime: json['endTime'] != null 
        ? DateTime.parse(json['endTime'])
        : DateTime.now().add(const Duration(hours: 1)),
    location: json['location']?.toString() ?? '',
    instructor: json['instructor']?.toString() ?? '',
    courseId: json['courseId']?.toString(),
    description: json['description']?.toString(),
    type: json['eventType'] ?? json['type'] ?? 'lecture',
  );
  }
}
