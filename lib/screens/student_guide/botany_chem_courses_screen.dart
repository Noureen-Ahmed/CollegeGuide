import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== المستوى الأول ==========
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "متطلبات جامعة",
    "course_name": "الأمن والسلامة",
    "course_code": "SAFS 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "متطلبات جامعة",
    "course_name": "حقوق الإنسان",
    "course_code": "HURI 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "الرياضيات (متطلبات كلية)",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "الفيزياء (متطلبات كلية)",
    "course_name": "فيزياء عامة (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (متطلبات كلية)",
    "course_name": "كيمياء عامة (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (متطلبات كلية)",
    "course_name": "عملي كيمياء عامة (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (متطلبات كلية)",
    "course_name": "أساسيات علم النبات (1)",
    "course_code": "BOTA 101",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "علم الحيوان (متطلبات كلية)",
    "course_name": "علم الحيوان (1)",
    "course_code": "ZOOL 101",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "متطلبات جامعة",
    "course_name": "لغة إنجليزية (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "متطلبات جامعة",
    "course_name": "مدخل في الحاسب الآلي",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (متطلبات كلية)",
    "course_name": "كيمياء (2)",
    "course_code": "CHEM 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (متطلبات كلية)",
    "course_name": "عملي كيمياء عامة (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (متطلبات كلية)",
    "course_name": "أساسيات علم النبات (2)",
    "course_code": "BOTA 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "علم الحيوان (متطلبات كلية)",
    "course_name": "علم الحيوان (2)",
    "course_code": "ZOOL 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "الميكروبيولوجي (متطلبات كلية)",
    "course_name": "ميكروبيولوجي",
    "course_code": "MICR 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "علم الحشرات (متطلبات كلية)",
    "course_name": "علم الحشرات",
    "course_code": "ENTM 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  // ========== المستوى الثاني ==========
  {
    "level": "2",
    "type": "mandatory",
    "spec": "both",
    "department": "متطلبات جامعة",
    "course_name": "لغة إنجليزية (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "تشريح نبات",
    "course_code": "BOTA 201",
    "credit_hours": "2",
    "prerequisites": "BOTA 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "أساسيات علم الطحالب",
    "course_code": "BOTA 213",
    "credit_hours": "2",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "أساسيات النظم البيئية",
    "course_code": "BOTA 215",
    "credit_hours": "1",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "أساسيات وأدوات تكنولوجيا الدنا – البروتيومات",
    "course_code": "BOTA 217",
    "credit_hours": "2",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء عضوية أليفاتية أحادية وعديدة المجموعة",
    "course_code": "CHEM 261",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء غير عضوية – نظريات وعناصر s,p",
    "course_code": "CHEM 271",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "أساسيات الكيمياء التحليلية",
    "course_code": "CHEM 281",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "الخلية والجينوم النباتي – الاتجاه التطوري",
    "course_code": "BOTA 220",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء عضوية أروماتية أحادية وعديدة المجموعة",
    "course_code": "CHEM 260",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء فيزيائية – ديناميكا حرارية وكيمياء كهربية",
    "course_code": "CHEM 290",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء فيزيائية – كيمياء حركية",
    "course_code": "CHEM 294",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  // ========== المستوى الثالث ==========
  {
    "level": "3",
    "type": "mandatory",
    "spec": "both",
    "department": "متطلبات جامعة",
    "course_name": "التفكير العلمي",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "both",
    "department": "متطلبات جامعة",
    "course_name": "أخلاقيات البحث العلمي",
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "فسيولوجيا النمو والهرمونات النباتية – زراعة أنسجة نباتية",
    "course_code": "BOTA 321",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "الآليات الأساسية للوراثة",
    "course_code": "BOTA 323",
    "credit_hours": "2",
    "prerequisites": "BOTA 217"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "طحالب البيئات المختلفة في مصر",
    "course_code": "BOTA 325",
    "credit_hours": "2",
    "prerequisites": "BOTA 213"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء عضوية – الكيمياء الفراغية والسكريات",
    "course_code": "CHEM 361",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء غير عضوية – كيمياء تناسقية",
    "course_code": "CHEM 371",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء فيزيائية – كيمياء السطوح والحفز والبلمرات",
    "course_code": "CHEM 391",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "أساسيات علم الأرشيجونيات",
    "course_code": "BOTA 322",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "من تميز البروتينات إلى هندسة البروتينات",
    "course_code": "BOTA 324",
    "credit_hours": "1",
    "prerequisites": "BOTA 217"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "الحياة البرية والموارد البيئية الطبيعية",
    "course_code": "BOTA 326",
    "credit_hours": "1",
    "prerequisites": "BOTA 215"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء عضوية – الأصباغ والأطياف العضوية",
    "course_code": "CHEM 360",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء تحليلية – التحليل بالأجهزة",
    "course_code": "CHEM 380",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  // ========== المستوى الرابع ==========
  {
    "level": "4",
    "type": "elective",
    "spec": "both",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "مهارات العمل",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "فسيولوجيا الإنبات والإكثار",
    "course_code": "BOTA 427",
    "credit_hours": "2",
    "prerequisites": "BOTA 321"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "النواحي التطبيقية للأرشيجونيات والحفريات",
    "course_code": "BOTA 429",
    "credit_hours": "2",
    "prerequisites": "BOTA 322"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "مقدمة في علم الأجنة",
    "course_code": "BOTA 431",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء عضوية – ميكانيكية تفاعلات وتربينات",
    "course_code": "CHEM 461",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "الكيمياء الحيوية غير عضوية والطيفية الكيميائية",
    "course_code": "CHEM 471",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name":
        "كيمياء فيزيائية – الديناميكا الحرارية للمحاليل الإلكتروليتية",
    "course_code": "CHEM 491",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "أيض النبات",
    "course_code": "BOTA 422",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name": "نباتات عقاقير طبية – تصنيف وفلورا كيميائي",
    "course_code": "BOTA 424",
    "credit_hours": "3",
    "prerequisites": "BOTA 216"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "النبات (تخصص أول)",
    "course_name":
        "تقنيات تضاعف الحمض النووي DNA بإستخدام تفاعل البلمرة المتسلسل",
    "course_code": "BOTA 426",
    "credit_hours": "2",
    "prerequisites": "BOTA 323"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء عضوية – غير متجانسة وقلويدات",
    "course_code": "CHEM 460",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء فيزيائية – كيمياء ضوئية",
    "course_code": "CHEM 490",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "الكيمياء (تخصص ثاني)",
    "course_name": "كيمياء غير عضوية – سلاسل والمتراكبات العنقودية",
    "course_code": "CHEM 470",
    "credit_hours": "1",
    "prerequisites": "-"
  },
];

class BotanyChemCoursesScreen extends StatefulWidget {
  const BotanyChemCoursesScreen({super.key});
  @override
  State<BotanyChemCoursesScreen> createState() =>
      _BotanyChemCoursesScreenState();
}

class _BotanyChemCoursesScreenState extends State<BotanyChemCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';
  String _filterSpec = 'all';

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
      if (_filterSpec == 'bota') {
        return c['spec'] == 'bota' || c['spec'] == 'both';
      }
      if (_filterSpec == 'chem') {
        return c['spec'] == 'chem' || c['spec'] == 'both';
      }
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
        title: const Text('النبات – كيمياء (مزدوج)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: const Color(0xFF14532D),
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
          _buildFilters(),
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

  Widget _buildFilters() {
    return Container(
      color: const Color(0xFF14532D),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip(
                  label: 'الكل',
                  selected: _filterSpec == 'all',
                  color: const Color(0xFF14532D),
                  onTap: () => setState(() => _filterSpec = 'all')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'النبات',
                  selected: _filterSpec == 'bota',
                  color: const Color(0xFF16A34A),
                  onTap: () => setState(() => _filterSpec = 'bota')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'الكيمياء',
                  selected: _filterSpec == 'chem',
                  color: const Color(0xFF7C3AED),
                  onTap: () => setState(() => _filterSpec = 'chem')),
            ],
          ),
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
                  colors: [Color(0xFF14532D), Color(0xFF16A34A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF14532D).withValues(alpha: 0.3),
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
    final spec = course['spec'] ?? '';
    final dept = course['department'] ?? '';
    if (spec == 'bota' || dept.contains('النبات') || dept.contains('BOTA')) {
      return const Color(0xFF16A34A);
    }
    if (spec == 'chem' || dept.contains('الكيمياء') || dept.contains('CHEM')) {
      return const Color(0xFF7C3AED);
    }
    if (dept.contains('فيزياء') || dept.contains('PHYS')) {
      return const Color(0xFFDC2626);
    }
    if (dept.contains('رياضيات')) return const Color(0xFF2563EB);
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.white30),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 12)),
      ),
    );
  }
}
