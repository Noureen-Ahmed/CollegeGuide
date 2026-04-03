import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== المستوى الأول ==========
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "الأمن والسلامة",
    "course_code": "SAFS 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "حقوق الإنسان",
    "course_code": "HURI 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الرياضيات",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الفيزياء",
    "course_name": "فيزياء عامة (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عامة (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "عملي كيمياء عامة (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علم النبات",
    "course_name": "أساسيات علم النبات (1)",
    "course_code": "BOTA 101",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علم الحيوان",
    "course_name": "علم الحيوان (1)",
    "course_code": "ZOOL 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "لغة إنجليزية (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "مدخل في الحاسب الآلي",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء (2)",
    "course_code": "CHEM 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "عملي كيمياء عامة (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علم النبات",
    "course_name": "أساسيات علم النبات (2)",
    "course_code": "BOTA 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علم الحيوان",
    "course_name": "علم الحيوان (2)",
    "course_code": "ZOOL 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجي",
    "course_code": "MICR 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },

  // ========== المستوى الثاني ==========
  {
    "level": "2",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "لغة إنجليزية (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "كيمياء وأيض البروتين",
    "course_code": "BIOC 201",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "إنزيمات وكيمياء الأنسجة",
    "course_code": "BIOC 203",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الإحصاء",
    "course_name": "مفاهيم إحصائية",
    "course_code": "STAT 209",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء تحليلية (1)",
    "course_code": "CHEM 231",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 OR CHEM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء تحليلية عملي (1)",
    "course_code": "CHEM 233",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 OR CHEM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية (أليفاتية + أروماتية)",
    "course_code": "CHEM 251",
    "credit_hours": "2",
    "prerequisites": "CHEM 102"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم النبات",
    "course_name": "فسيولوجيا العلاقات المائية في النبات",
    "course_code": "BOTA 203",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الفيزياء الحيوية",
    "course_name": "أساسيات الفيزياء الحيوية",
    "course_code": "BIOP 213",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحيوان",
    "course_name": "علم وظائف الحيوان",
    "course_code": "ZOOL 211",
    "credit_hours": "2",
    "prerequisites": "ZOOL 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "أساسيات أيض الكربوهيدرات والدهون",
    "course_code": "BIOC 210",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "كيمياء حيوية صناعية",
    "course_code": "BIOC 204",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "كيمياء حيوية نباتية",
    "course_code": "BIOC 206",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "أساسيات البيولوجيا الإشعاعية",
    "course_code": "BIOC 208",
    "credit_hours": "2",
    "prerequisites": "-"
  },

  // ========== المستوى الثالث ==========
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "مقدمة في السوائل البيولوجية",
    "course_code": "BIOC 309",
    "credit_hours": "3",
    "prerequisites": "BIOC 201"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "بيولوجيا جزيئية (1)",
    "course_code": "BIOC 303",
    "credit_hours": "3",
    "prerequisites": "BIOC 201"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم النبات",
    "course_name": "زراعة أنسجة نباتية",
    "course_code": "BOTA 333",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الإحصاء",
    "course_name": "إحصاء حيوي",
    "course_code": "STAT 321",
    "credit_hours": "2",
    "prerequisites": "STAT 209"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم النبات",
    "course_name": "النباتات الطبية والأروماتية والاقتصادية",
    "course_code": "BOTA 335",
    "credit_hours": "2",
    "prerequisites": "BOTA 101"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "بيولوجيا الإشعاع",
    "course_code": "BIOC 307",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "علم المصطلحات",
    "course_code": "BIOC 311",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "أخلاقيات البحث العلمي",
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "أساسيات أيض الأحماض النووية",
    "course_code": "BIOC 314",
    "credit_hours": "2",
    "prerequisites": "BIOC 201"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "علم المناعة",
    "course_code": "BIOC 306",
    "credit_hours": "3",
    "prerequisites": "BIOC 201"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "هرمونات",
    "course_code": "BIOC 308",
    "credit_hours": "2",
    "prerequisites": "BIOC 201 OR 202"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "الكيمياء الحيوية الميكروبية",
    "course_code": "BIOC 304",
    "credit_hours": "2",
    "prerequisites": "MICR 102"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم النبات",
    "course_name": "الإجهاد ومضادات الأكسدة في النبات",
    "course_code": "BOTA 334",
    "credit_hours": "2",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "التغذية",
    "course_code": "BIOC 312",
    "credit_hours": "2",
    "prerequisites": "BIOC 202"
  },

  // ========== المستوى الرابع ==========
  {
    "level": "4",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "نشأة وتاريخ وتطور العلوم",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "ضبط الجودة وكتابة مقالة علمية",
    "course_code": "BIOC 401",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "هندسة وراثية",
    "course_code": "BIOC 403",
    "credit_hours": "4",
    "prerequisites": "BIOC 303"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "بيولوجيا جزيئية (2)",
    "course_code": "BIOC 405",
    "credit_hours": "3",
    "prerequisites": "BIOC 303"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الفيزياء الحيوية",
    "course_name": "فيزياء حيوية",
    "course_code": "BIOP 433",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "مقدمة في بيولوجيا الخلايا الجذعية",
    "course_code": "BIOC 407",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "فيروسات جزيئية",
    "course_code": "BIOC 409",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "اعتلالات وراثية",
    "course_code": "BIOC 411",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علم الحيوان",
    "course_name": "علم السموم والتلوث البيئي",
    "course_code": "ZOOL 417",
    "credit_hours": "2",
    "prerequisites": "ZOOL 102"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "بيولوجيا أورام وبيولوجيا بيئية",
    "course_code": "BIOC 402",
    "credit_hours": "4",
    "prerequisites": "BIOC 303"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "طرق الفصل والتحاليل الكيميائية الحيوية",
    "course_code": "BIOC 404",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "تكنولوجيا حيوية جزيئية",
    "course_code": "BIOC 408",
    "credit_hours": "3",
    "prerequisites": "BIOC 303"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "بحث علمي",
    "course_code": "BIOC 410",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "كيمياء حيوية الأمراض",
    "course_code": "BIOC 412",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "مقدمة في البروتوم والجينوم",
    "course_code": "BIOC 418",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "بيولوجيا الخلية المتقدمة",
    "course_code": "BIOC 420",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "أيض المواد الغريبة",
    "course_code": "BIOC 414",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "مقدمة في المعلوماتية الحيوية",
    "course_code": "BIOC 416",
    "credit_hours": "2",
    "prerequisites": "-"
  }
];

class BiochemistryCoursesScreen extends StatefulWidget {
  const BiochemistryCoursesScreen({super.key});
  @override
  State<BiochemistryCoursesScreen> createState() =>
      _BiochemistryCoursesScreenState();
}

class _BiochemistryCoursesScreenState extends State<BiochemistryCoursesScreen>
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

  List<Map<String, String>> _getCourses(String level) => _courses.where((c) {
        if (c['level'] != level) return false;
        if (_filterType != 'all' && c['type'] != _filterType) return false;
        return true;
      }).toList();

  int _totalHours(String level) => _getCourses(level)
      .fold(0, (s, c) => s + (int.tryParse(c['credit_hours'] ?? '0') ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('كيمياء حيوية – منفرد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F),
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
      color: const Color(0xFF1E3A5F),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('لا توجد مقررات لهذا الفلتر',
              style: TextStyle(color: Colors.grey[500], fontSize: 16)),
        ]),
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
                  colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF1E3A5F).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
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
                      ]),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(children: [
                      Text('$totalHours',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const Text('ساعة',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
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
                  child: _CourseCard(course: courses[index])),
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
    if (dept.contains('الكيمياء الحيوية') || dept.contains('BIOC')) {
      return const Color(0xFF065F46);
    }
    if (dept.contains('الكيمياء') || dept.contains('CHEM')) {
      return const Color(0xFF7C3AED);
    }
    if (dept.contains('الحشرات') || dept.contains('ENTM')) {
      return const Color(0xFF1E3A5F);
    }
    if (dept.contains('الحيوان') || dept.contains('ZOOL')) {
      return const Color(0xFF059669);
    }
    if (dept.contains('النبات') || dept.contains('BOTA')) {
      return const Color(0xFF16A34A);
    }
    if (dept.contains('فيزياء') ||
        dept.contains('PHYS') ||
        dept.contains('BIOP')) {
      return const Color(0xFFDC2626);
    }
    if (dept.contains('رياضيات') || dept.contains('MATH')) {
      return const Color(0xFF2563EB);
    }
    if (dept.contains('إحصاء') || dept.contains('STAT')) {
      return const Color(0xFF0284C7);
    }
    if (dept.contains('ميكروبيولوجيا') || dept.contains('MICR')) {
      return const Color(0xFF6D28D9);
    }
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
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          ]),
          const SizedBox(height: 10),
          Text(course['course_name'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827))),
          const SizedBox(height: 6),
          Text(course['department'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (hasPrereq)
              Flexible(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.link, size: 14, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 4),
                Flexible(
                    child: Text(course['prerequisites'] ?? '',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF)),
                        overflow: TextOverflow.ellipsis)),
              ]))
            else
              const SizedBox.shrink(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                const Icon(Icons.access_time,
                    size: 13, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text('${course['credit_hours']} ساعة',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ]),
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
