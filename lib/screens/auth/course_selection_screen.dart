import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../storage_services.dart';
import '../../providers/app_session_provider.dart';
import '../../models/course.dart';
import '../../services/data_service.dart';

class SelectCoursePage extends ConsumerStatefulWidget {
  final String email;
  final String? password;
  const SelectCoursePage({super.key, required this.email, this.password});

  @override
  ConsumerState<SelectCoursePage> createState() => _SelectCoursePageState();
}

class _SelectCoursePageState extends ConsumerState<SelectCoursePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();

  // Department and Program data
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _programs = [];
  List<Map<String, dynamic>> _levels = [];

  String? _selectedDepartmentId;
  String? _selectedProgramId;
  int? _selectedLevel;
  CourseCategory? _selectedCategoryFilter;

  List<String> selectedCourseIds = [];
  bool _isLoading = true;
  bool _isSaving = false;

  List<Course> _allCourses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load Departments and Levels from Backend
      final metadata = await DataService.getDepartments();

      // Load Courses from Backend
      final courses = await DataService.getCourses();

      if (mounted) {
        setState(() {
          _departments =
              List<Map<String, dynamic>>.from(metadata['departments'] ?? []);
          _levels = List<Map<String, dynamic>>.from(metadata['levels'] ?? []);
          _allCourses = courses;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onDepartmentChanged(String? departmentId) {
    setState(() {
      _selectedDepartmentId = departmentId;
      _selectedProgramId = null;

      // Update programs based on selected department
      if (departmentId != null) {
        final dept = _departments.firstWhere(
          (d) => d['id'] == departmentId,
          orElse: () => {'programs': []},
        );
        _programs = List<Map<String, dynamic>>.from(dept['programs'] ?? []);
      } else {
        _programs = [];
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  List<Course> _getFilteredCourses() {
    String query = _searchController.text.toLowerCase();
    return _allCourses.where((course) {
      bool matchesSearch = course.code.toLowerCase().contains(query) ||
          course.name.toLowerCase().contains(query);

      bool matchesLevel = true;
      if (_selectedLevel != null) {
        // Simple heuristic: 1st digit of number in code matches level
        // e.g. COMP101 -> 1, COMP201 -> 2
        final digits = course.code.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.isNotEmpty) {
          int courseLevel = int.parse(digits[0]);
          matchesLevel = courseLevel == _selectedLevel;
        }
      }

      bool matchesCategory = true;
      if (_selectedCategoryFilter != null) {
        matchesCategory = course.category == _selectedCategoryFilter;
      }

      return matchesSearch && matchesLevel && matchesCategory;
    }).toList();
  }

  void _toggleCourse(String id) {
    setState(() {
      if (selectedCourseIds.contains(id)) {
        selectedCourseIds.remove(id);
      } else {
        selectedCourseIds.add(id);
      }
    });
  }

  bool _validateForm() {
    if (_selectedDepartmentId == null) {
      _showError('Please select a department');
      return false;
    }
    if (_selectedProgramId == null) {
      _showError('Please select a program');
      return false;
    }
    if (_selectedLevel == null) {
      _showError('Please select your level');
      return false;
    }

    final gpaText = _gpaController.text.trim();
    if (gpaText.isNotEmpty) {
      final gpa = double.tryParse(gpaText);
      if (gpa == null || gpa < 0 || gpa > 4.0) {
        _showError('GPA must be between 0.0 and 4.0');
        return false;
      }
    }

    if (selectedCourseIds.isEmpty) {
      _showError('Please select at least one course');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _finishSelection() async {
    if (!_validateForm()) return;

    setState(() => _isSaving = true);

    await StorageService.saveCourses(selectedCourseIds);

    // Get department and program names
    final deptName = _departments.firstWhere(
      (d) => d['id'] == _selectedDepartmentId,
      orElse: () => {'name': ''},
    )['name'];

    final programName = _programs.firstWhere(
      (p) => p['id'] == _selectedProgramId,
      orElse: () => {'name': ''},
    )['name'];

    // Update user with all profile data
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser != null) {
      final gpa = _gpaController.text.isNotEmpty
          ? double.tryParse(_gpaController.text)
          : null;

      final updatedUser = currentUser.copyWith(
        department: deptName,
        departmentId: _selectedDepartmentId,
        program: programName,
        programId: _selectedProgramId,
        level: _selectedLevel,
        gpa: gpa,
        enrolledCourses: selectedCourseIds,
        isOnboardingComplete: true,
      );

      // This updates the user in the database AND updates the local state
      // The authStateProvider will automatically detect isOnboardingComplete=true
      // and redirect to /home
      await ref
          .read(appSessionControllerProvider.notifier)
          .updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile setup complete!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigation will be handled by authStateProvider in main.dart
        // since isOnboardingComplete is now true -> authenticated -> redirect to /home
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: User session not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/login');
      }
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _getFilteredCourses();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050816), Color(0xFF1a1f3a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Complete Your Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white70),
                          onPressed: () async {
                            await ref
                                .read(appSessionControllerProvider.notifier)
                                .logout();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome, ${widget.email}',
                      style: const TextStyle(color: Color(0xFFd1d5db)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Setup Section
                              const Text(
                                'Academic Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1a1f3a),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Department Dropdown
                              _buildDropdown(
                                label: 'Department',
                                value: _selectedDepartmentId,
                                items: _departments
                                    .map((d) => DropdownMenuItem<String>(
                                          value: d['id'],
                                          child: Text(d['name']),
                                        ))
                                    .toList(),
                                onChanged: _onDepartmentChanged,
                              ),
                              const SizedBox(height: 16),

                              // Program Dropdown
                              _buildDropdown(
                                label: 'Program',
                                value: _selectedProgramId,
                                items: _programs
                                    .map((p) => DropdownMenuItem<String>(
                                          value: p['id'],
                                          child: Text(p['name']),
                                        ))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => _selectedProgramId = value),
                                enabled: _selectedDepartmentId != null,
                              ),
                              const SizedBox(height: 16),

                              // Level Dropdown
                              _buildDropdown(
                                label: 'Level',
                                value: _selectedLevel,
                                items: _levels
                                    .map((l) => DropdownMenuItem<int>(
                                          value: l['id'],
                                          child: Text(l['name']),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() {
                                  _selectedLevel = value;
                                }),
                              ),
                              const SizedBox(height: 16),

                              // GPA Input
                              TextFormField(
                                controller: _gpaController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                  labelText: 'GPA (optional)',
                                  hintText: 'Enter your GPA (0.0 - 4.0)',
                                  filled: true,
                                  fillColor: const Color(0xFFf9fafb),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFe5e7eb)),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),
                              const Divider(),
                              const SizedBox(height: 16),

                              // Course Selection Section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Select Courses',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1a1f3a),
                                    ),
                                  ),
                                  // Category Filter
                                  DropdownButton<CourseCategory?>(
                                    value: _selectedCategoryFilter,
                                    hint: const Text('All Categories'),
                                    items: [
                                      const DropdownMenuItem(
                                          value: null, child: Text('All')),
                                      ...CourseCategory.values
                                          .map((c) => DropdownMenuItem(
                                                value: c,
                                                child:
                                                    Text(c.name.toUpperCase()),
                                              )),
                                    ],
                                    onChanged: (val) => setState(
                                        () => _selectedCategoryFilter = val),
                                    underline: Container(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selected: ${selectedCourseIds.length} courses${_selectedLevel != null ? ' (Filtered by Level $_selectedLevel)' : ''}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),

                              // Search
                              TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Search courses...',
                                  prefixIcon: const Icon(Icons.search,
                                      color: Color(0xFF9ca3af)),
                                  filled: true,
                                  fillColor: const Color(0xFFf9fafb),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Course List
                              filteredCourses.isEmpty
                                  ? const Center(
                                      child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                          'No courses found matching filters'),
                                    ))
                                  : Column(
                                      children: filteredCourses
                                          .map((course) =>
                                              _buildCourseCard(course))
                                          .toList(),
                                    ),

                              const SizedBox(height: 24),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      _isSaving ? null : _finishSelection,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563eb),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2),
                                        )
                                      : const Text(
                                          'Complete Setup',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: enabled ? const Color(0xFFf9fafb) : const Color(0xFFe5e7eb),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFe5e7eb)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFe5e7eb)),
        ),
      ),
      items: items,
      onChanged: enabled ? onChanged : null,
      hint: Text(enabled ? 'Select $label' : 'Select department first'),
    );
  }

  Widget _buildCourseCard(Course course) {
    final isSelected = selectedCourseIds.contains(course.id);

    return GestureDetector(
      onTap: () => _toggleCourse(course.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFeff6ff) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF2563eb) : const Color(0xFFe5e7eb),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? const Color(0xFF2563eb) : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563eb)
                      : const Color(0xFFd1d5db),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        course.code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f2937),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.category.name.toUpperCase(),
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    course.name,
                    style: const TextStyle(color: Color(0xFF6b7280)),
                  ),
                ],
              ),
            ),
            Text(
              '${course.creditHours} hrs',
              style: const TextStyle(color: Color(0xFF9ca3af)),
            ),
          ],
        ),
      ),
    );
  }
}
