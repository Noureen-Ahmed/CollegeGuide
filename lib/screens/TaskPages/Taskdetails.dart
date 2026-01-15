import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TextEditingController titleController;
  late TextEditingController descController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TaskPriority importance = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descController = TextEditingController(text: widget.task.description ?? '');
    selectedDate = widget.task.dueDate;
    selectedTime = widget.task.dueDate != null 
        ? TimeOfDay.fromDateTime(widget.task.dueDate!) 
        : null;
    importance = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Task Name", style: labelStyle),
              const SizedBox(height: 6),
              inputBox(titleController, hint: "Enter task name"),
              const SizedBox(height: 16),
              const Text("Description", style: labelStyle),
              const SizedBox(height: 6),
              descriptionBox(descController),
              const SizedBox(height: 16),
              const Text("Deadline", style: labelStyle),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: dateBox(
                      title: selectedDate == null
                          ? "Pick a date"
                          : DateFormat('MMMM dd, yyyy').format(selectedDate!),
                      onTap: pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const SizedBox(height: 6),
                  Expanded(
                    child: dateBox(
                      title: selectedTime == null
                          ? "Pick time"
                          : selectedTime!.format(context),
                      onTap: pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text("Importance", style: labelStyle),
              const SizedBox(height: 8),
              Row(
                children: [
                  priorityButton(TaskPriority.low, "Low", Colors.green),
                  const SizedBox(width: 10),
                  priorityButton(TaskPriority.medium, "Medium", Colors.orange),
                  const SizedBox(width: 10),
                  priorityButton(TaskPriority.high, "High", Colors.red),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002147),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 120), // Extra padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  void saveChanges() {
    if (titleController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields")),
      );
      return;
    }

    final dueDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final updatedTask = widget.task.copyWith(
      title: titleController.text,
      description: descController.text,
      dueDate: dueDate,
      priority: importance,
    );

    Navigator.pop(context, updatedTask);
  }

  Future pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  Widget priorityButton(TaskPriority p, String text, Color color) {
    bool isSelected = importance == p;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => importance = p),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : const Color(0xFFE5E7EB),
            ),
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? color : const Color(0xFF1F2C5C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

const labelStyle = TextStyle(
  color: Color(0xFF1F2937),
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

Widget inputBox(TextEditingController controller, {required String hint}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: boxDecoration,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(border: InputBorder.none, hintText: hint),
    ),
  );
}

Widget descriptionBox(TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: boxDecoration,
    child: TextField(
      controller: controller,
      maxLines: 5,
      decoration: const InputDecoration(border: InputBorder.none),
    ),
  );
}

Widget dateBox({required String title, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: boxDecoration,
      child: Text(title, style: const TextStyle(color: Color(0xFF1F2C5C))),
    ),
  );
}

const boxDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0xFFE5E7EB), width: 1.0),
  ),
  color: Color(0xFFF9FAFB), // light gray bg for inputs
);
