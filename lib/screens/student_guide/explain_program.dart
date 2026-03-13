import 'package:flutter/material.dart';
import 'Study_programs.dart';
import 'departmentcard.dart';
import 'department_details_screen.dart';

class ExplainProgram extends StatefulWidget {
  const ExplainProgram({super.key});

  @override
  State<ExplainProgram> createState() => _ExplainProgramState();
}

class _ExplainProgramState extends State<ExplainProgram> {
  String? selectedTrack;

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final departmentsList = Departments;
    List<Map<String, dynamic>> filteredDepartments = [];
    if (selectedTrack == 'math') {
      filteredDepartments =
          departmentsList.where((d) => d['isMath'] == true).toList();
    } else if (selectedTrack == 'science') {
      filteredDepartments =
          departmentsList.where((d) => d['isScience'] == true).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Program Selection'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select High School Track',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedTrack,
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF2563eb)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      hint: const Text('Choose your track'),
                      items: const [
                        DropdownMenuItem(
                          value: 'math',
                          child: Row(
                            children: [
                              Icon(Icons.calculate,
                                  color: Color(0xFF2563eb), size: 20),
                              SizedBox(width: 12),
                              Text('Scientific Math (علمي رياضة)'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'science',
                          child: Row(
                            children: [
                              Icon(Icons.science,
                                  color: Color(0xFF7c3aed), size: 20),
                              SizedBox(width: 12),
                              Text('Scientific Science (علمي علوم)'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedTrack = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: filteredDepartments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selectedTrack == null
                                  ? Icons.touch_app
                                  : Icons.search_off,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              selectedTrack == null
                                  ? 'Please select a track above'
                                  : 'No programs found for this track',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16, left: 4),
                            child: Text(
                              'Available Programs (${filteredDepartments.length})',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              itemCount: filteredDepartments.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                              itemBuilder: (context, index) {
                                final department = filteredDepartments[index];
                                return DepartmentCard(
                                  title: department['title']!,
                                  subtitle: department['subtitle']!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DepartmentDetailsScreen(
                                          title: department['title']!,
                                          arInfo: department['ARinformation']!,
                                          enInfo: department['ENinformation']!,
                                          finalProgramsAR:
                                              department['finalProgramsAR']!,
                                          finalProgramsEN:
                                              department['finalProgramsEN']!,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
