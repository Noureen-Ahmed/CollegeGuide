import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/advising_provider.dart';
import '../providers/app_session_provider.dart';
import '../models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class AcademicAdvisingScreen extends ConsumerStatefulWidget {
  const AcademicAdvisingScreen({super.key});

  @override
  ConsumerState<AcademicAdvisingScreen> createState() => _AcademicAdvisingScreenState();
}

class _AcademicAdvisingScreenState extends ConsumerState<AcademicAdvisingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(advisingProvider.notifier).loadAdvisingInfo());
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(appSessionControllerProvider);
    final advisingState = ref.watch(advisingProvider);

    if (session is! AppSessionAuthenticated) {
      return const Center(child: Text('Please login to continue'));
    }

    final isDoctor = session.user.mode == AppMode.professor;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(isDoctor ? 'Academic Advising' : 'Ask your academic advisor'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          if (isDoctor)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(advisingProvider.notifier).loadAdvisingInfo(),
            ),
        ],
      ),
      body: advisingState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : isDoctor
              ? _buildDoctorView(advisingState)
              : _buildStudentView(session, advisingState),
    );
  }

  Widget _buildStudentView(AppSessionAuthenticated session, AdvisingState state) {
    final advisorName = state.advisor?.name ?? session.user.advisorName;
    final advisorEmail = state.advisor?.email ?? session.user.advisorEmail;

    if (advisorName == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No academic advisor assigned yet. Please contact the administration.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
            child: const Icon(Icons.person, size: 50, color: Color(0xFF6366F1)),
          ),
          const SizedBox(height: 16),
          Text(
            advisorName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            advisorEmail ?? 'No email provided',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              if (advisorEmail != null) {
                final Uri outlookAppUri = Uri.parse('ms-outlook://compose?to=$advisorEmail');
                final Uri outlookWebUri = Uri.parse('https://outlook.office.com/mail/deeplink/compose?to=$advisorEmail');
                
                try {
                  if (await canLaunchUrl(outlookAppUri)) {
                    await launchUrl(outlookAppUri);
                  } else {
                    await launchUrl(outlookWebUri, mode: LaunchMode.externalApplication);
                  }
                } catch (e) {
                  debugPrint('Could not launch Outlook: $e');
                  final Uri fallbackUri = Uri(scheme: 'mailto', path: advisorEmail);
                  if (await canLaunchUrl(fallbackUri)) {
                    await launchUrl(fallbackUri);
                  }
                }
              }
            },
            icon: const Icon(Icons.email),
            label: const Text('Email Advisor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorView(AdvisingState state) {
    final filteredStudents = state.students
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                      s.email.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/advising/broadcast'),
                  icon: const Icon(Icons.campaign),
                  label: const Text('Send for all students'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search for student...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredStudents.isEmpty
              ? const Center(child: Text('No students found'))
              : ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                          child: const Icon(Icons.person, color: Color(0xFF6366F1)),
                        ),
                        title: Text(student.name),
                        subtitle: Text(student.email),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/advising/chat/${student.email}'),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
