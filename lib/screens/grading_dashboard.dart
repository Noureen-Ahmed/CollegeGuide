import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/data_service.dart';
import '../widgets/user_avatar.dart';

import '../models/task.dart';
import 'exam_grading_screen.dart';

class GradingDashboard extends ConsumerStatefulWidget {
  final String taskId;
  final String taskTitle;
  final int maxPoints;

  const GradingDashboard({
    super.key,
    required this.taskId,
    required this.taskTitle,
    this.maxPoints = 100,
  });

  @override
  ConsumerState<GradingDashboard> createState() => _GradingDashboardState();
}

class _GradingDashboardState extends ConsumerState<GradingDashboard> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _submissions = [];
  Task? _task;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final futures = await Future.wait([
        DataService.getTaskSubmissions(widget.taskId),
        DataService.getTask(widget.taskId)
      ]);

      final submissions = futures[0] as List<Map<String, dynamic>>;
      final task = futures[1] as Task?;

      if (mounted) {
        setState(() {
          _submissions = submissions;
          _task = task;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load data';
        });
      }
    }
  }

  Future<void> _loadSubmissions() async {
    try {
      final submissions = await DataService.getTaskSubmissions(widget.taskId);
      if (mounted) {
        setState(() {
          _submissions = submissions;
        });
      }
    } catch (e) {
      // quiet fail on reload
    }
  }

  Future<void> _openFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open file')),
        );
      }
    }
  }

  void _showGradingDialog(Map<String, dynamic> submission) async {
    // If it's an exam (has answers), go to detailed grading screen
    if (submission['answers'] != null) {
      if (_task == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exam data not loaded')));
        return;
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamGradingScreen(
            submission: submission,
            task: _task!,
          ),
        ),
      );

      if (result == true) {
        _loadSubmissions();
      }
      return;
    }

    final pointsController =
        TextEditingController(text: submission['points']?.toString() ?? '');
    final feedbackController =
        TextEditingController(text: submission['feedback'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Grade Submission'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Info
              Row(
                children: [
                  UserAvatar(
                    name: submission['student']['name'] ?? 'S',
                    avatarUrl: submission['student']['avatar'],
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(submission['student']['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(submission['student']['email'],
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Submission Link
              if (submission['fileUrl'] != null)
                ListTile(
                  leading: const Icon(Icons.attach_file, color: Colors.blue),
                  title: const Text('View Submission File',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)),
                  onTap: () => _openFile(submission['fileUrl']),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),

              if (submission['notes'] != null && submission['notes'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(submission['notes']),
                  ),
                ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Grade Input
              TextField(
                controller: pointsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Points (Max: ${widget.maxPoints})',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Feedback Input
              TextField(
                controller: feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Feedback (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final points = double.tryParse(pointsController.text);
              if (points == null || points < 0 || points > widget.maxPoints) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid points')),
                );
                return;
              }

              final success = await DataService.gradeSubmission(
                submissionId: submission['id'],
                points: points,
                feedback: feedbackController.text,
              );

              if (mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Grade saved!'),
                        backgroundColor: Colors.green),
                  );
                  _loadSubmissions(); // Reload
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to save grade'),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Save Grade'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradedCount =
        _submissions.where((s) => s['status'] == 'GRADED').length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grading Dashboard', style: TextStyle(fontSize: 16)),
            Text(widget.taskTitle,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _submissions.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        // Stats Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat('Total',
                                  _submissions.length.toString(), Colors.blue),
                              _buildStat(
                                  'Graded',
                                  '$gradedCount/${_submissions.length}',
                                  Colors.green),
                              _buildStat(
                                  'Pending',
                                  (_submissions.length - gradedCount)
                                      .toString(),
                                  Colors.orange),
                            ],
                          ),
                        ),

                        // List
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _submissions.length,
                            separatorBuilder: (c, i) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final sub = _submissions[index];
                              return _buildSubmissionCard(sub);
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined,
              size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No submissions yet',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSubmissionCard(Map<String, dynamic> submission) {
    final student = submission['student'];
    final isGraded = submission['status'] == 'GRADED';
    final submittedDate = DateTime.parse(submission['submittedAt']);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showGradingDialog(submission),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              UserAvatar(
                name: student['name'],
                avatarUrl: student['avatar'],
                size: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      DateFormat('MMM d, h:mm a').format(submittedDate),
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isGraded ? Colors.green[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isGraded
                              ? Colors.green[100]!
                              : Colors.orange[100]!),
                    ),
                    child: Text(
                      isGraded
                          ? '${submission['points']} / ${widget.maxPoints}'
                          : 'Pending',
                      style: TextStyle(
                        color:
                            isGraded ? Colors.green[700] : Colors.orange[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
