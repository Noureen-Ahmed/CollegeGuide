import 'package:flutter/material.dart';

// ===== بيانات الكورسات =====
const List<Map<String, String>> _mathCourses = [
  // ---- المستوى الأول ----
  {
    "level": "1",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الفيزياء (متطلبات الكلية)",
    "course_name": "فيزياء عامة (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "كيمياء عامة (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "عملي كيمياء عامة (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الإحصاء (متطلبات الكلية)",
    "course_name": "مقدمة في الإحصاء",
    "course_code": "STAT 101",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "متطلبات جامعة",
    "course_name": "لغة إنجليزية (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "متطلبات جامعة",
    "course_name": "مدخل في الحاسب الآلي",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "تفاضل وتكامل (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "مفاهيم أساسية في الرياضيات",
    "course_code": "MATH 104",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "ميكانيكا (1)",
    "course_code": "MATH 112",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الفيزياء (متطلبات الكلية)",
    "course_name": "فيزياء عامة (3)",
    "course_code": "PHYS 102",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "علوم الحاسب (متطلبات الكلية)",
    "course_name": "علوم حاسب آلي للرياضيات (حزم + برمجة)",
    "course_code": "COMP 108",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "متطلبات جامعة",
    "course_name": "لغة إنجليزية (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102",
    "type": "mandatory",
  },
  // ---- المستوى الثاني ----
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "التحليل الرياضي",
    "course_code": "MATH 201",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "جبر خطي",
    "course_code": "MATH 203",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "التحليل الاتجاهي وحساب الممتدات",
    "course_code": "MATH 211",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "ميكانيكا (2)",
    "course_code": "MATH 213",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "تاريخ الرياضيات",
    "course_code": "MATH 207",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات (اختياري)",
    "course_name": "نظرية الأعداد",
    "course_code": "MATH 205",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "معادلات تفاضلية عادية",
    "course_code": "MATH 202",
    "credit_hours": "3",
    "prerequisites": "MATH 101 أو 102",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "تحليل حقيقي",
    "course_code": "MATH 204",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "النظرية الكهرومغناطيسية",
    "course_code": "MATH 212",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "ميكانيكا (3)",
    "course_code": "MATH 214",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات (اختياري)",
    "course_name": "نظرية الألعاب",
    "course_code": "MATH 206",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الرياضيات (اختياري)",
    "course_name": "البرمجة الخطية",
    "course_code": "MATH 208",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الرياضيات (اختياري)",
    "course_name": "المنطق الرياضي",
    "course_code": "MATH 222",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الإحصاء (اختياري)",
    "course_name": "مبادئ نظرية الاحتمالات",
    "course_code": "STAT 228",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  // ---- المستوى الثالث ----
  {
    "level": "3",
    "department": "متطلبات جامعة",
    "course_name": "التفكير العلمي",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "الجبر المجرد (1) – نظرية الزمر",
    "course_code": "MATH 301",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "التحليل العددي",
    "course_code": "MATH 303",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "ميكانيكا الأوساط المتصلة",
    "course_code": "MATH 311",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "ميكانيكا الكم (1)",
    "course_code": "MATH 313",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "الهندسة التفاضلية",
    "course_code": "MATH 305",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "نظرية الخوارزميات",
    "course_code": "MATH 307",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "مبادئ حساب التغيرات",
    "course_code": "MATH 331",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "الدوال الخاصة",
    "course_code": "MATH 317",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "مبادئ النمذجة الرياضية",
    "course_code": "MATH 319",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "متطلبات جامعة",
    "course_name": "أخلاقيات البحث العلمي",
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "التوبولوجي العام",
    "course_code": "MATH 302",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "نظرية القياس",
    "course_code": "MATH 304",
    "credit_hours": "3",
    "prerequisites": "MATH 204",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "الإلكتروديناميكا",
    "course_code": "MATH 312",
    "credit_hours": "3",
    "prerequisites": "MATH 212",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات",
    "course_name": "ميكانيكا الكم (2)",
    "course_code": "MATH 314",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "بحوث العمليات",
    "course_code": "MATH 306",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "التشفير الرياضي",
    "course_code": "MATH 308",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "تآلفيات (Combinatorics)",
    "course_code": "MATH 322",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "ميكانيكا الموائع",
    "course_code": "MATH 316",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "نظرية المرونة",
    "course_code": "MATH 318",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "الرياضيات (اختياري)",
    "course_name": "ديناميكا الغازات",
    "course_code": "MATH 332",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  // ---- المستوى الرابع ----
  {
    "level": "4",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "مهارات العمل",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "ثقافة بيئية",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "متطلبات جامعة (اختياري)",
    "course_name": "نشأة وتاريخ وتطور العلوم",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "التحليل الدالي",
    "course_code": "MATH 401",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "التحليل المركب",
    "course_code": "MATH 403",
    "credit_hours": "3",
    "prerequisites": "MATH 204",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "نظرية الجوامد",
    "course_code": "MATH 411",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "النظرية النسبية",
    "course_code": "MATH 413",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "مشروع بحثي رياضيات بحتة",
    "course_code": "MATH 405",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات (اختياري)",
    "course_name": "الهندسة الجبرية",
    "course_code": "MATH 407",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الرياضيات (اختياري)",
    "course_name": "نظرية الرسوم",
    "course_code": "MATH 409",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الرياضيات (اختياري)",
    "course_name": "جبر خطي عددي",
    "course_code": "MATH 421",
    "credit_hours": "2",
    "prerequisites": "MATH 203",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الرياضيات (اختياري)",
    "course_name": "الرياضيات البيولوجية (العمليات المتقطعة)",
    "course_code": "MATH 415",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "الجبر المجرد (2) – الحلقات والحقول",
    "course_code": "MATH 402",
    "credit_hours": "3",
    "prerequisites": "MATH 301",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "المعادلات التفاضلية الجزئية",
    "course_code": "MATH 404",
    "credit_hours": "3",
    "prerequisites": "MATH 202",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "الميكانيكا الإحصائية",
    "course_code": "MATH 412",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "الميكانيكا الفضائية",
    "course_code": "MATH 414",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات",
    "course_name": "مشروع بحثي رياضيات تطبيقية",
    "course_code": "MATH 416",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الرياضيات (اختياري)",
    "course_name": "كوزمولوجي",
    "course_code": "MATH 418",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الرياضيات (اختياري)",
    "course_name": "الضوء الكمي",
    "course_code": "MATH 432",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الرياضيات (اختياري)",
    "course_name": "ميكانيكا الكم النسبية",
    "course_code": "MATH 434",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
];

// ===== الشاشة الرئيسية =====
class MathCoursesScreen extends StatefulWidget {
  const MathCoursesScreen({super.key});

  @override
  State<MathCoursesScreen> createState() => _MathCoursesScreenState();
}

class _MathCoursesScreenState extends State<MathCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all'; // all, mandatory, elective

  static const List<String> _levels = ['1', '2', '3', '4'];
  static const List<String> _levelLabels = [
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

  List<Map<String, String>> _getCoursesForLevel(String level) {
    return _mathCourses.where((c) {
      final matchLevel = c['level'] == level;
      if (_filterType == 'all') return matchLevel;
      return matchLevel && c['type'] == _filterType;
    }).toList();
  }

  int _totalHoursForLevel(String level) {
    return _getCoursesForLevel(level).fold(
        0, (sum, c) => sum + (int.tryParse(c['credit_hours'] ?? '0') ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'رياضيات – تخصص منفرد',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: List.generate(
            _levels.length,
            (i) => Tab(text: 'السنة ${_levelNames[i]}'),
          ),
        ),
      ),
      body: Column(
        children: [
          // ---- شريط الفلتر ----
          _buildFilterBar(),
          // ---- محتوى التابز ----
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                _levels.length,
                (i) => _buildLevelPage(_levels[i], _levelLabels[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _levelNames = [
    'الأولى',
    'الثانية',
    'الثالثة',
    'الرابعة'
  ];

  Widget _buildFilterBar() {
    return Container(
      color: const Color(0xFF1E3A5F),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FilterChip(
            label: 'الكل',
            isSelected: _filterType == 'all',
            color: const Color(0xFF64748B),
            onTap: () => setState(() => _filterType = 'all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'إجباري',
            isSelected: _filterType == 'mandatory',
            color: const Color(0xFF059669),
            onTap: () => setState(() => _filterType = 'mandatory'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'اختياري',
            isSelected: _filterType == 'elective',
            color: const Color(0xFFD97706),
            onTap: () => setState(() => _filterType = 'elective'),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPage(String level, String label) {
    final courses = _getCoursesForLevel(level);
    final totalHours = _totalHoursForLevel(level);

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد مقررات لهذا الفلتر',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // ---- بطاقة ملخص المستوى ----
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
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${courses.length} مقرر',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
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
                        Text(
                          '$totalHours',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'ساعة',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // ---- قائمة الكورسات ----
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CourseCard(course: courses[index]),
                );
              },
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ===== بطاقة الكورس =====
class _CourseCard extends StatelessWidget {
  final Map<String, String> course;

  const _CourseCard({required this.course});

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
        border: Border(
          right: BorderSide(color: typeColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ---- الصف الأول: الكود + النوع ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // نوع المقرر
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // كود المادة
                Text(
                  course['course_code'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ---- اسم المادة ----
            Text(
              course['course_name'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            // ---- القسم ----
            Text(
              course['department'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 12),
            // ---- الساعات والمتطلبات ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // المتطلب السابق
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
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                // الساعات المعتمدة
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
                      Text(
                        '${course['credit_hours']} ساعة',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

// ===== زر الفلتر =====
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.white30,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
