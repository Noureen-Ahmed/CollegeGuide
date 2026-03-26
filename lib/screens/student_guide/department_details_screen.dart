import 'package:flutter/material.dart';
import 'math_courses_screen.dart';
import 'pure_math_stats_courses_screen.dart';
import 'pure_math_cs_courses_screen.dart';
import 'math_stats_courses_screen.dart';
import 'stats_cs_courses_screen.dart';
import 'cs_courses_screen.dart';
import 'physics_courses_screen.dart';
import 'biophysics_courses_screen.dart';
import 'physics_chem_courses_screen.dart';
import 'physics_cs_courses_screen.dart';
import 'chemistry_courses_screen.dart';
import 'applied_chemistry_courses_screen.dart';
import 'botany_courses_screen.dart';
import 'botany_chem_courses_screen.dart';
import 'zoology_courses_screen.dart';
import 'zoology_chem_courses_screen.dart';
import 'entomology_courses_screen.dart';
import 'medical_entomology_courses_screen.dart';
import 'biochemistry_courses_screen.dart';
import 'biochem_chem_courses_screen.dart';
import 'microbiology_courses_screen.dart';

class DepartmentDetailsScreen extends StatefulWidget {
  final String title;
  final String arInfo;
  final String enInfo;
  final List<String> finalProgramsAR;
  final List<String> finalProgramsEN;

  const DepartmentDetailsScreen({
    super.key,
    required this.title,
    required this.arInfo,
    required this.enInfo,
    required this.finalProgramsAR,
    required this.finalProgramsEN,
  });

  @override
  State<DepartmentDetailsScreen> createState() =>
      _DepartmentDetailsScreenState();
}

class _DepartmentDetailsScreenState extends State<DepartmentDetailsScreen> {
  bool isArabic = true;

  @override
  Widget build(BuildContext context) {
    final programs = isArabic ? widget.finalProgramsAR : widget.finalProgramsEN;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(widget.title),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Language Switcher
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LanguageButton(
                          text: 'Arabic',
                          isSelected: isArabic,
                          onTap: () => setState(() => isArabic = true),
                        ),
                        _LanguageButton(
                          text: 'English',
                          isSelected: !isArabic,
                          onTap: () => setState(() => isArabic = false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Content
                  Text(
                    isArabic ? widget.arInfo : widget.enInfo,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF374151),
                    ),
                    textAlign: isArabic ? TextAlign.center : TextAlign.left,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Programs Header
            Row(
              children: [
                const Icon(Icons.school, color: Color(0xFF2563eb)),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'البرامج المتاحة' : 'Available Programs',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Programs List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: programs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    final programAR = widget.finalProgramsAR[index];
                    // فتح شاشة خاصة بكورسات الرياضيات المنفرد
                    if (programAR == 'رياضيات') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MathCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'بحتة-احصاء') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PureMathStatsCourseScreen(),
                        ),
                      );
                    } else if (programAR == 'بحتة-حاسب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PureMathCSCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'إحصاء رياضي') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MathStatsCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'احصاء-حاسب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatsCSCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'علوم الحاسب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CSCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'فيزياء منفردة') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhysicsCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'فيزياء حيوية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BiophysicsCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'فيزياء- كيمياء') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PhysicsChemCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'فيزياء- حاسب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhysicsCSCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'كيمياء أساسية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChemistryCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'كيمياء تطبيقية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AppliedChemistryCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'نبات') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BotanyCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'النبات-كيمياء') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BotanyChemCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'علم الحيوان') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ZoologyCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'علم الحيوان-كيمياء') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ZoologyChemCoursesScreen(),
                        ),
                      );
                    } else if (programAR == 'علم الحشرات') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EntomologyCoursesScreen(),
                        ),
                      );
                    } else if (programAR.trim() == 'علم الحشرات الطبية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MedicalEntomologyCoursesScreen(),
                        ),
                      );
                    } else if (programAR.trim() == 'كيمياء حيوية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BiochemistryCoursesScreen(),
                        ),
                      );
                    } else if (programAR.trim() == 'الكيمياء الحيوية-الكيمياء') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BiochemChemCoursesScreen(),
                        ),
                      );
                    } else if (programAR.trim() == 'ميكروبيولوجي') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MicrobiologyCoursesScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isArabic
                                ? 'تم اختيار: ${programs[index]}'
                                : 'Selected: ${programs[index]}',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2563eb),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade100),
                    ),
                    alignment:
                        isArabic ? Alignment.centerRight : Alignment.centerLeft,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          programs[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                        ),
                      ),
                      Icon(
                        isArabic
                            ? Icons.arrow_back_ios_new
                            : Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isSelected ? const Color(0xFF2563eb) : const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
