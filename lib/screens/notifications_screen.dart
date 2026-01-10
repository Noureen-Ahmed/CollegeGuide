import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/announcement.dart';
import '../providers/announcement_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                        icon: const Icon(Icons.arrow_back, size: 24),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      announcementsAsync.when(
                        data: (announcements) {
                          final unreadCount = announcements.where((a) => !a.isRead).length;
                          if (unreadCount > 0) {
                            return Row(
                              children: [
                                TextButton(
                                  onPressed: () => _markAllAsRead(),
                                  child: const Text(
                                    'Mark all read',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2563EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$unreadCount new',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const TabBar(
                    labelColor: Color(0xFF2563EB),
                    unselectedLabelColor: Color(0xFF6B7280),
                    indicatorColor: Color(0xFF2563EB),
                    indicatorWeight: 3,
                    labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Unread'),
                      Tab(text: 'Read'),
                    ],
                  ),
                ],
              ),
            ),
            
            // Notifications List
            Expanded(
              child: announcementsAsync.when(
                data: (announcements) {
                  return TabBarView(
                    children: [
                      _buildNotificationList(
                        announcements,
                        'No notifications',
                      ),
                      _buildNotificationList(
                        announcements.where((a) => !a.isRead).toList(),
                        'No unread notifications',
                      ),
                      _buildNotificationList(
                        announcements.where((a) => a.isRead).toList(),
                        'No read notifications',
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error loading notifications: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildNotificationList(List<Announcement> announcements, String emptyMessage) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(announcementsProvider.future),
      child: announcements.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          emptyMessage,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Dismissible(
                  key: Key(announcement.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _dismissNotification(announcement.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  child: NotificationCard(
                    announcement: announcement,
                    onTap: () => _markAsRead(announcement.id),
                    onMarkAsRead: () => _markAsRead(announcement.id),
                  ),
                );
              },
            ),
    );
  }

  void _markAsRead(String announcementId) {
    ref.read(announcementControllerProvider.notifier)
        .markAsRead(announcementId);
  }

  void _markAllAsRead() {
    ref.read(announcementControllerProvider.notifier).markAllAsRead();
  }

  void _dismissNotification(String announcementId) {
    // Mark as read when dismissed (or could delete if that functionality exists)
    ref.read(announcementControllerProvider.notifier)
        .markAsRead(announcementId);
  }
}

class NotificationCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.announcement,
    required this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getNotificationColors(announcement.type);
    final icon = _getNotificationIcon(announcement.type);
    final timeAgo = _formatTimeAgo(announcement.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: announcement.isRead ? Colors.white : colors['bg'],
          border: Border.all(
            color: announcement.isRead ? const Color(0xFFE5E7EB) : colors['border']!,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: icon),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course code and name
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getCourseCode(announcement),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '•',
                            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getCourseName(announcement),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Title
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Message
                      Text(
                        announcement.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Time and due date
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          if (_hasDueDate(announcement)) ...[
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                border: Border.all(color: const Color(0xFFFECACA)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getDueDate(announcement),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Mark as read button for unread notifications
            if (!announcement.isRead && onMarkAsRead != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onMarkAsRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 12, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          'Mark read',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Map<String, Color> _getNotificationColors(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.assignment:
        return {
          'bg': const Color(0xFFEFF6FF), // blue-50
          'border': const Color(0xFFBFDBFE), // blue-200
        };
      case AnnouncementType.exam:
        return {
          'bg': const Color(0xFFFEF2F2), // red-50
          'border': const Color(0xFFFECACA), // red-200
        };
      case AnnouncementType.general:
        return {
          'bg': const Color(0xFFFFFBEF), // yellow-50
          'border': const Color(0xFFFDE68A), // yellow-200
        };
      case AnnouncementType.event:
        return {
          'bg': const Color(0xFFF0FDF4), // green-50
          'border': const Color(0xFFBBF7D0), // green-200
        };
    }
  }

  Widget _getNotificationIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.assignment:
        return const Icon(Icons.description, size: 20, color: Color(0xFF2563EB));
      case AnnouncementType.exam:
        return const Icon(Icons.event, size: 20, color: Color(0xFFDC2626));
      case AnnouncementType.general:
        return const Icon(Icons.campaign, size: 20, color: Color(0xFFF59E0B));
      case AnnouncementType.event:
        return const Icon(Icons.menu_book, size: 20, color: Color(0xFF10B981));
    }
  }

  String _getCourseCode(Announcement announcement) {
    return announcement.courseCode ?? 'COURSE';
  }

  String _getCourseName(Announcement announcement) {
    return announcement.courseName ?? 'General Announcement';
  }

  bool _hasDueDate(Announcement announcement) {
    return announcement.type == AnnouncementType.assignment || 
           announcement.type == AnnouncementType.exam;
  }

  String _getDueDate(Announcement announcement) {
    final dueDate = announcement.date.add(const Duration(days: 7)); // Example due date
    return 'Due: ${DateFormat('MMM d, yyyy').format(dueDate)}';
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}