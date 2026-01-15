import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/data_service.dart';
import '../providers/app_session_provider.dart';
import '../models/course.dart';

class CreateExamScreen extends ConsumerStatefulWidget {
  final String? courseId;

  const CreateExamScreen({super.key, this.courseId});

  @override
  ConsumerState<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends ConsumerState<CreateExamScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Courses for selection
  List<Course> _courses = [];
  String? _selectedCourseId;
  bool _isLoadingCourses = true;
  
  // Basic Info
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _examDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _examTime = const TimeOfDay(hour: 10, minute: 0);
  int _durationMinutes = 60;
  
  // Questions
  final List<Map<String, dynamic>> _questions = [];
  
  // Settings
  bool _shuffleQuestions = false;
  bool _showResultsImmediately = false;
  bool _isPublished = false;
  
  bool _isLoading = false;
  
  // Exam conflicts: dates where students have exams in other courses
  Map<DateTime, int> _examConflicts = {};
  
  @override
  void initState() {
    super.initState();
    _loadCourses();
  }
  
  Future<void> _loadCourses() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      setState(() => _isLoadingCourses = false);
      return;
    }
    
    try {
      final courses = await DataService.getProfessorCourses(user.email);
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoadingCourses = false;
          // If courseId was provided via widget, use it
          if (widget.courseId != null) {
            _selectedCourseId = widget.courseId;
          } else if (courses.isNotEmpty) {
            _selectedCourseId = courses.first.id;
          }
        });
        // Load conflicts for the selected course
        if (_selectedCourseId != null) {
          _loadExamConflicts(_selectedCourseId!);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCourses = false);
      }
    }
  }

  Future<void> _loadExamConflicts(String courseId) async {
    final conflicts = await DataService.getExamConflicts(courseId);
    if (mounted) {
      setState(() => _examConflicts = conflicts);
    }
  }

  Future<void> _showExamDatePicker() async {
    DateTime tempDate = _examDate;
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final normalizedTemp = DateTime(tempDate.year, tempDate.month, tempDate.day);
          final conflictCount = _examConflicts[normalizedTemp];
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          
          return AlertDialog(
            title: const Text('Select Exam Date', style: TextStyle(color: Color(0xFF002147), fontSize: 16)),
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.9,
                maxHeight: screenHeight * 0.6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: tempDate,
                      selectedDayPredicate: (day) => isSameDay(tempDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setDialogState(() {
                          tempDate = selectedDay;
                        });
                      },
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFF002147),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Color(0x55002147),
                          shape: BoxShape.circle,
                        ),
                        cellMargin: EdgeInsets.all(2),
                      ),
                      rowHeight: 40,
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final normalizedDay = DateTime(day.year, day.month, day.day);
                          if (_examConflicts.containsKey(normalizedDay)) {
                            return Container(
                              margin: const EdgeInsets.all(2.0),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        headerPadding: EdgeInsets.symmetric(vertical: 8),
                        titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (conflictCount != null && conflictCount > 0)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$conflictCount student${conflictCount > 1 ? 's' : ''} have exam in this day',
                                style: const TextStyle(
                                  fontSize: 12,
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
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _examDate = tempDate;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002147),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingCourses) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Exam'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_courses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Exam'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
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
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Create Exam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF002147)))
        : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCourseSelector(),
                const SizedBox(height: 24),
                _buildBasicInfoSection(),
                const SizedBox(height: 24),
                _buildQuestionsSection(),
                const SizedBox(height: 24),
                _buildSettingsSection(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 120), // Extra padding for bottom nav
              ],
            ),
          ),
    );
  }
  
  Widget _buildCourseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCourseId,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.school),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: _courses.map((c) => DropdownMenuItem(
            value: c.id,
            child: Text(
              '${c.code} - ${c.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )).toList(),
          onChanged: (v) {
            setState(() => _selectedCourseId = v);
            if (v != null) _loadExamConflicts(v);
          },
          validator: (v) => v == null ? 'Please select a course' : null,
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Exam Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Exam Title',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Instructions)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _showExamDatePicker(),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('MMM d, y').format(_examDate)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _examTime,
                  );
                  if (time != null) {
                    setState(() => _examTime = time);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(_examTime.format(context)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _durationMinutes,
          decoration: const InputDecoration(
            labelText: 'Duration',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.timer),
          ),
          items: [30, 45, 60, 90, 120, 180].map((m) => DropdownMenuItem(
            value: m,
            child: Text('$m minutes'),
          )).toList(),
          onChanged: (v) => setState(() => _durationMinutes = v!),
        ),
      ],
    );
  }
  
  Widget _buildQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${_questions.length} questions • ${_calculateTotalPoints()} pts', 
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 16),
        if (_questions.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.quiz_outlined, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text('No questions added yet', 
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Click "Add Question" to start building your exam',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
          )
        else
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _questions.removeAt(oldIndex);
                _questions.insert(newIndex, item);
              });
            },
            children: [
              for (int i = 0; i < _questions.length; i++)
                _buildQuestionCard(i, _questions[i]),
            ],
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showAddQuestionDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Question'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index, Map<String, dynamic> question) {
    return Card(
      key: ValueKey(question['id'] ?? index), // Use ID if available, else index
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50], 
          child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ),
        title: Text(question['text'], maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${question['type']} • ${question['points']} pts'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => _editQuestion(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _questions.removeAt(index)),
            ),
            const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsSection() {
    // Check if there are any written/TEXT questions
    final hasWrittenQuestions = _questions.any((q) => q['type'] == 'TEXT');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF002147)),
              SizedBox(width: 8),
              Text('Exam Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Shuffle Questions'),
            subtitle: const Text('Randomize question order for each student'),
            value: _shuffleQuestions,
            onChanged: (v) => setState(() => _shuffleQuestions = v),
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFF002147),
          ),
          // Only show if there are NO written questions (auto-grading only works for MCQ/True-False)
          if (!hasWrittenQuestions)
            SwitchListTile(
              title: const Text('Show Results Immediately'),
              subtitle: const Text('Allow students to see their score after submission'),
              value: _showResultsImmediately,
              onChanged: (v) => setState(() => _showResultsImmediately = v),
              contentPadding: EdgeInsets.zero,
              activeColor: const Color(0xFF002147),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF856404), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This exam contains written questions and requires manual grading.',
                      style: TextStyle(color: Color(0xFF856404), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          SwitchListTile(
            title: const Text('Publish Immediately'),
            subtitle: const Text('Make visible to students now'),
            value: _isPublished,
            onChanged: (v) => setState(() => _isPublished = v),
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFF002147),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitExam,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFF002147),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Create Exam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
  
  int _calculateTotalPoints() {
    return _questions.fold(0, (sum, q) => sum + (q['points'] as int? ?? 0));
  }
  
  void _showAddQuestionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Question Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF002147))),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.list, color: Colors.blue),
                ),
                title: const Text('Multiple Choice', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Students select one correct answer', style: TextStyle(fontSize: 12, color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  _openQuestionEditor(type: 'MCQ');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle_outline, color: Colors.green),
                ),
                title: const Text('True / False', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Students answer True or False', style: TextStyle(fontSize: 12, color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  _openQuestionEditor(type: 'TRUE_FALSE');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_note, color: Colors.orange),
                ),
                title: const Text('Written Answer', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Free-text answer, requires manual grading', style: TextStyle(fontSize: 12, color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  _openQuestionEditor(type: 'TEXT');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  void _editQuestion(int index) {
    _openQuestionEditor(
      type: _questions[index]['type'],
      initialData: _questions[index],
      editIndex: index,
    );
  }
  
  void _openQuestionEditor({required String type, Map<String, dynamic>? initialData, int? editIndex}) {
    showDialog(
      context: context,
      builder: (context) => _QuestionEditorDialog(
        type: type,
        initialData: initialData,
        onSave: (question) {
          setState(() {
            if (editIndex != null) {
              _questions[editIndex] = question;
            } else {
              _questions.add(question);
            }
          });
        },
      ),
    );
  }
  
  Future<void> _submitExam() async {
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one question')));
      return;
    }
    
    setState(() => _isLoading = true);
    
    final examDateTime = DateTime(
      _examDate.year,
      _examDate.month,
      _examDate.day,
      _examTime.hour,
      _examTime.minute,
    );
    
    final success = await DataService.createExam(
      courseId: _selectedCourseId!,
      title: _titleController.text,
      description: _descriptionController.text,
      examDate: examDateTime,
      maxPoints: _calculateTotalPoints(),
      questions: _questions,
      settings: {
        'durationMinutes': _durationMinutes,
        'shuffleQuestions': _shuffleQuestions,
        'showResultsImmediately': _showResultsImmediately,
      },
      published: _isPublished,
    );
    
    setState(() => _isLoading = false);
    
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exam created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Use GoRouter's go instead of Navigator.pop to avoid navigation stack issues
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create exam. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _QuestionEditorDialog extends StatefulWidget {
  final String type;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;

  const _QuestionEditorDialog({required this.type, this.initialData, required this.onSave});

  @override
  State<_QuestionEditorDialog> createState() => _QuestionEditorDialogState();
}

