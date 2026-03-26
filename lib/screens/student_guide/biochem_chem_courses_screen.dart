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
    "prerequisites": "ENGL 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "فيروسات وبكتيريا",
    "course_code": "MICR 295",
    "credit_hours": "3",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية أليفاتية أحادية وعديدة المجموعة",
    "course_code": "CHEM 261",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء غير عضوية نظريات + عناصر [s,p]",
    "course_code": "CHEM 271",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "أساسيات الكيمياء التحليلية",
    "course_code": "CHEM 281",
    "credit_hours": "1",
    "prerequisites": "-"
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
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية أروماتية أحادية وعديدة المجموعة",
    "course_code": "CHEM 260",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [ديناميكا حرارية + كيمياء كهربية (1)]",
    "course_code": "CHEM 290",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [النظرية الحركية للغازات + الخواص الفيزيائية والتركيب الجزيئي]",
    "course_code": "CHEM 294",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [سترويدات]",
    "course_code": "CHEM 264",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "الإحصاء في الكيمياء التحليلية",
    "course_code": "CHEM 282",
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
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [الكيمياء الفراغية والسكريات]",
    "course_code": "CHEM 361",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء غير عضوية [كيمياء تناسقية]",
    "course_code": "CHEM 371",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [كيمياء السطوح والحفز والخواص الطبيعية للبلمرات 1]",
    "course_code": "CHEM 391",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [كيمياء كهربية 2]",
    "course_code": "CHEM 393",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [الأحماض الأمينية والأنثوسيانيات]",
    "course_code": "CHEM 363",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "الكيمياء غير العضوية التطبيقية",
    "course_code": "CHEM 383",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "الكيمياء الخضراء",
    "course_code": "CHEM 381",
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
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [الأصباغ والأطياف العضوية]",
    "course_code": "CHEM 360",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء تحليلية [التحليل بالأجهزة]",
    "course_code": "CHEM 380",
    "credit_hours": "3",
    "prerequisites": "-"
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
    "course_name": "إعتلالات وراثية",
    "course_code": "BIOC 411",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [ميكانيكية تفاعلات + تربينات]",
    "course_code": "CHEM 461",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "الكيمياء الحيوية غير عضوية والطيفية الكيميائية",
    "course_code": "CHEM 471",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [الديناميكا الحرارية للمحاليل الإلكتروليتية]",
    "course_code": "CHEM 491",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [بيرول + نيوكلويدات]",
    "course_code": "CHEM 463",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء حيوية تحليلية",
    "course_code": "CHEM 481",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [كيمياء الأسمنت (1) + قاعدة الصنف]",
    "course_code": "CHEM 493",
    "credit_hours": "2",
    "prerequisites": "-"
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
    "course_name": "مقدمة في البروتوم والجينوم",
    "course_code": "BIOC 418",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء الحيوية",
    "course_name": "كيمياء حيوية الأمراض",
    "course_code": "BIOC 412",
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
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [غير متجانسة + قلويدات]",
    "course_code": "CHEM 460",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [كيمياء ضوئية]",
    "course_code": "CHEM 490",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء غير عضوية [سلاسل + المتراكبات العنقودية]",
    "course_code": "CHEM 470",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [ضوئية + ليبيدات]",
    "course_code": "CHEM 462",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء فيزيائية [كيمياء السطوح (2) + كيمياء الحفز التطبيقية]",
    "course_code": "CHEM 492",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الكيمياء",
    "course_name": "كيمياء تحليلية تطبيقية",
    "course_code": "CHEM 480",
    "credit_hours": "2",
    "prerequisites": "-"
  }
];

class BiochemChemCoursesScreen extends StatefulWidget {
  const BiochemChemCoursesScreen({super.key});
  @override
  State<BiochemChemCoursesScreen> createState() =>
      _BiochemChemCoursesScreenState();
}

class _BiochemChemCoursesScreenState extends State<BiochemChemCoursesScreen>
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
        title: const Text('كيمياء حيوية – كيمياء (مزدوج)',
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
    if (dept.contains('الكيمياء الحيوية') || dept.contains('BIOC'))
      return const Color(0xFF065F46);
    if (dept.contains('الكيمياء') || dept.contains('CHEM'))
      return const Color(0xFF7C3AED);
    if (dept.contains('الحشرات') || dept.contains('ENTM'))
      return const Color(0xFF1E3A5F);
    if (dept.contains('الحيوان') || dept.contains('ZOOL'))
      return const Color(0xFF059669);
    if (dept.contains('النبات') || dept.contains('BOTA'))
      return const Color(0xFF16A34A);
    if (dept.contains('فيزياء') || dept.contains('PHYS') || dept.contains('BIOP'))
      return const Color(0xFFDC2626);
    if (dept.contains('رياضيات') || dept.contains('MATH'))
      return const Color(0xFF2563EB);
    if (dept.contains('إحصاء') || dept.contains('STAT'))
      return const Color(0xFF0284C7);
    if (dept.contains('ميكروبيولوجيا') || dept.contains('MICR'))
      return const Color(0xFF6D28D9);
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
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: _accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(course['course_code'] ?? '',
                                style: TextStyle(
                                    color: _accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    letterSpacing: 0.5)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(typeLabel,
                                style: TextStyle(
                                    color: typeColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(course['course_name'] ?? '',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B))),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _InfoTag(
                              icon: Icons.access_time_filled_rounded,
                              label: '${course['credit_hours']} ساعة',
                              color: Colors.blueGrey),
                          const SizedBox(width: 12),
                          _InfoTag(
                              icon: Icons.account_balance_rounded,
                              label: course['department'] ?? '',
                              color: Colors.blueGrey),
                        ],
                      ),
                      if (hasPrereq) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.2))),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 14, color: Colors.amber),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                    'المتطلبات: ${course['prerequisites']}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF92400E),
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoTag({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color.withValues(alpha: 0.5)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: color.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500)),
      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
