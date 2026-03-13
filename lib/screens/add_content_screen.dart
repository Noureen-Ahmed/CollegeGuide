import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/api_config.dart';
import '../providers/app_mode_provider.dart';
import '../providers/app_session_provider.dart';
import '../models/user.dart';
import '../services/data_service.dart';
import '../models/course.dart';

// ---- CONTENT TYPE ENUM ------------------------------------------------------

enum ContentType {
  assignment,
  lectureMaterial,
  announcement,
}

// ---- SCREEN -----------------------------------------------------------------

class AddContentScreen extends ConsumerStatefulWidget {
  const AddContentScreen({super.key});

  @override
  ConsumerState<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends ConsumerState<AddContentScreen> {
  // Content types + icons (for the chips)
  final Map<ContentType, String> _contentTypeLabels = {
    ContentType.assignment: 'Assignment',
    ContentType.lectureMaterial: 'Lecture Material',
    ContentType.announcement: 'Announcement',
  };

  final Map<ContentType, IconData> _contentTypeIcons = {
    ContentType.assignment: Icons.assignment_outlined,
    ContentType.lectureMaterial: Icons.menu_book_outlined,
    ContentType.announcement: Icons.campaign_outlined,
  };

  ContentType _selectedType = ContentType.assignment;

  // Courses
  List<Course> _courses = [];
  String? _selectedCourseId;
  bool _isLoading = true;
  bool _isSubmitting = false;

  // Mock busy dates for testing
  final Map<DateTime, String> _busyDates = {
    DateTime(2026, 1, 13): '4 students have an exam on this day',
    DateTime(2026, 1, 10): '50 students have an assignment on this day',
  };

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pointsController =
      TextEditingController(text: '100');

  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  // File attachments
  final List<String> _uploadedFiles = [];
  bool _isUploading = false;

  // When true we show "Deadline & Grading" section
  bool get _showDeadlineSection => _selectedType == ContentType.assignment;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final courses = await DataService.getProfessorCourses(user.email);
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoading = false;
          if (courses.isNotEmpty) {
            _selectedCourseId = courses.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickDueDate() async {
    DateTime tempDate = _dueDate ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final busyNote =
              _busyDates[DateTime(tempDate.year, tempDate.month, tempDate.day)];

          return AlertDialog(
            title: const Text('Select Date',
                style: TextStyle(color: Color(0xFF1D2B64))),
            content: SizedBox(
              width: 350,
              height: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TableCalendar(
                    firstDay:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now().add(const Duration(days: 365 * 5)),
                    focusedDay: tempDate,
                    selectedDayPredicate: (day) => isSameDay(tempDate, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setDialogState(() {
                        tempDate = selectedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFF7A6CF5),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF7A6CF5).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        for (var busyDate in _busyDates.keys) {
                          if (isSameDay(day, busyDate)) {
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        }
                        return null;
                      },
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                  const Spacer(),
                  if (busyNote != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 20, color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              busyNote,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _dueDate = tempDate;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A6CF5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDueTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _dueTime = picked);
    }
  }

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null) {
        setState(() => _isUploading = true);

        var request = http.MultipartRequest(
            'POST', Uri.parse('${ApiConfig.baseUrl}/upload'));

        final authHeader = ApiConfig.authHeaders['Authorization'];
        if (authHeader != null) {
          request.headers['Authorization'] = authHeader;
        }

        if (result.files.first.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            result.files.first.bytes!,
            filename: result.files.first.name,
          ));
        } else if (result.files.first.path != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            result.files.first.path!,
          ));
        }

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          if (data['success'] == true && data['fileUrl'] != null) {
            setState(() {
              _uploadedFiles.add(data['fileUrl']);
              _isUploading = false;
            });
            _showMessage('Uploaded: ${result.files.first.name}',
                isError: false);
          } else {
            throw Exception(data['message'] ?? 'Upload failed');
          }
        } else {
          throw Exception('Server error: ${response.statusCode}');
        }
      }
    } catch (e) {
      setState(() => _isUploading = false);
      _showMessage('Error uploading: $e', isError: true);
    }
  }

  void _removeFile(String url) {
    setState(() => _uploadedFiles.remove(url));
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty) {
      _showMessage('Please enter a title', isError: true);
      return;
    }
    if (_selectedCourseId == null) {
      _showMessage('Please select a course', isError: true);
      return;
    }
    if (_showDeadlineSection && _dueDate == null) {
      _showMessage('Please select a date', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    bool success = false;
    DateTime? finalDateTime;

    // Combine date and time
    if (_dueDate != null) {
      final time = _dueTime ?? const TimeOfDay(hour: 23, minute: 59);
      finalDateTime = DateTime(
        _dueDate!.year,
        _dueDate!.month,
        _dueDate!.day,
        time.hour,
        time.minute,
      );
    }

    try {
      switch (_selectedType) {
        case ContentType.lectureMaterial:
          success = await DataService.createContent(
            courseId: _selectedCourseId!,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            contentType: 'LECTURE',
            attachments: _uploadedFiles,
          );
          break;
        case ContentType.assignment:
          success = await DataService.createAssignment(
            courseId: _selectedCourseId!,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            dueDate: finalDateTime!,
            maxPoints: int.tryParse(_pointsController.text) ?? 100,
            attachments: _uploadedFiles,
          );
          break;
        case ContentType.announcement:
          success = await DataService.createAnnouncement(
            title: _titleController.text.trim(),
            message: _descriptionController.text.trim(),
            courseId: _selectedCourseId,
            type: 'GENERAL',
          );
          break;
      }
    } catch (e) {
      debugPrint('Error creating content: $e');
      success = false;
    }

    setState(() => _isSubmitting = false);

    if (success) {
      if (mounted) {
        _showMessage(
            '${_contentTypeLabels[_selectedType]} created! Students have been notified.',
            isError: false);
        _resetForm();
      }
    } else {
      if (mounted) {
        _showMessage(
            'Failed to create ${_contentTypeLabels[_selectedType]?.toLowerCase()}',
            isError: true);
      }
    }
  }

  void _resetForm() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _pointsController.text = '100';
      _dueDate = null;
      _dueTime = null;
      _uploadedFiles.clear();
    });
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appMode = ref.watch(appModeControllerProvider);

    // Access check
    if (appMode != AppMode.professor) {
      return _buildAccessDenied();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7A6CF5), // top purple
              Color(0xFF1D2B64), // bottom blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Content',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Share knowledge with your students',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Card body
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _courses.isEmpty
                          ? _buildNoCourses()
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildCourseSelector(),
                                  const SizedBox(height: 16),
                                  _buildContentTypeSection(),
                                  const SizedBox(height: 16),
                                  _buildDetailsSection(),
                                  const SizedBox(height: 16),
                                  if (_showDeadlineSection) ...[
                                    _buildDeadlineSection(),
                                    const SizedBox(height: 16),
                                  ],
                                  if (_selectedType !=
                                      ContentType.announcement) ...[
                                    _buildAttachmentSection(),
                                    const SizedBox(height: 16),
                                  ],
                                  _buildBottomButtons(),
                                  const SizedBox(height: 120),
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

  Widget _buildAccessDenied() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title:
            const Text('Access Denied', style: TextStyle(color: Colors.black)),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 80, color: Color(0xFF9CA3AF)),
            SizedBox(height: 16),
            Text(
              'Professor access required',
              style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCourses() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined,
                size: 64, color: Color(0xFF7A6CF5)),
            const SizedBox(height: 16),
            const Text(
              'No courses assigned',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact admin to get courses assigned to you.',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _whiteCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school, size: 18, color: Color(0xFF7A6CF5)),
              SizedBox(width: 6),
              Text(
                'Select Course',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedCourseId,
            isExpanded: true,
            decoration: _roundedFieldDecoration.copyWith(
              hintText: 'Choose a course',
            ),
            items: _courses
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(
                        '${c.code} - ${c.name}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedCourseId = v),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTypeSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _whiteCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Content Type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _contentTypeLabels.entries.map((entry) {
              final type = entry.key;
              final label = entry.value;
              final bool selected = type == _selectedType;

              return GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE7E5FF)
                        : const Color(0xFFF5F6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF7A6CF5)
                          : Colors.grey.shade300,
                      width: selected ? 1.6 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _contentTypeIcons[type],
                        size: 18,
                        color: selected
                            ? const Color(0xFF7A6CF5)
                            : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.black87,
                          fontSize: 13,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _whiteCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined,
                  size: 18, color: Color(0xFF26C2FF)),
              SizedBox(width: 6),
              Text('Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _titleController,
            decoration: _roundedFieldDecoration.copyWith(
              labelText: 'Title *',
              hintText: 'e.g., Week 5 Assignment - Data Structures',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: _roundedFieldDecoration.copyWith(
              labelText: 'Description',
              hintText: 'Provide detailed instructions or information...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineSection() {
    final dateText = _dueDate == null
        ? 'Select Date'
        : '${_dueDate!.day.toString().padLeft(2, '0')}/${_dueDate!.month.toString().padLeft(2, '0')}/${_dueDate!.year}';

    final busyInfo = _dueDate != null
        ? _busyDates[DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day)]
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _yellowCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, size: 18, color: Color(0xFFF6A400)),
              SizedBox(width: 6),
              Text('Scheduling',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _pickDueDate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 20, color: Color(0xFF7A6CF5)),
                    const SizedBox(width: 12),
                    Text(
                      dateText,
                      style: TextStyle(
                        color: _dueDate == null
                            ? Colors.grey.shade600
                            : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          if (busyInfo != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      busyInfo,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildTimePicker('Due Time', _dueTime, _pickDueTime),
          const SizedBox(height: 12),
          TextFormField(
            controller: _pointsController,
            keyboardType: TextInputType.number,
            decoration: _roundedFieldDecoration.copyWith(
              labelText: 'Total Points',
              hintText: 'e.g., 100',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: Color(0xFF7A6CF5)),
              const SizedBox(width: 12),
              Text(
                time == null ? label : time.format(context),
                style: TextStyle(
                  color: time == null ? Colors.grey.shade600 : Colors.black,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _whiteCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.attach_file, size: 18, color: Color(0xFF26C2FF)),
              SizedBox(width: 6),
              Text('Attachments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          if (_uploadedFiles.isNotEmpty)
            Column(
              children: _uploadedFiles.map((url) {
                final name = url.split('/').last.split('-').length > 1
                    ? url.split('/').last.split('-').skip(1).join('-')
                    : url.split('/').last;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF7A6CF5).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.insert_drive_file,
                          color: Color(0xFF7A6CF5)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            size: 20, color: Colors.red),
                        onPressed: () => _removeFile(url),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          GestureDetector(
            onTap: _isUploading ? null : _pickAndUploadFile,
            behavior: HitTestBehavior.opaque,
            child: _DottedBorderBox(
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined,
                            size: 34, color: Color(0xFF7A6CF5)),
                        SizedBox(height: 8),
                        Text(
                          'Click to upload or drag and drop',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'PDF, DOC, DOCX, PPT, PPTX (max 10MB)',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              foregroundColor: Colors.black87,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A6CF5),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              disabledBackgroundColor: const Color(0xFF7A6CF5).withOpacity(0.5),
            ),
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Text('Send',
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

// ---------- STYLES & SMALL WIDGETS -------------------------------------------

const BoxDecoration _whiteCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  boxShadow: [
    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
  ],
);

const BoxDecoration _yellowCardDecoration = BoxDecoration(
  color: Color(0xFFFFF1C7),
  borderRadius: BorderRadius.all(Radius.circular(16)),
  boxShadow: [
    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
  ],
);

const InputDecoration _roundedFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xFFF7F8FF),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    borderSide: BorderSide.none,
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
);

class _DottedBorderBox extends StatelessWidget {
  final Widget child;

  const _DottedBorderBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.withOpacity(0.4), width: 1.5),
      ),
      child: Center(child: child),
    );
  }
}
