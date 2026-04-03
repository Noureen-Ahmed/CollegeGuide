import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== المستوى الأول ==========
  {
    "level": "1",
    "type": "mandatory",
    "department": "الرياضيات",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الفيزياء",
    "course_name": "فيزياء عامة (1)",
    "course_code": "PHYS 101",
    "credit_hours": "3",
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
    "credit_hours": "2",
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
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجي",
    "course_code": "MICR 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "علم الحشرات",
    "course_code": "ENTM 102",
    "credit_hours": "2",
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
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "الشكل العام للحشرات",
    "course_code": "ENTM 201",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "تشريح الحشرات المتقدم",
    "course_code": "ENTM 203",
    "credit_hours": "2",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "ملائمة الحشرات لبيئتها",
    "course_code": "ENTM 205",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "التلوث وحماية البيئة",
    "course_code": "ENTM 207",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "تصنيف الحشرات (1)",
    "course_code": "ENTM 209",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "الكيمياء الحيوي متقدم",
    "course_code": "BIOC 205",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "الحشرات ودورها كمؤشرات حيوية",
    "course_code": "ENTM 211",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "الحشرات في مصر (الفرعونية) القديمة",
    "course_code": "ENTM 213",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "الحشرات النافعة ومنتجاتها",
    "course_code": "ENTM 215",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "آليات الدفاع في الحشرات",
    "course_code": "ENTM 217",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "أسس مكافحة الآفات",
    "course_code": "ENTM 202",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "الحشرات كناقلات للأمراض النباتية",
    "course_code": "ENTM 204",
    "credit_hours": "2",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "الحشرات الإجتماعية",
    "course_code": "ENTM 206",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "أمراض حشرات ومكافحة حيوية",
    "course_code": "ENTM 208",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "صحة المجتمع والحشرات",
    "course_code": "ENTM 210",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "التقنية في الحشرات",
    "course_code": "ENTM 212",
    "credit_hours": "2",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الإحصاء",
    "course_name": "إحصاء حيوي",
    "course_code": "STAT 212",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "نحل العسل",
    "course_code": "ENTM 214",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "طرق الكتابة والعرض العلمي",
    "course_code": "ENTM 216",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "تعدد الأشكال في الحشرات",
    "course_code": "ENTM 218",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "إصدار الصوت والضوء في الحشرات",
    "course_code": "ENTM 220",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "إدارة الجودة الشاملة والمعايير العالمية لاعتماد المعامل",
    "course_code": "ENTM 262",
    "credit_hours": "1",
    "prerequisites": "-"
  },

  // ========== المستوى الثالث ==========
  {
    "level": "3",
    "type": "mandatory",
    "department": "متطلب جامعة",
    "course_name": "التفكير العلمي",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "بيئة الحشرات المتقدمة",
    "course_code": "ENTM 301",
    "credit_hours": "2",
    "prerequisites": "ENTM 205"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "تصنيف الحشرات (2)",
    "course_code": "ENTM 303",
    "credit_hours": "3",
    "prerequisites": "ENTM 209"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "حشرات طبية وبيطرية",
    "course_code": "ENTM 305",
    "credit_hours": "4",
    "prerequisites": "ENTM 210"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "تطور وتكوين العشائر في الحشرات",
    "course_code": "ENTM 317",
    "credit_hours": "1",
    "prerequisites": "ENTM 209"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الفيزياء الحيوية",
    "course_name": "فيزياء حيوي",
    "course_code": "BIOP 313",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "التواصل في الحشرات",
    "course_code": "ENTM 307",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "آفات الحبوب المخزنة ومنتجاتها",
    "course_code": "ENTM 309",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "علم القراديات",
    "course_code": "ENTM 311",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "مزارع الخلايا الحشرية",
    "course_code": "ENTM 313",
    "credit_hours": "1",
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
    "department": "علم الحشرات",
    "course_name": "حشرات إقتصادية",
    "course_code": "ENTM 302",
    "credit_hours": "3",
    "prerequisites": "ENTM 204"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "الجوانب حشرية المبنية على أسس وراثية",
    "course_code": "ENTM 304",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "علم الأجنة الحشرية",
    "course_code": "ENTM 306",
    "credit_hours": "2",
    "prerequisites": "ENTM 203"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية (مبيدات)",
    "course_code": "CHEM 310",
    "credit_hours": "3",
    "prerequisites": "CHEM 102"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "العلاج بالحشرات",
    "course_code": "ENTM 308",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "أسس علم وراثية الخلية الحشرية",
    "course_code": "ENTM 312",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "التنوع الحيوي والمحميات",
    "course_code": "ENTM 314",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "أسس علم الحفظ البيولوجي",
    "course_code": "ENTM 358",
    "credit_hours": "1",
    "prerequisites": "-"
  },

  // ========== المستوى الرابع ==========
  {
    "level": "4",
    "type": "elective",
    "department": "متطلب جامعة (اختياري)",
    "course_name": "مهارات العمل",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "متطلب جامعة (اختياري)",
    "course_name": "ثقافة بيئية",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "متطلب جامعة (اختياري)",
    "course_name": "نشأة وتاريخ وتطور العلوم",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "فسيولوجي الحشرات المتقدم",
    "course_code": "ENTM 401",
    "credit_hours": "5",
    "prerequisites": "ENTM 203"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "بيولوجية الحشرات الهندسة الجزيئية والوراثية",
    "course_code": "ENTM 403",
    "credit_hours": "3",
    "prerequisites": "ENTM 304"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "سلوك الحشرات المتقدم",
    "course_code": "ENTM 405",
    "credit_hours": "1",
    "prerequisites": "ENTM 303"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا تشخيصية",
    "course_code": "MICR 485",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "الإستخدام الآمن للمبيدات",
    "course_code": "ENTM 409",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "المناعة في الحشرات",
    "course_code": "ENTM 411",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "وراثة العشائر",
    "course_code": "ENTM 413",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "علم الحشرات",
    "course_name": "الحشرات في الطب الشرعي",
    "course_code": "ENTM 459",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "مبيدات حشرية ومقاومة",
    "course_code": "ENTM 402",
    "credit_hours": "5",
    "prerequisites": "ENTM 202"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "إدارة المكافحة المتكاملة",
    "course_code": "ENTM 404",
    "credit_hours": "2",
    "prerequisites": "ENTM 202"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "ديناميكا العشائر المتقدم",
    "course_code": "ENTM 406",
    "credit_hours": "1",
    "prerequisites": "ENTM 301"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "مقال",
    "course_code": "ENTM 408",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحشرات",
    "course_name": "تخطيط برامج إدارة الآفات",
    "course_code": "ENTM 410",
    "credit_hours": "1",
    "prerequisites": "ENTM 202"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الإحصاء",
    "course_name": "إحصاء وبرمجة",
    "course_code": "STAT 420",
    "credit_hours": "3",
    "prerequisites": "STAT 212"
  },
];

class EntomologyCoursesScreen extends StatefulWidget {
  const EntomologyCoursesScreen({super.key});
  @override
  State<EntomologyCoursesScreen> createState() =>
      _EntomologyCoursesScreenState();
}

class _EntomologyCoursesScreenState extends State<EntomologyCoursesScreen>
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
        title: const Text('علم الحشرات – منفرد',
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
    if (dept.contains('الحشرات') || dept.contains('ENTM')) {
      return const Color(0xFF1E3A5F);
    }
    if (dept.contains('الحيوان') || dept.contains('ZOOL')) {
      return const Color(0xFF059669);
    }
    if (dept.contains('الكيمياء الحيوية') || dept.contains('BIOC')) {
      return const Color(0xFF065F46);
    }
    if (dept.contains('الكيمياء') || dept.contains('CHEM')) {
      return const Color(0xFF7C3AED);
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
