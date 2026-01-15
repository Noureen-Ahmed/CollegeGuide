import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../core/api_config.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/app_session_provider.dart';
import '../services/data_service.dart';

class AssignmentDetailScreen extends ConsumerStatefulWidget {
  final Task task;

  const AssignmentDetailScreen({super.key, required this.task});

  @override
  ConsumerState<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends ConsumerState<AssignmentDetailScreen> {
  late Task _task;
  bool _isUploading = false;
  bool _isSubmitting = false;
  String? _uploadedFileUrl;
  String? _uploadedFileName;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _initializeSubmissionData();
    _fetchTaskDetails();
  }

  void _initializeSubmissionData() {
    if (_task.submission != null) {
      _uploadedFileUrl = _task.submission!['fileUrl'];
      _notesController.text = _task.submission!['notes'] ?? '';
    }
  }

  Future<void> _fetchTaskDetails() async {
    final fullTask = await DataService.getTask(widget.task.id);
    if (fullTask != null && mounted) {
      setState(() {
        _task = fullTask;
        _initializeSubmissionData();
      });
    }
  }

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'zip'],
      );

      if (result != null) {
        setState(() => _isUploading = true);

        final bytes = result.files.first.bytes;
        final name = result.files.first.name;

        if (bytes == null) {
          throw Exception("File bytes are null");
        }

        // Upload to API
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConfig.baseUrl}/upload?type=submission'),
        );
        
        request.headers.addAll(ApiConfig.authHeaders);
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: name,
          ),
        );

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _uploadedFileUrl = data['fileUrl'];
            _uploadedFileName = name;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully')),
          );
        } else {
          throw Exception('Upload failed: ${response.body}');
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

  Future<void> _submitAssignment() async {
    if (_uploadedFileUrl == null && _notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please attach a file or add notes.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await DataService.submitTask(
      taskId: _task.id,
      fileUrl: _uploadedFileUrl,
      notes: _notesController.text,
    );

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assignment submitted successfully!')),
      );
      ref.invalidate(tasksProvider); // Refresh task list
      _fetchTaskDetails(); // Refresh local details
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submission failed. Please try again.')),
      );
    }
  }

  Future<void> _unsubmitAssignment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsubmit Assignment?'),
        content: const Text('Your current submission will be removed. You can then submit a new version.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Unsubmit'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);

    final success = await DataService.unsubmitTask(_task.id);

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submission removed.')),
      );
      // Reset local submission state
      setState(() {
        _uploadedFileUrl = null;
        _uploadedFileName = null;
        _notesController.clear();
      });
      ref.invalidate(tasksProvider); // Refresh task list
      _fetchTaskDetails(); // Refresh local details
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove submission.')),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat('MMM d, y • h:mm a').format(date);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitted = _task.status == TaskStatus.submitted || _task.status == TaskStatus.graded;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Assignment Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTaskDetails,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _task.status == TaskStatus.graded 
                      ? Colors.green.withOpacity(0.1)
                      : isSubmitted 
                          ? Colors.blue.withOpacity(0.1) 
                          : const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _task.status == TaskStatus.graded 
                      ? Colors.green
                      : isSubmitted ? Colors.blue : const Color(0xFF2E6AFF),
                    width: 1
                  )
                ),
                child: Text(
                  _task.status == TaskStatus.graded 
                      ? 'Graded' 
                      : isSubmitted ? 'Submitted' : 'Assigned',
                  style: TextStyle(
                    color: _task.status == TaskStatus.graded 
                      ? Colors.green 
                      : isSubmitted ? Colors.blue : const Color(0xFF2E6AFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Title
              Text(
                _task.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Course & Due Date
              Row(
                children: [
                  Text(
                    _task.subject,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('•', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(_task.dueDate),
                    style: TextStyle(
                      color: (_task.dueDate != null && 
                             _task.dueDate!.isBefore(DateTime.now()) && 
                             !isSubmitted)
                          ? Colors.red 
                          : Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Description
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _task.description ?? 'No instructions provided.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Attachments
              if (_task.attachments.isNotEmpty) ...[
                const Text(
                  'Reference Materials',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._task.attachments.map((url) => InkWell(
                  onTap: () => _launchUrl(url),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.description, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            url.split('/').last,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 24),
              ],
              
              const Divider(height: 48),
              
              // ROLE BASED VIEW
              if (ref.watch(currentUserProvider).value?.isProfessor ?? false) ...[
                const Text(
                  'Student Submissions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        '/grading/${_task.id}',
                        extra: {
                          'title': _task.title,
                          'maxPoints': 100, // Default to 100 as Task model doesn't have it yet
                        },
                      );
                    },
                    icon: const Icon(Icons.grading),
                    label: const Text('View All Submissions'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF2E6AFF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                 // SUBMISSION SECTION (STUDENT)
                const Text(
                  'Your Work',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (isSubmitted) _buildSubmittedView() else _buildSubmissionForm(),
              ],
              
              const SizedBox(height: 120), // Extra padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmittedView() {
    final submittedFile = _task.submission?['fileUrl'];
    final notes = _task.submission?['notes'];
    final submittedAtRaw = _task.submission?['submittedAt'] ?? _task.submission?['createdAt'];
    final submittedAt = submittedAtRaw != null ? DateTime.tryParse(submittedAtRaw.toString()) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (submittedAt != null)
           Text(
            'Submitted on ${_formatDate(submittedAt)}',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
          ),
        const SizedBox(height: 12),
        if (submittedFile != null)
          InkWell(
            onTap: () => _launchUrl(submittedFile),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50], 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      submittedFile.toString().split('/').last,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const Text('No file attached'),
          
        if (notes != null && notes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Notes:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(notes),
        ],
        
        if (_task.submission != null && (_task.submission!['points'] != null || _task.submission!['grade'] != null)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.grade, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Grade: ${_task.submission!['grade'] ?? _task.submission!['points']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),
                    ),
                  ],
                ),
                if (_task.submission!['feedback'] != null && _task.submission!['feedback'].isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(color: Colors.green),
                  const SizedBox(height: 8),
                  Text(
                    'Feedback: ${_task.submission!['feedback']}',
                    style: TextStyle(color: Colors.green[900]),
                  ),
                ],
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),
        if (_task.status != TaskStatus.graded)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: (_isUploading || _isSubmitting) ? null : _unsubmitAssignment,
              child: const Text('Unsubmit'),
            ),
          )
      ],
    );
  }

  Widget _buildSubmissionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File Upload Area
        InkWell(
          onTap: _isUploading ? null : _pickAndUploadFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!, 
                style: BorderStyle.solid
              ),
            ),
            child: _isUploading
                ? const Center(child: CircularProgressIndicator())
                : _uploadedFileUrl != null
                    ? Column(
                        children: [
                          const Icon(Icons.insert_drive_file, size: 40, color: Color(0xFF2E6AFF)),
                          const SizedBox(height: 8),
                          Text(
                            _uploadedFileName ?? _uploadedFileUrl!.split('/').last,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text('Tap to change', style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : const Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Add Attachment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E6AFF),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Notes
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add private comments...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isUploading || _isSubmitting)
                ? null
                : _submitAssignment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Turn in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
