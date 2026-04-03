import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== المستوى الأول ==========
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "الأمن والسلامة",
    "course_code": "SAFS 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "حقوق الإنسان",
    "course_code": "HURI 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الفيزياء (متطلبات الكلية)",
    "course_name": "فيزياء عامة (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "كيمياء عامة (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "عملي كيمياء عامة (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الإحصاء (متطلبات الكلية)",
    "course_name": "مقدمة في الإحصاء",
    "course_code": "STAT 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "لغة إنجليزية (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "مدخل في الحاسب الآلي",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "تفاضل وتكامل (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "مفاهيم أساسية في الرياضيات",
    "course_code": "MATH 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علوم الحاسب (متطلبات الكلية)",
    "course_name": "مقدمة في الحاسب الآلي",
    "course_code": "COMP 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علوم الحاسب (متطلبات الكلية)",
    "course_name": "برمجة حاسب (1)",
    "course_code": "COMP 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علوم الحاسب (متطلبات الكلية)",
    "course_name": "تصميم منطق",
    "course_code": "COMP 106",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "لغة إنجليزية (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  // ========== المستوى الثاني ==========
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "تصميم وتحليل الخوارزميات",
    "course_code": "COMP 201",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "نظرية الحسابات",
    "course_code": "COMP 203",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "برمجة حاسب (2)",
    "course_code": "COMP 205",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "نظم قواعد بيانات",
    "course_code": "COMP 207",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الرياضيات",
    "course_name": "جبر خطي",
    "course_code": "MATH 203",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "تراكيب البيانات",
    "course_code": "COMP 202",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "شبكات الحاسب",
    "course_code": "COMP 204",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "برمجة الويب",
    "course_code": "COMP 206",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "نظرية الآليات الذاتية",
    "course_code": "COMP 208",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "خوارزميات الرسوم",
    "course_code": "COMP 210",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الرياضيات (اختياري)",
    "course_name": "معادلات تفاضلية",
    "course_code": "MATH 202",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  // ========== المستوى الثالث ==========
  {
    "level": "3",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "التفكير العلمي",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "أخلاقيات البحث العلمي",
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "برمجة متقدمة",
    "course_code": "COMP 301",
    "credit_hours": "3",
    "prerequisites": "COMP 205"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "قواعد ودلالات لغات البرمجة",
    "course_code": "COMP 303",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "نظرية التعقد",
    "course_code": "COMP 305",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "نظم التشغيل",
    "course_code": "COMP 307",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "تآلفيات خوارزمية",
    "course_code": "COMP 302",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "تصميم مؤلفات",
    "course_code": "COMP 304",
    "credit_hours": "3",
    "prerequisites": "COMP 208, 205"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "رسومات الحاسب",
    "course_code": "COMP 306",
    "credit_hours": "3",
    "prerequisites": "COMP 205"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "تشفير",
    "course_code": "COMP 308",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "نظم الوسائط المتعددة",
    "course_code": "COMP 309",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "اللغات التصريحية",
    "course_code": "COMP 311",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "برمجة ويب متقدمة",
    "course_code": "COMP 310",
    "credit_hours": "2",
    "prerequisites": "COMP 206"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "تنظيم الملفات",
    "course_code": "COMP 312",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "نظم قواعد بيانات متقدمة",
    "course_code": "COMP 314",
    "credit_hours": "2",
    "prerequisites": "COMP 207"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الرياضيات (اختياري)",
    "course_name": "التحليل العددي",
    "course_code": "MATH 303",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الرياضيات (اختياري)",
    "course_name": "الجبر المجرد لعلوم الحاسب",
    "course_code": "MATH 333",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الإحصاء (اختياري)",
    "course_name": "مقدمة في نظرية الاحتمالات",
    "course_code": "STAT 218",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  // ========== المستوى الرابع ==========
  {
    "level": "4",
    "type": "elective",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "مهارات العمل",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "ثقافة بيئية",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "نشأة وتاريخ وتطور العلوم",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "ذكاء اصطناعي",
    "course_code": "COMP 401",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "المعالجة المتوازية والموزعة",
    "course_code": "COMP 403",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "مشروع حاسب (أ)",
    "course_code": "COMP 405",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "معالجة الصور",
    "course_code": "COMP 407",
    "credit_hours": "3",
    "prerequisites": "COMP 205"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "المعلومات الحيوية",
    "course_code": "COMP 402",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 205"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "هندسة البرمجيات",
    "course_code": "COMP 404",
    "credit_hours": "3",
    "prerequisites": "COMP 205"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "مشروع حاسب (ب)",
    "course_code": "COMP 406",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "أمن الشبكات",
    "course_code": "COMP 409",
    "credit_hours": "3",
    "prerequisites": "COMP 204, 308"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "الهندسة الحسابية",
    "course_code": "COMP 411",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 205"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "موضوعات مختارة في الخوارزميات",
    "course_code": "COMP 413",
    "credit_hours": "3",
    "prerequisites": "COMP 201"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "موضوعات متقدمة في المؤلفات",
    "course_code": "COMP 415",
    "credit_hours": "3",
    "prerequisites": "COMP 303 أو 304"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "موضوعات متقدمة في الذكاء الاصطناعي",
    "course_code": "COMP 408",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "الرؤية بالحاسب",
    "course_code": "COMP 410",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 205"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "موضوعات مختارة في أمن المعلومات",
    "course_code": "COMP 412",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "موضوعات مختارة في الحوسبة",
    "course_code": "COMP 414",
    "credit_hours": "3",
    "prerequisites": "COMP 205"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "استخلاص البيانات والويب",
    "course_code": "COMP 416",
    "credit_hours": "3",
    "prerequisites": "COMP 207"
  },
];

class CSCoursesScreen extends StatefulWidget {
  const CSCoursesScreen({super.key});

  @override
  State<CSCoursesScreen> createState() => _CSCoursesScreenState();
}

class _CSCoursesScreenState extends State<CSCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';

  static const _levels = ['1', '2', '3', '4'];
  static const _levelNames = ['الأولى', 'الثانية', 'الثالثة', 'الرابعة'];
  static const _levelLabels = [
    'المستوى الأول',
    'المستوى الثاني',
    'المستوى الثالث',
    'المستوى الرابع',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _levels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getCourses(String level) {
    return _courses.where((c) {
      if (c['level'] != level) return false;
      if (_filterType != 'all' && c['type'] != _filterType) return false;
      return true;
    }).toList();
  }

  int _totalHours(String level) => _getCourses(level)
      .fold(0, (s, c) => s + (int.tryParse(c['credit_hours'] ?? '0') ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'علوم الحاسب – تخصص منفرد',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF312E81),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: List.generate(
              _levels.length, (i) => Tab(text: 'السنة ${_levelNames[i]}')),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_levels.length,
                  (i) => _buildPage(_levels[i], _levelLabels[i])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: const Color(0xFF312E81),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Chip(
              label: 'الكل',
              selected: _filterType == 'all',
              color: const Color(0xFF64748B),
              onTap: () => setState(() => _filterType = 'all')),
          const SizedBox(width: 8),
          _Chip(
              label: 'إجباري',
              selected: _filterType == 'mandatory',
              color: const Color(0xFF059669),
              onTap: () => setState(() => _filterType = 'mandatory')),
          const SizedBox(width: 8),
          _Chip(
              label: 'اختياري',
              selected: _filterType == 'elective',
              color: const Color(0xFFD97706),
              onTap: () => setState(() => _filterType = 'elective')),
        ],
      ),
    );
  }

  Widget _buildPage(String level, String label) {
    final courses = _getCourses(level);
    final totalHours = _totalHours(level);

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('لا توجد مقررات لهذا الفلتر',
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF312E81), Color(0xFF6D28D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF312E81).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${courses.length} مقرر',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text('$totalHours',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const Text('ساعة',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CourseCard(course: courses[index]),
              ),
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Map<String, String> course;
  const _CourseCard({required this.course});

  Color get _accentColor {
    final dept = course['department'] ?? '';
    if (dept.contains('حاسب')) return const Color(0xFF6D28D9);
    if (dept.contains('رياضيات') || dept.contains('الرياضيات')) {
      return const Color(0xFF2563EB);
    }
    if (dept.contains('إحصاء')) return const Color(0xFF0284C7);
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final isElective = course['type'] == 'elective';
    final typeColor =
        isElective ? const Color(0xFFD97706) : const Color(0xFF059669);
    final typeLabel = isElective ? 'اختياري' : 'إجباري';
    final hasPrereq =
        course['prerequisites'] != null && course['prerequisites'] != '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(right: BorderSide(color: _accentColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(typeLabel,
                      style: TextStyle(
                          color: typeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
                Text(course['course_code'] ?? '',
                    style: TextStyle(
                        color: _accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 10),
            Text(course['course_name'] ?? '',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827))),
            const SizedBox(height: 6),
            Text(course['department'] ?? '',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasPrereq)
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link,
                            size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            course['prerequisites'] ?? '',
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF9CA3AF)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 13, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text('${course['credit_hours']} ساعة',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _Chip(
      {required this.label,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.white30),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }
}
