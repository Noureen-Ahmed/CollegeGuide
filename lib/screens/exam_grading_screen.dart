import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/task.dart';
import '../widgets/user_avatar.dart';

class ExamGradingScreen extends StatefulWidget {
  final Map<String, dynamic> submission;
  final Task task;

  const ExamGradingScreen({
    super.key,
    required this.submission,
    required this.task,
  });

  @override
  State<ExamGradingScreen> createState() => _ExamGradingScreenState();
}

class _ExamGradingScreenState extends State<ExamGradingScreen> {
  final Map<String, double> _points = {}; // questionId -> points given
  double _totalScore = 0;
  bool _isSaving = false;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeGrading();
    _feedbackController.text = widget.submission['feedback'] ?? '';
  }

  void _initializeGrading() {
    // Initialize points from submission or auto-grade logic
    final questions = widget.task.questions ?? [];
    final answers = widget.submission['answers'] as Map<String, dynamic>? ?? {};

    // If already graded, we might not have per-question scores stored (schema limitation phase 1)
    // So we re-calculate or default to max points if correct

    for (var q in questions) {
      final qId = q['id'].toString();
      final maxPoints = (q['points'] as num?)?.toDouble() ?? 0.0;
      final type = q['type'];
      final correctAnswer = q['correctAnswer'];
      final studentAnswer = answers[qId]?.toString();

      // Default logic: if correct, full points. Else 0.
      // This serves as initial state for the grader
      if (type != 'TEXT' &&
          correctAnswer != null &&
          studentAnswer == correctAnswer) {
        _points[qId] = maxPoints;
      } else {
        _points[qId] = 0.0;
      }
    }

    // If the submission has a total score that differs significantly from auto-calc,
    // it implies manual overrides happened.
    // ideally we'd store per-question grades in the DB, but for now we simple re-calc.
    _calculateTotal();
  }

  void _calculateTotal() {
    double total = 0;
    _points.forEach((key, value) {
      total += value;
    });
    setState(() {
      _totalScore = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.task.questions ?? [];
    final student = widget.submission['student'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Exam'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Total: ${_totalScore.toStringAsFixed(1)} / ${widget.task.maxPoints}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Student Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                UserAvatar(
                  name: student['name'],
                  avatarUrl: student['avatar'],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(student['email'],
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Questions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionGradingCard(questions[index], index + 1);
              },
            ),
          ),

          // Footer
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                )
              ]),
              child: Column(
                children: [
                  TextField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      labelText: 'Overall Feedback',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveGrade,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E6AFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : const Text('Save Grade'),
                    ),
                  ),
                  const SizedBox(height: 90), // Extra spacing for comfort
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuestionGradingCard(Map<String, dynamic> question, int index) {
    final qId = question['id'].toString();
    final maxPoints = (question['points'] as num?)?.toDouble() ?? 0.0;
    final answers = widget.submission['answers'] as Map<String, dynamic>? ?? {};
    final studentAnswer = answers[qId]?.toString() ?? 'No Answer';
    final correctAnswer = question['correctAnswer']?.toString();
    final type = question['type'];

    final currentPoints = _points[qId] ?? 0.0;
    final isCorrect = type != 'TEXT' && studentAnswer == correctAnswer;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question $index',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('$maxPoints pts',
                      style: TextStyle(color: Colors.blue[800], fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(question['text'] ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            // Comparison
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          width: 80,
                          child: Text('Student:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey))),
                      Expanded(
                        child: Text(
                          studentAnswer,
                          style: TextStyle(
                              color: isCorrect
                                  ? Colors.green[700]
                                  : (type == 'TEXT'
                                      ? Colors.black
                                      : Colors.red[700]),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (type != 'TEXT')
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 18,
                        )
                    ],
                  ),
                  if (type != 'TEXT' && !isCorrect) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            width: 80,
                            child: Text('Correct:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey))),
                        Expanded(
                            child: Text(correctAnswer ?? 'N/A',
                                style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500))),
                      ],
                    )
                  ]
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Grading Control
            Row(
              children: [
                const Text('Score: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    controller:
                        TextEditingController(text: currentPoints.toString())
                          ..selection = TextSelection.collapsed(
                              offset: currentPoints.toString().length),
                    onChanged: (val) {
                      final newPoints = double.tryParse(val);
                      if (newPoints != null) {
                        setState(() {
                          _points[qId] = newPoints;
                          _calculateTotal();
                        });
                      }
                    },
                  ),
                ),
                const Spacer(),
                if (type == 'TEXT')
                  const Chip(
                      label: Text('Manual Review'),
                      backgroundColor: Colors.orangeAccent)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveGrade() async {
    setState(() => _isSaving = true);

    try {
      final success = await DataService.gradeSubmission(
          submissionId: widget.submission['id'],
          points: _totalScore,
          feedback: _feedbackController.text);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Grading saved successfully')));
          Navigator.pop(context, true); // Return success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save grade')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
