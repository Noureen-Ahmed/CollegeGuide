import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_session_provider.dart';
import '../../models/user.dart';
import '../../widgets/user_avatar.dart';
import '../edit_profile_screen.dart';

class ProfessorProfileScreen extends ConsumerWidget {
  const ProfessorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          return CustomScrollView(
            slivers: [
              _buildSliverHeader(context, user),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // No Academic Stats for Professor (GPA/Level)
                      // Instead, show Course Count or Department info prominently

                      _buildDetailRow(
                          'Department', user.department ?? 'Faculty'),
                      const SizedBox(height: 8),
                      // Professors don't usually have "Program" or "Major" in the same way,
                      // but if they do, show it. Often it's just Dept.
                      if (user.program != null && user.program!.isNotEmpty) ...[
                        _buildDetailRow('Specialization', user.program!),
                        const SizedBox(height: 8),
                      ],

                      const SizedBox(height: 32),
                      _buildSectionHeader('Account Settings'),
                      const SizedBox(height: 12),
                      _buildListCard([
                        _buildSettingsTile(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your contact logic',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfileScreen()),
                          ),
                        ),
                        _buildSettingsTile(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Secure your faculty account',
                          onTap: () => _showChangePasswordDialog(context, ref),
                        ),
                      ]),

                      const SizedBox(height: 32),
                      _buildSectionHeader('System'),
                      const SizedBox(height: 12),
                      _buildListCard([
                        _buildSettingsTile(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          subtitle: 'Manage administrative alerts',
                          onTap: () => context.push('/notifications'),
                        ),
                        _buildSettingsTile(
                          icon: Icons.info_outline,
                          title: 'About System',
                          subtitle: 'Version 2.0.1',
                          onTap: () => _showAboutDialog(context),
                        ),
                      ]),

                      const SizedBox(height: 48),
                      _buildLogoutButton(context, ref),
                      const SizedBox(height: 100),
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

  Widget _buildSliverHeader(BuildContext context, User user) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF1E3A8A), // Darker blue for Profs
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              top: -50,
              right: -50,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: Colors.white.withOpacity(0.05),
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
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
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
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Faculty Member',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          context.go('/home'); // Or wherever dashboard is
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E3A8A),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildListCard(List<Widget> children) {
    return Container(
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
          color: const Color(0xFF1E3A8A).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF1E3A8A), size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF1E3A8A)),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    // Re-use logic or copy from ProfileScreen
    // ... For brevity, implying same logic.
    // Implementing minimal version:
    final oldController = TextEditingController();
    final newController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: oldController,
                decoration: const InputDecoration(labelText: 'Current'),
                obscureText: true),
            TextField(
                controller: newController,
                decoration: const InputDecoration(labelText: 'New'),
                obscureText: true),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(appSessionControllerProvider.notifier)
                  .changePassword(oldController.text, newController.text);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
          title: Text('About'), content: Text('Faculty Dashboard v2.0')),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(appSessionControllerProvider.notifier).logout();
          if (context.mounted) context.go('/login');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
