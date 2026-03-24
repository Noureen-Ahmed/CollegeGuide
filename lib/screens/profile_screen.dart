import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_session_provider.dart';
import '../models/user.dart';
import '../widgets/user_avatar.dart';
import 'edit_profile_screen.dart';
import 'professor/professor_profile_screen.dart';
import '../providers/task_provider.dart';
import '../providers/course_provider.dart';
import '../providers/schedule_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          if (user.mode == AppMode.professor) {
            return const ProfessorProfileScreen();
          }

          return CustomScrollView(
            slivers: [
              _buildSliverHeader(context, user, ref),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAcademicStats(context, user, ref),
                      const SizedBox(height: 24),
                      _buildDetailRow('Student ID', user.studentId ?? user.email.split('@').first),
                      const SizedBox(height: 8),
                      _buildDetailRow('Faculty', user.faculty ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Department', user.department ?? 'Undeclared'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Program', user.major ?? 'Undeclared'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Phone', user.phone ?? 'N/A'),
                      const SizedBox(height: 8),
                      if (user.academicYear != null) ...[
                        _buildDetailRow('Academic Year', user.academicYear!),
                        const SizedBox(height: 8),
                      ],
                      if (user.semester != null) ...[
                        _buildDetailRow('Semester', user.semester!),
                        const SizedBox(height: 8),
                      ],
                      if (user.level != null) ...[
                        _buildDetailRow('Level', 'Level ${user.level}'),
                        const SizedBox(height: 8),
                      ],
                      if (user.advisorName != null && user.advisorName!.isNotEmpty) ...[
                        _buildDetailRow('Advisor Name', user.advisorName!),
                        const SizedBox(height: 8),
                      ],
                      if (user.advisorEmail != null && user.advisorEmail!.isNotEmpty) ...[
                        _buildDetailRow('Advisor Email', user.advisorEmail!),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 32),
                      _buildSectionHeader('General Settings'),
                      const SizedBox(height: 12),
                      _buildListCard([
                        _buildSettingsTile(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your GPA or profile photo',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                          ),
                        ),
                        _buildSettingsTile(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update your security credentials',
                          onTap: () => _showChangePasswordDialog(context, ref),
                        ),
                      ]),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Application'),
                      const SizedBox(height: 12),
                      _buildListCard([
                        _buildSettingsTile(
                          icon: Icons.info_outline,
                          title: 'About Student Dash',
                          subtitle: 'Learn more about your academic companion',
                          onTap: () => _showAboutDialog(context),
                        ),
                      ]),
                      const SizedBox(height: 48),
                      _buildLogoutButton(context, ref),
                      const SizedBox(height: 100), // Bottom navigation padding
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, User user, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF002147),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF002147), Color(0xFF003A5D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Abstract decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFDC800), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF002147).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: UserAvatar(
                      avatarUrl: user.avatar,
                      name: user.name,
                      size: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.nameAr ?? user.name,
                  style: const TextStyle(
                    color: Color(0xFFFDC800),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  user.studentId ?? user.email.split('@').first,
                  style: TextStyle(
                    color: const Color(0xFFFDC800).withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFFDC800)),
        onPressed: () {
          context.go('/home');
        },
      ),
    );
  }

  Widget _buildAcademicStats(BuildContext context, User user, WidgetRef ref) {
    final coursesAsync = ref.watch(enrolledCoursesProvider);
    final courseCount = coursesAsync.whenOrNull(data: (courses) => courses.length) ?? 0;
    return Row(
      children: [
        Expanded(child: _buildStatItem('GPA', user.gpa?.toString() ?? 'N/A', Colors.amber)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('Level', user.level?.toString() ?? 'N/A', Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('Courses', courseCount.toString(), Colors.blue)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF002147).withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFDC800),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF002147),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildListCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF002147).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF002147), size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF002147)),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context, ref),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFF002147),
          foregroundColor: const Color(0xFFFDC800),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text(
          'Logout Session',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF002147).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF002147), size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Student Dash 2.0',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your ultimate academic companion. Designed to help you track your schedule, assignments, and exams with ease. We believe university life should be about learning, not managing spreadsheets.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.6),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002147),
                    foregroundColor: const Color(0xFFFDC800),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Stay Awesome!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Change Password', style: TextStyle(color: Color(0xFF002147), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await ref.read(appSessionControllerProvider.notifier)
                  .changePassword(oldController.text, newController.text);
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result ? 'Password updated!' : 'Update failed'),
                    backgroundColor: result ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF002147),
              foregroundColor: const Color(0xFFFDC800),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout', style: TextStyle(color: Color(0xFF002147), fontWeight: FontWeight.bold)),
        content: const Text('Ready to sign out of your student dashboard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(appSessionControllerProvider.notifier).logout();
              
              // Clear previous user data
              ref.invalidate(taskStateProvider);
              ref.invalidate(scheduleEventsProvider);
              ref.invalidate(enrolledCoursesProvider);
              ref.invalidate(upcomingEventsProvider);
              
              if (context.mounted) context.go('/login');
            },
            child: const Text('Logout', style: TextStyle(color: Color(0xFF002147), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withOpacity(0.03),
             blurRadius: 10,
             offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF002147), fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}