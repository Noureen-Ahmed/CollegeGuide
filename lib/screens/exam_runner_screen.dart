import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../services/data_service.dart';
import '../providers/course_provider.dart';

class ExamRunnerScreen extends ConsumerStatefulWidget {
  final String taskId;
  final String courseId; // For invalidating cache on exit
  
  const ExamRunnerScreen({
    super.key,
    required this.taskId,
    required this.courseId,
  });

  @override
  ConsumerState<ExamRunnerScreen> createState() => _ExamRunnerScreenState();
}

class _ExamRunnerScreenState extends ConsumerState<ExamRunnerScreen> {
  Task? _task;
  bool _isLoading = true;
  String? _error;
  
  // Exam State
  bool _isExamStarted = false;
  int _currentQuestionIndex = 0;
  Map<String, dynamic> _answers = {}; // questionId -> value
  DateTime? _startTime;
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  
  // Submission
  bool _isSubmitting = false;
  String? _uploadedFileUrl; 
  String? _uploadedFileName;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchTask();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTask() async {
    try {
      final task = await DataService.getTask(widget.taskId);
      if (task == null) throw Exception('Exam not found');
      
      // Check SharedPreferences for existing start time
      final prefs = await SharedPreferences.getInstance();
      final startTimeMillis = prefs.getInt('exam_start_${widget.taskId}');
      
      final durationMins = (task.settings != null && task.settings!.containsKey('durationMinutes'))
          ? task.settings!['durationMinutes'] as int
          : 60;
      final totalDuration = Duration(minutes: durationMins);

      bool alreadyStarted = false;
      Duration remaining = totalDuration;

      if (startTimeMillis != null) {
        final savedStartTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
        final elapsed = DateTime.now().difference(savedStartTime);
        remaining = totalDuration - elapsed;
        alreadyStarted = true;
        
        if (remaining.isNegative) {
           // Time expired while away
           _timeLeft = Duration.zero;
           _task = task;
           _isExamStarted = true; // Show UI but immediately submit
           WidgetsBinding.instance.addPostFrameCallback((_) {
             _submitExam(autoSubmit: true);
           });
           return;
        }
      }
      
      setState(() {
        _task = task;
        _isLoading = false;
        
        // Restore answers if any
         if (task.submission?['answers'] != null) {
           _answers = Map<String, dynamic>.from(task.submission!['answers']);
         }
         
         if (alreadyStarted) {
           _timeLeft = remaining;
           _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis!);
           _isExamStarted = true;
           _startTimer();
         } else {
           _timeLeft = totalDuration;
         }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _beginExam() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setInt('exam_start_${widget.taskId}', now.millisecondsSinceEpoch);
    
    setState(() {
      _startTime = now;
      _isExamStarted = true;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        _submitExam(autoSubmit: true);
      }
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(body: Center(child: Text('Error: $_error')));
    if (_task == null) return const Scaffold(body: Center(child: Text('Exam not found')));

    // START SCREEN
    if (!_isExamStarted) {
      final questions = _task!.questions ?? [];
      final durationMins = (_task!.settings != null && _task!.settings!.containsKey('durationMinutes'))
          ? _task!.settings!['durationMinutes']
          : 60;
          
      return Scaffold(
        appBar: AppBar(title: Text(_task!.title), automaticallyImplyLeading: true),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.timer_outlined, size: 80, color: Color(0xFF2E6AFF)),
              const SizedBox(height: 24),
              Text(
                _task!.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you ready to start the exam? Once you begin, the timer will start and cannot be paused.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Duration:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$durationMins minutes'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Questions:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${questions.length}'),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _beginExam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6AFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start Exam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    final questions = _task!.questions ?? [];
    if (questions.isEmpty) return const Scaffold(body: Center(child: Text('No questions in this exam')));

    return Scaffold(
      appBar: AppBar(
        title: Text(_task!.title),
        automaticallyImplyLeading: false, // Prevent accidental back
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _timeLeft.inMinutes < 5 ? Colors.red[50] : Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _timeLeft.inMinutes < 5 ? Colors.red : Colors.blue,
              )
            ),
            child: Row(
              children: [
                Icon(Icons.timer, 
                  color: _timeLeft.inMinutes < 5 ? Colors.red : Colors.blue, 
                  size: 20
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(_timeLeft),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _timeLeft.inMinutes < 5 ? Colors.red : Colors.blue,
                    fontSize: 16
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E6AFF)),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Number
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  
                  // Question Image
                  if (questions[_currentQuestionIndex]['imageUrl'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: Image.network(
                            questions[_currentQuestionIndex]['imageUrl'],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                      SizedBox(height: 8),
                                      Text('Image failed to load', style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                  // Question Text
                  Text(
                    questions[_currentQuestionIndex]['text'] ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${questions[_currentQuestionIndex]['points'] ?? 0} points',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Answers Input
                  _buildAnswerInput(questions[_currentQuestionIndex]),
                  
                  const SizedBox(height: 80), // Extra padding
                  
                  // Attachments removed per user request
                ],
              ),
            ),
          ),
          
          // Navigation Bar
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // Previous Button
                   if (_currentQuestionIndex > 0)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _currentQuestionIndex--),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    )
                   else
                    const SizedBox(width: 100), // Spacer for alignment

                   // Next / Submit Button
                   if (_currentQuestionIndex < questions.length - 1)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _currentQuestionIndex++),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6AFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    )
                   else
                    ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitExam,
                      icon: _isSubmitting 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.check_circle),
                      label: const Text('Submit Exam'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(Map<String, dynamic> question) {
    final type = question['type'] ?? 'TEXT';
    final questionId = question['id'] ?? _currentQuestionIndex.toString();
    final currentAnswer = _answers[questionId];

    if (type == 'MCQ') {
      final options = List<String>.from(question['options'] ?? []);
      return Column(
        children: options.map((option) {
          final isSelected = currentAnswer == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _answers[questionId] = option;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2E6AFF) : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? const Color(0xFF2E6AFF) : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(option, style: const TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if (type == 'TRUE_FALSE') {
      return Column(
        children: ['true', 'false'].map((option) {
          final isSelected = currentAnswer == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _answers[questionId] = option;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? (option == 'true' ? Colors.green[50] : Colors.red[50]) : Colors.white,
                  border: Border.all(
                    color: isSelected 
                      ? (option == 'true' ? Colors.green : Colors.red) 
                      : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected 
                        ? (option == 'true' ? Colors.green : Colors.red)
                        : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      option == 'true' ? 'True' : 'False',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected 
                          ? (option == 'true' ? Colors.green : Colors.red)
                          : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Short Answer
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextFormField(
          initialValue: currentAnswer?.toString(),
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Type your answer here...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
          onChanged: (val) {
            _answers[questionId] = val;
            // No setState needed for text input to keep focus
          },
        ),
      );
    }
  }

  Widget _buildFileUploader() {
    return InkWell(
      onTap: _isUploading ? null : _pickAndUploadFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF2E6AFF).withOpacity(0.3), 
            style: BorderStyle.solid
          ),
        ),
        child: _isUploading
          ? const Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)))
          : Row(
              children: [
                const Icon(Icons.attach_file, color: Color(0xFF2E6AFF)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _uploadedFileName ?? 'Attach File',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E6AFF)),
                      ),
                      if (_uploadedFileName == null)
                        const Text('Click to upload', style: TextStyle(fontSize: 12, color: Colors.grey))
                    ],
                  ),
                ),
                if (_uploadedFileName != null)
                   IconButton(
                     icon: const Icon(Icons.close, color: Colors.red),
                     onPressed: () {
                       setState(() {
                         _uploadedFileUrl = null;
                         _uploadedFileName = null;
                       });
                     },
                   )
              ],
            ),
      ),
    );
  }
  
  Future<void> _pickAndUploadFile() async {
    setState(() => _isUploading = true);
    
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'zip'],
      );

      if (result != null && result.files.single.bytes != null) {
        final file = result.files.single;
        final url = await DataService.uploadFile(file.bytes!, file.name);
        
        if (url != null) {
          setState(() {
            _uploadedFileUrl = url;
            _uploadedFileName = file.name;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully')),
          );
        } else {
          throw Exception('Upload failed');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _submitExam({bool autoSubmit = false}) async {
    // If autoSubmit is true (timer ran out), we proceed even if incomplete
    // Validation removed per user request - allow incomplete submission
    // We only rely on autoSubmit flag for logging or toast nuance if needed
    
    
    setState(() => _isSubmitting = true);
    
    final success = await DataService.submitTask(
      taskId: widget.taskId,
      answers: _answers,
      fileUrl: _uploadedFileUrl,
      startedAt: _startTime,
    );
    
    if (success) {
      if (mounted) {
         if (autoSubmit) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Time is up! Exam submitted.')));
         } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam submitted successfully!')));
         }
         
         // Invalidate course cache to refresh task status
         ref.invalidate(courseByIdProvider(widget.courseId));
         
         // Pop back
         if (context.canPop()) {
           context.pop();
         } else {
           context.go('/home');
         }
      }
    } else {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit exam. Please try again.')));
      }
    }
  }
}
