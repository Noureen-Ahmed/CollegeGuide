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
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء عامة (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "كيمياء عامة (2)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "عملي كيمياء عامة (2)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء عامة (2)",
    "course_code": "PHYS 103",
    "credit_hours": "3",
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
    "spec": "both",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "تفاضل وتكامل (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "مفاهيم أساسية في الرياضيات",
    "course_code": "MATH 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء عامة (3)",
    "course_code": "PHYS 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء عامة (4)",
    "course_code": "PHYS 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "مقدمة في الحاسب الآلي",
    "course_code": "COMP 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "برمجة حاسب (1)",
    "course_code": "COMP 104",
    "credit_hours": "3",
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
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء حديثة (1)",
    "course_code": "PHYS 201",
    "credit_hours": "2",
    "prerequisites": "PHYS 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "كهرومغناطيسية",
    "course_code": "PHYS 203",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "ديناميكا حرارية",
    "course_code": "PHYS 205",
    "credit_hours": "2",
    "prerequisites": "PHYS 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "both",
    "department": "الرياضيات",
    "course_name": "تحليل متجهات وحساب ممتدات ومصفوفات",
    "course_code": "MATH 225",
    "credit_hours": "3",
    "prerequisites": "MATH 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "تصميم وتحليل الخوارزميات",
    "course_code": "COMP 201",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "نظم قواعد بيانات",
    "course_code": "COMP 207",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "بصريات فيزيائية",
    "course_code": "PHYS 204",
    "credit_hours": "2",
    "prerequisites": "PHYS 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "مقدمة في الدوائر الكهربية",
    "course_code": "PHYS 216",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "both",
    "department": "الإحصاء",
    "course_name": "الإحصاء والاحتمالات",
    "course_code": "STAT 232",
    "credit_hours": "2",
    "prerequisites": "MATH 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "تراكيب البيانات",
    "course_code": "COMP 202",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "برمجة حاسب متقدمة",
    "course_code": "COMP 212",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "elective",
    "spec": "both",
    "department": "الرياضيات (اختياري)",
    "course_name": "معادلات تفاضلية عادية",
    "course_code": "MATH 202",
    "credit_hours": "3",
    "prerequisites": "MATH 101 أو 102"
  },
  {
    "level": "2",
    "type": "elective",
    "spec": "phys",
    "department": "الفيزياء (اختياري)",
    "course_name": "فيزياء حسابية",
    "course_code": "PHYS 210",
    "credit_hours": "3",
    "prerequisites": "MATH 102"
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
    "course_code": "ETHR 303",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "نظرية التعقد",
    "course_code": "COMP 305",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "نظم التشغيل",
    "course_code": "COMP 307",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "اتصالات بصرية",
    "course_code": "PHYS 382",
    "credit_hours": "2",
    "prerequisites": "PHYS 204"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "ميكانيكا إحصائية",
    "course_code": "PHYS 360",
    "credit_hours": "2",
    "prerequisites": "PHYS 205, STAT 232"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "إلكترونيات",
    "course_code": "PHYS 364",
    "credit_hours": "2",
    "prerequisites": "PHYS 206"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء نووية",
    "course_code": "PHYS 358",
    "credit_hours": "2",
    "prerequisites": "PHYS 201"
  },
  {
    "level": "3",
    "type": "elective",
    "spec": "cs",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "قواعد ودلالات لغات البرمجة",
    "course_code": "COMP 303",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "spec": "cs",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "نظم الوسائط المتعددة",
    "course_code": "COMP 309",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "spec": "cs",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "اللغات التصريحية",
    "course_code": "COMP 311",
    "credit_hours": "2",
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
    "type": "elective",
    "spec": "both",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "ثقافة بيئية",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "both",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "نشأة وتاريخ وتطور العلوم",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "إلكترونيات رقمية",
    "course_code": "PHYS 449",
    "credit_hours": "2",
    "prerequisites": "PHYS 364"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء نانوية وتقنية النانو",
    "course_code": "PHYS 461",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "مقدمة في المواد الفوتونية",
    "course_code": "PHYS 471",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء حسابية متقدمة",
    "course_code": "PHYS 476",
    "credit_hours": "3",
    "prerequisites": "PHYS 315"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "فيزياء تجريبية",
    "course_code": "PHYS 438",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "الفيزياء (تخصص أول)",
    "course_name": "نبائط أشباه موصلات وتطبيقاتها",
    "course_code": "PHYS 470",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "ذكاء اصطناعي",
    "course_code": "COMP 401",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "المعالجة المتوازية والموزعة",
    "course_code": "COMP 403",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "المعلوماتية الحيوية",
    "course_code": "COMP 402",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 212"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "علوم الحاسب (تخصص ثاني)",
    "course_name": "مشروع حاسب (مزدوج)",
    "course_code": "COMP 418",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "الفيزياء (اختياري)",
    "course_name": "إلكترونيات كمية",
    "course_code": "PHYS 469",
    "credit_hours": "2",
    "prerequisites": "PHYS 315"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "الفيزياء (اختياري)",
    "course_name": "أطياف الليزر",
    "course_code": "PHYS 465",
    "credit_hours": "2",
    "prerequisites": "PHYS 371"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "الفيزياء (اختياري)",
    "course_name": "خواص كهربائية وضوئية ومغناطيسية للمواد",
    "course_code": "PHYS 468",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "الفيزياء (اختياري)",
    "course_name": "مواد الإلكترونيات",
    "course_code": "PHYS 472",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "cs",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "معالجة الصور",
    "course_code": "COMP 407",
    "credit_hours": "3",
    "prerequisites": "COMP 212"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "cs",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "الهندسة الحسابية",
    "course_code": "COMP 411",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 212"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "cs",
    "department": "علوم الحاسب (اختياري)",
    "course_name": "موضوعات مختارة في الخوارزميات",
    "course_code": "COMP 413",
    "credit_hours": "3",
    "prerequisites": "COMP 201"
  },
];

class PhysicsCSCoursesScreen extends StatefulWidget {
  const PhysicsCSCoursesScreen({super.key});
  @override
  State<PhysicsCSCoursesScreen> createState() => _PhysicsCSCoursesScreenState();
}

class _PhysicsCSCoursesScreenState extends State<PhysicsCSCoursesScreen>
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
      if (_filterSpec == 'phys') {
        return c['spec'] == 'phys' || c['spec'] == 'both';
      }
      if (_filterSpec == 'cs') return c['spec'] == 'cs' || c['spec'] == 'both';
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
        title: const Text('فيزياء – علوم الحاسب (مزدوج)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: const Color(0xFF7C2D12),
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
      color: const Color(0xFF7C2D12),
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
                  color: const Color(0xFF7C2D12),
                  onTap: () => setState(() => _filterSpec = 'all')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'الفيزياء',
                  selected: _filterSpec == 'phys',
                  color: const Color(0xFFDC2626),
                  onTap: () => setState(() => _filterSpec = 'phys')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'علوم الحاسب',
                  selected: _filterSpec == 'cs',
                  color: const Color(0xFF6D28D9),
                  onTap: () => setState(() => _filterSpec = 'cs')),
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
                  colors: [Color(0xFF7C2D12), Color(0xFFDC2626)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF7C2D12).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
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
    final spec = course['spec'] ?? '';
    final dept = course['department'] ?? '';
    if (spec == 'phys' || dept.contains('فيزياء')) {
      return const Color(0xFFDC2626);
    }
    if (spec == 'cs' || dept.contains('حاسب')) return const Color(0xFF6D28D9);
    if (dept.contains('رياضيات')) return const Color(0xFF2563EB);
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
