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
    "department": "متطلبات الكلية",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "متطلبات الكلية",
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
    "department": "متطلبات الكلية",
    "course_name": "تفاضل وتكامل (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "كيمياء عامة (2)",
    "course_code": "CHEM 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "عملي كيمياء عامة (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  // ========== المستوى الثاني ==========
  {
    "level": "2",
    "type": "mandatory",
    "department": "متطلبات جامعة",
    "course_name": "لغة إنجليزية (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية (1)",
    "course_code": "CHEM 211",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "بتروكيماويات",
    "course_code": "CHEM 213",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية عملي (1)",
    "course_code": "CHEM 215",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية (1) – ديناميكا حرارية وكيمياء كهربية",
    "course_code": "CHEM 241",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية (2) – كيمياء حركية وقاعدة الصنف",
    "course_code": "CHEM 243",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء التحليلية",
    "course_name": "كيمياء تحليلية (1)",
    "course_code": "CHEM 231",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء التحليلية",
    "course_name": "كيمياء تحليلية عملي (1)",
    "course_code": "CHEM 233",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الفيزياء",
    "course_name": "أساسيات الفيزياء الحيوية",
    "course_code": "BIOP 213",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية (2)",
    "course_code": "CHEM 212",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية فراغية",
    "course_code": "CHEM 214",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية عملي (2)",
    "course_code": "CHEM 216",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء غير العضوية",
    "course_name": "كيمياء غير عضوية (1)",
    "course_code": "CHEM 222",
    "credit_hours": "2",
    "prerequisites": "CHEM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية (3) – ديناميكا حرارية وكيمياء السطوح",
    "course_code": "CHEM 242",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية عملي (1)",
    "course_code": "CHEM 244",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الرياضيات",
    "course_name": "جبر خطي وتطبيقاته في الكيمياء",
    "course_code": "MATH 210",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الفيزياء",
    "course_name": "فيزياء – دوائر كهربية",
    "course_code": "PHYS 226",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الكيمياء (اختياري)",
    "course_name": "كيمياء الأصباغ والكيمياء البيئية",
    "course_code": "CHEM 217",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الكيمياء الفيزيائية (اختياري)",
    "course_name":
        "كيمياء فيزيائية أ – النظرية الحركية للغازات والتركيب الجزيئي",
    "course_code": "CHEM 245",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 أو 102"
  },
  // ========== المستوى الثالث ==========
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
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية عملي (3)",
    "course_code": "CHEM 315",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء غير العضوية",
    "course_name": "كيمياء غير عضوية (2) – تناسقية وانتقالية",
    "course_code": "CHEM 321",
    "credit_hours": "2",
    "prerequisites": "CHEM 222"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء التحليلية",
    "course_name": "كيمياء تحليلية (2)",
    "course_code": "CHEM 331",
    "credit_hours": "2",
    "prerequisites": "CHEM 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء التحليلية",
    "course_name": "كيمياء تحليلية عملي (2)",
    "course_code": "CHEM 333",
    "credit_hours": "1",
    "prerequisites": "CHEM 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية (4) – كيمياء السطوح والحفز",
    "course_code": "CHEM 341",
    "credit_hours": "2",
    "prerequisites": "CHEM 242"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية عملي (2)",
    "course_code": "CHEM 343",
    "credit_hours": "1",
    "prerequisites": "CHEM 243"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "الكيمياء العضوية الفيزيائية (1)",
    "course_code": "CHEM 312",
    "credit_hours": "2",
    "prerequisites": "CHEM 211 أو 212"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية – طيف",
    "course_code": "CHEM 314",
    "credit_hours": "2",
    "prerequisites": "CHEM 212"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية عملي (4)",
    "course_code": "CHEM 316",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء غير العضوية",
    "course_name": "كيمياء غير عضوية (3)",
    "course_code": "CHEM 322",
    "credit_hours": "2",
    "prerequisites": "CHEM 222"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية (5) – كيمياء كهربائية وكيمياء ضوئية",
    "course_code": "CHEM 342",
    "credit_hours": "2",
    "prerequisites": "CHEM 241"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية عملي (3)",
    "course_code": "CHEM 344",
    "credit_hours": "1",
    "prerequisites": "CHEM 243"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الجيولوجيا",
    "course_name": "بلورات ومعادن وصخور",
    "course_code": "GEOL 320",
    "credit_hours": "2",
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
    "department": "الكيمياء",
    "course_name": "مشروع بحث (1)",
    "course_code": "CHEM 451",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية فيزيائية (2)",
    "course_code": "CHEM 411",
    "credit_hours": "2",
    "prerequisites": "CHEM 312"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كربوهيدرات",
    "course_code": "CHEM 413",
    "credit_hours": "1",
    "prerequisites": "CHEM 211"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء غير العضوية",
    "course_name": "كيمياء غير عضوية (5) – نووية وفلز عضوية",
    "course_code": "CHEM 421",
    "credit_hours": "2",
    "prerequisites": "CHEM 321"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء التحليلية",
    "course_name": "كيمياء تحليلية (3) – التحليل الكهربي",
    "course_code": "CHEM 431",
    "credit_hours": "2",
    "prerequisites": "CHEM 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية (6) – كهربية وأسمنت",
    "course_code": "CHEM 441",
    "credit_hours": "2",
    "prerequisites": "CHEM 342"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الفيزياء",
    "course_name": "أساسيات الإلكترونيات",
    "course_code": "PHYS 403",
    "credit_hours": "2",
    "prerequisites": "PHYS 102"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "مشروع بحث (2)",
    "course_code": "CHEM 452",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "منتجات طبيعية",
    "course_code": "CHEM 412",
    "credit_hours": "2",
    "prerequisites": "CHEM 314"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء العضوية",
    "course_name": "كيمياء عضوية عملي (5)",
    "course_code": "CHEM 414",
    "credit_hours": "1",
    "prerequisites": "CHEM 316"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء غير العضوية",
    "course_name": "كيمياء غير عضوية (5) – نظرية المجموعات وطيفية",
    "course_code": "CHEM 422",
    "credit_hours": "2",
    "prerequisites": "CHEM 322"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء التحليلية",
    "course_name": "كيمياء تحليلية (4) – طرق الفصل",
    "course_code": "CHEM 432",
    "credit_hours": "1",
    "prerequisites": "CHEM 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name":
        "كيمياء فيزيائية (7) – بوليمرات وميكانيكا الكم وتآكل المعادن",
    "course_code": "CHEM 442",
    "credit_hours": "3",
    "prerequisites": "CHEM 241"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الفيزيائية",
    "course_name": "كيمياء فيزيائية عملي متقدم",
    "course_code": "CHEM 444",
    "credit_hours": "1",
    "prerequisites": "CHEM 344"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علوم الحاسب",
    "course_name": "تطبيقات الحاسب في الكيمياء",
    "course_code": "COMP 420",
    "credit_hours": "2",
    "prerequisites": "-"
  },
];

class ChemistryCoursesScreen extends StatefulWidget {
  const ChemistryCoursesScreen({super.key});
  @override
  State<ChemistryCoursesScreen> createState() => _ChemistryCoursesScreenState();
}

class _ChemistryCoursesScreenState extends State<ChemistryCoursesScreen>
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
        title: const Text('الكيمياء – تخصص منفرد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C1D95),
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
      color: const Color(0xFF4C1D95),
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
                  colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF4C1D95).withValues(alpha: 0.3),
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
    if (dept.contains('العضوية')) return const Color(0xFF7C3AED);
    if (dept.contains('غير العضوية')) return const Color(0xFF4C1D95);
    if (dept.contains('الفيزيائية')) return const Color(0xFF0284C7);
    if (dept.contains('التحليلية')) return const Color(0xFF059669);
    if (dept.contains('فيزياء') ||
        dept.contains('PHYS') ||
        dept.contains('BIOP')) {
      return const Color(0xFFDC2626);
    }
    if (dept.contains('رياضيات')) return const Color(0xFF2563EB);
    if (dept.contains('جيولوجيا')) return const Color(0xFF92400E);
    if (dept.contains('حاسب')) return const Color(0xFF6D28D9);
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
