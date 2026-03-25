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
    "credit_hours": "3",
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
    "department": "الميكروبيولوجيا",
    "course_name": "مقدمة في علم البكتريا",
    "course_code": "MICR 221",
    "credit_hours": "3",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "مقدمة في علم الفطريات",
    "course_code": "MICR 231",
    "credit_hours": "3",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "بيئة ميكروبية",
    "course_code": "MICR 253",
    "credit_hours": "1",
    "prerequisites": "MICR 102"
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
    "department": "الكيمياء الحيوية",
    "course_name": "كيمياء حيوية",
    "course_code": "BIOC 221",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "تقنيات ميكروبيولوجية",
    "course_code": "MICR 283",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الجيولوجيا",
    "course_name": "مقدمة في الجيولوجيا",
    "course_code": "GEOL 255",
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
    "department": "علم النبات",
    "course_name": "نباتات طبية وعطرية",
    "course_code": "BOTA 219",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "مقدمة في علم الفيروسات",
    "course_code": "MICR 212",
    "credit_hours": "2",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا بيئية",
    "course_code": "MICR 252",
    "credit_hours": "2",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "تلوث ميكروبي",
    "course_code": "MICR 254",
    "credit_hours": "1",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "بيولوجيا جزيئية (1)",
    "course_code": "MICR 262",
    "credit_hours": "2",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "وراثة ميكروبية",
    "course_code": "MICR 264",
    "credit_hours": "1",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "إنزيمات ميكروبية",
    "course_code": "MICR 272",
    "credit_hours": "2",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "النانو تكنولوجيا الحيوية",
    "course_code": "MICR 282",
    "credit_hours": "1",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء عضوية [أحماض أمينية وبروتين + سكريات]",
    "course_code": "CHEM 254",
    "credit_hours": "2",
    "prerequisites": "CHEM 101"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "مهارات بحثية",
    "course_code": "MICR 284",
    "credit_hours": "2",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "بيولوجيا إشعاعية",
    "course_code": "MICR 286",
    "credit_hours": "2",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "علم النبات",
    "course_name": "فسيولوجيا العلاقات المائية",
    "course_code": "BOTA 206",
    "credit_hours": "2",
    "prerequisites": "-"
  },

  // ========== المستوى الثالث ==========
  {
    "level": "3",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "تقسيم فطريات",
    "course_code": "MICR 331",
    "credit_hours": "3",
    "prerequisites": "MICR 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا الغذاء",
    "course_code": "MICR 355",
    "credit_hours": "2",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الكيمياء",
    "course_name": "كيمياء تحليلية [الطرق البصرية للتحليل والكروماتوجرافيا]",
    "course_code": "CHEM 301",
    "credit_hours": "2",
    "prerequisites": "CHEM 101"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "تحلل حيوي",
    "course_code": "MICR 383",
    "credit_hours": "1",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الإحصاء",
    "course_name": "إحصاء حيوي",
    "course_code": "STAT 321",
    "credit_hours": "2",
    "prerequisites": "STAT 209"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا التربة",
    "course_code": "MICR 353",
    "credit_hours": "2",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "بيولوجيا جزيئية (2)",
    "course_code": "MICR 361",
    "credit_hours": "2",
    "prerequisites": "MICR 262"
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
    "department": "الميكروبيولوجيا",
    "course_name": "تقسيم فيروسات",
    "course_code": "MICR 312",
    "credit_hours": "3",
    "prerequisites": "MICR 212"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "أكتينوميسيتات",
    "course_code": "MICR 322",
    "credit_hours": "2",
    "prerequisites": "MICR 221"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا طبقات الأرض",
    "course_code": "MICR 352",
    "credit_hours": "1",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "فسيولوجيا وأيض الكائنات الدقيقة",
    "course_code": "MICR 372",
    "credit_hours": "3",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "مضادات حياتية",
    "course_code": "MICR 384",
    "credit_hours": "2",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "بكتريوفاج",
    "course_code": "MICR 314",
    "credit_hours": "2",
    "prerequisites": "MICR 212"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "تحولات ميكروبية",
    "course_code": "MICR 374",
    "credit_hours": "2",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "تحكم في الكائنات الدقيقة",
    "course_code": "MICR 386",
    "credit_hours": "2",
    "prerequisites": "-"
  },

  // ========== المستوى الرابع ==========
  {
    "level": "4",
    "type": "elective",
    "department": "متطلب جامعة",
    "course_name": "مهارات العمل",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "متطلب جامعة",
    "course_name": "ثقافة بيئية",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "متطلب جامعة",
    "course_name": "نشأة وتاريخ وتطور العلوم",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "فيروسات طبية",
    "course_code": "MICR 411",
    "credit_hours": "3",
    "prerequisites": "MICR 312"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "خميرة",
    "course_code": "MICR 433",
    "credit_hours": "2",
    "prerequisites": "MICR 231"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "معلومات حياتية",
    "course_code": "MICR 461",
    "credit_hours": "1",
    "prerequisites": "MICR 262"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "هندسة وراثية",
    "course_code": "MICR 463",
    "credit_hours": "1",
    "prerequisites": "MICR 262"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "أمراض نبات (1)",
    "course_code": "MICR 481",
    "credit_hours": "2",
    "prerequisites": "MICR 321, MICR 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا صناعية",
    "course_code": "MICR 483",
    "credit_hours": "2",
    "prerequisites": "MICR 372"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "سموم ميكروبية",
    "course_code": "MICR 487",
    "credit_hours": "1",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "أسس علم المناعة",
    "course_code": "MICR 489",
    "credit_hours": "1",
    "prerequisites": "MICR 212"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا الماء والصرف",
    "course_code": "MICR 451",
    "credit_hours": "2",
    "prerequisites": "MICR 221, MICR 231"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "تمثيل جيني",
    "course_code": "MICR 465",
    "credit_hours": "2",
    "prerequisites": "MICR 262"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "فسيولوجيا أمراض نبات",
    "course_code": "MICR 471",
    "credit_hours": "1",
    "prerequisites": "MICR 372"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "ميكروبيولوجيا تشخيصية",
    "course_code": "MICR 485",
    "credit_hours": "3",
    "prerequisites": "MICR 312, MICR 321, MICR 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "بكتيريا طبية",
    "course_code": "MICR 422",
    "credit_hours": "3",
    "prerequisites": "MICR 321"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "فطريات طبية",
    "course_code": "MICR 432",
    "credit_hours": "3",
    "prerequisites": "MICR 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "أمراض نبات (2)",
    "course_code": "MICR 482",
    "credit_hours": "2",
    "prerequisites": "MICR 312, MICR 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الكيمياء الحيوية",
    "course_name": "سوائل الجسم",
    "course_code": "BIOC 424",
    "credit_hours": "3",
    "prerequisites": "BIOC 221"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "علم الحيوان",
    "course_name": "مقدمة في علم الطفيليات",
    "course_code": "ZOOL 426",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "الميكروبيولوجيا",
    "course_name": "تقنية حيوية",
    "course_code": "MICR 472",
    "credit_hours": "1",
    "prerequisites": "MICR 372"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "مناعة جزيئية",
    "course_code": "MICR 480",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "مزارع خلايا وأنسجة",
    "course_code": "MICR 486",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "موضوعات مختارة",
    "course_code": "MICR 488",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "الميكروبيولوجيا",
    "course_name": "بحث تخرج",
    "course_code": "MICR 490",
    "credit_hours": "2",
    "prerequisites": "-"
  }
];

class MicrobiologyCoursesScreen extends StatefulWidget {
  const MicrobiologyCoursesScreen({super.key});
  @override
  State<MicrobiologyCoursesScreen> createState() =>
      _MicrobiologyCoursesScreenState();
}

class _MicrobiologyCoursesScreenState extends State<MicrobiologyCoursesScreen>
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
        title: const Text('ميكروبيولوجي – منفرد',
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
    if (dept.contains('الميكروبيولوجيا') || dept.contains('MICR'))
      return const Color(0xFF6D28D9);
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
    if (dept.contains('الجيولوجيا') || dept.contains('GEOL'))
      return const Color(0xFF92400E);
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
