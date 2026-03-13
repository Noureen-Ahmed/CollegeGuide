/// User model - Non-freezed version for reliability
/// Supports both students and professors
library;

enum AppMode { student, professor }

class User {
  final String id;
  final String email;
  final String name;
  final String? nameAr;
  final String? avatar;
  final String? studentId;
  final String? phone;
  final String? department;
  final String? departmentId;
  final String? program;
  final String? programId;
  final String? faculty;
  final String? semester;
  final String? academicYear;
  final double? gpa;
  final int? level;
  final List<String> enrolledCourses;
  final AppMode mode;
  final bool isOnboardingComplete;
  final bool isVerified;
  final String? advisorName;
  final String? advisorEmail;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.nameAr,
    this.avatar,
    this.studentId,
    this.phone,
    this.department,
    this.departmentId,
    this.program,
    this.programId,
    this.faculty,
    this.semester,
    this.academicYear,
    this.gpa,
    this.level,
    this.enrolledCourses = const [],
    this.mode = AppMode.student,
    this.isOnboardingComplete = false,
    this.isVerified = false,
    this.advisorName,
    this.advisorEmail,
  });

  /// Create from JSON (API response)
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle mode/role conversion
    AppMode userMode = AppMode.student;
    if (json['mode'] == 'professor' || 
        json['role'] == 'professor' || 
        json['role'] == 'PROFESSOR') {
      userMode = AppMode.professor;
    }

    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'],
      avatar: json['avatar'],
      studentId: json['studentId'],
      phone: json['phone'],
      department: json['department'] is Map ? json['department']['name'] : json['department'],
      departmentId: json['departmentId'],
      program: json['program'] is Map 
          ? json['program']['name'] 
          : (json['program'] ?? json['major']),
      programId: json['programId'],
      faculty: json['faculty'],
      semester: json['semester'],
      academicYear: json['academicYear'],
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,
      level: json['level'],
      enrolledCourses: json['enrolledCourses'] != null 
          ? List<String>.from(json['enrolledCourses'])
          : [],
      mode: userMode,
      isOnboardingComplete: json['isOnboardingComplete'] ?? false,
      isVerified: json['isVerified'] ?? false,
      advisorName: json['advisorName'],
      advisorEmail: json['advisorEmail'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'nameAr': nameAr,
      'avatar': avatar,
      'studentId': studentId,
      'phone': phone,
      'department': department,
      'departmentId': departmentId,
      'program': program,
      'programId': programId,
      'faculty': faculty,
      'semester': semester,
      'academicYear': academicYear,
      'gpa': gpa,
      'level': level,
      'enrolledCourses': enrolledCourses,
      'mode': mode == AppMode.professor ? 'professor' : 'student',
      'isOnboardingComplete': isOnboardingComplete,
      'isVerified': isVerified,
      'advisorName': advisorName,
      'advisorEmail': advisorEmail,
    };
  }

  /// Create copy with modified fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? nameAr,
    String? avatar,
    String? studentId,
    String? phone,
    String? department,
    String? departmentId,
    String? program,
    String? programId,
    String? faculty,
    String? semester,
    String? academicYear,
    double? gpa,
    int? level,
    List<String>? enrolledCourses,
    AppMode? mode,
    bool? isOnboardingComplete,
    bool? isVerified,
    String? advisorName,
    String? advisorEmail,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      avatar: avatar ?? this.avatar,
      studentId: studentId ?? this.studentId,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      departmentId: departmentId ?? this.departmentId,
      program: program ?? this.program,
      programId: programId ?? this.programId,
      faculty: faculty ?? this.faculty,
      semester: semester ?? this.semester,
      academicYear: academicYear ?? this.academicYear,
      gpa: gpa ?? this.gpa,
      level: level ?? this.level,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      mode: mode ?? this.mode,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isVerified: isVerified ?? this.isVerified,
      advisorName: advisorName ?? this.advisorName,
      advisorEmail: advisorEmail ?? this.advisorEmail,
    );
  }

  /// Check if user is a professor
  bool get isProfessor => mode == AppMode.professor;

  /// Check if user is a student
  bool get isStudent => mode == AppMode.student;

  /// Alias for program (backward compatibility)
  String? get major => program;

  @override
  String toString() => 'User(id: $id, email: $email, name: $name, mode: $mode)';
}