class _QuestionEditorDialogState extends State<_QuestionEditorDialog> {
  late TextEditingController _textController;
  late TextEditingController _pointsController;
  List<TextEditingController> _optionControllers = [];
  String? _correctAnswer;
  String? _imageUrl;
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialData?['text'] ?? '');
    _pointsController = TextEditingController(text: (widget.initialData?['points'] ?? 5).toString());
    _imageUrl = widget.initialData?['imageUrl'];
    
    if (widget.type == 'MCQ') {
      final options = widget.initialData?['options'] as List?;
      if (options != null) {
        _optionControllers = options.map((o) => TextEditingController(text: o.toString())).toList();
        // Restore correct answer index if available
        if (widget.initialData?['correctAnswerIndex'] != null) {
          _correctAnswer = widget.initialData!['correctAnswerIndex'].toString();
        } else if (widget.initialData?['correctAnswer'] != null) {
          // Fallback: find index by matching the correct answer text
          final correctText = widget.initialData!['correctAnswer'].toString();
          final idx = options.indexWhere((o) => o.toString() == correctText);
          if (idx >= 0) {
            _correctAnswer = idx.toString();
          }
        }
      } else {
        _optionControllers = [TextEditingController(), TextEditingController()]; // Start with 2 empty options
      }
    } else if (widget.type == 'TRUE_FALSE') {
      // Correct answer is 'true' or 'false' boolean string
      _correctAnswer = widget.initialData?['correctAnswer']?.toString() ?? 'true';
    }
  }

  Future<void> _pickImage() async {
    setState(() => _isLoadingImage = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        final file = result.files.single;
        final url = await DataService.uploadFile(file.bytes!, file.name);
        
        if (url != null) {
          setState(() {
            _imageUrl = url;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialData == null ? 'Add ${widget.type} Question' : 'Edit Question'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Question Text', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            
            // Image Upload Section
            if (_imageUrl != null)
              Stack(
                children: [
                   Container(
                     height: 150,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey[300]!),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(8),
                       child: Image.network(_imageUrl!, fit: BoxFit.cover),
                     ),
                   ),
                   Positioned(
                     top: 4,
                     right: 4,
                     child: GestureDetector(
                       onTap: () => setState(() => _imageUrl = null),
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                         child: const Icon(Icons.close, size: 16, color: Colors.black),
                       ),
                     ),
                   ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: _isLoadingImage ? null : _pickImage,
                icon: _isLoadingImage 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.image),
                label: Text(_isLoadingImage ? 'Uploading...' : 'Add Image'),
                style: OutlinedButton.styleFrom(
                   minimumSize: const Size(double.infinity, 44),
                ),
              ),
              
            const SizedBox(height: 12),

            TextField(
              controller: _pointsController,
              decoration: const InputDecoration(labelText: 'Points', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            if (widget.type == 'MCQ') ...[
              const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...List.generate(_optionControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: index.toString(), // Store index as correct answer for simplicity? Or the text? 
                        // Let's store the actual text or index. Index is safer if text changes.
                        // But Data model plan said "text". Let's stick to text or index. 0-based index string "0", "1".
                        groupValue: _correctAnswer,
                        onChanged: (v) => setState(() => _correctAnswer = v),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Option ${index + 1}',
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                        onPressed: () {
                          if (_optionControllers.length > 2) {
                            setState(() {
                              _optionControllers.removeAt(index);
                              // Reset correct answer if invalid
                              if (_correctAnswer == index.toString()) _correctAnswer = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () => setState(() => _optionControllers.add(TextEditingController())),
                icon: const Icon(Icons.add),
                label: const Text('Add Option'),
              ),
            ] else if (widget.type == 'TRUE_FALSE') ...[
              const Text('Correct Answer:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('True'),
                      value: 'true',
                      groupValue: _correctAnswer,
                      onChanged: (v) => setState(() => _correctAnswer = v),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('False'),
                      value: 'false',
                      groupValue: _correctAnswer,
                      onChanged: (v) => setState(() => _correctAnswer = v),
                    ),
                  ),
                ],
              ),
            ] else if (widget.type == 'TEXT') ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Written answers are free-form text responses. You will grade these manually after students submit.',
                        style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
  
  void _save() {
    // Validate question text
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter question text'), backgroundColor: Colors.red),
      );
      return;
    }
    
    // Validate points
    final points = int.tryParse(_pointsController.text) ?? 0;
    if (points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Points must be greater than 0'), backgroundColor: Colors.red),
      );
      return;
    }
    
    final question = {
      'id': widget.initialData?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'type': widget.type,
      'text': _textController.text,
      'imageUrl': _imageUrl,
      'points': points,
    };
    
    if (widget.type == 'MCQ') {
      final options = _optionControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList();
      
      // Validate at least 2 options
      if (options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MCQ requires at least 2 options'), backgroundColor: Colors.red),
        );
        return;
      }
      
      // Validate correct answer is selected
      if (_correctAnswer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select the correct answer'), backgroundColor: Colors.red),
        );
        return;
      }
      
      final idx = int.tryParse(_correctAnswer!);
      if (idx == null || idx >= options.length || options[idx].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a valid correct answer'), backgroundColor: Colors.red),
        );
        return;
      }
      
      question['options'] = options;
      question['correctAnswer'] = options[idx];
      question['correctAnswerIndex'] = idx; // Store index for editing
      
    } else if (widget.type == 'TRUE_FALSE') {
      // Validate correct answer is selected
      if (_correctAnswer == null || (_correctAnswer != 'true' && _correctAnswer != 'false')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select True or False as the correct answer'), backgroundColor: Colors.red),
        );
        return;
      }
      question['correctAnswer'] = _correctAnswer;
    }
    // TEXT type doesn't need correctAnswer - it's manually graded
    
    widget.onSave(question);
    Navigator.pop(context);
  }
}
