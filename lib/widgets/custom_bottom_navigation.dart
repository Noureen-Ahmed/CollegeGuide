import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_session_provider.dart';
import '../storage_services.dart';

class CustomBottomNavigation extends ConsumerWidget {
  final String currentRoute;
  
  const CustomBottomNavigation({
    super.key,
    required this.currentRoute,
  });

  static const List<Map<String, dynamic>> tabs = [
    {
      'label': 'Home',
      'icon': Icons.home_outlined,
      'activeIcon': Icons.home,
      'route': '/home',
    },
    {
      'label': 'Tasks',
      'icon': Icons.task_outlined,
      'activeIcon': Icons.task,
      'route': '/tasks',
    },
    {
      'label': 'Schedule',
      'icon': Icons.schedule_outlined,
      'activeIcon': Icons.schedule,
      'route': '/schedule',
    },
    {
      'label': 'Navigate',
      'icon': Icons.explore_outlined,
      'activeIcon': Icons.explore,
      'route': '/navigate',
    },
    {
      'label': 'Advising',
      'icon': Icons.chat_bubble_outline,
      'activeIcon': Icons.chat_bubble,
      'route': '/advising',
    },
    {
      'label': 'Profile',
      'icon': Icons.person_outlined,
      'activeIcon': Icons.person,
      'route': '/profile',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current user to determine isDoctor
    final sessionState = ref.watch(appSessionControllerProvider);
    bool isDoctor = false;
    if (sessionState is AppSessionAuthenticated) {
      isDoctor = StorageService.isDoctorEmail(sessionState.user.email);
    }

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((tab) {
          final isHomeTab = tab['route'] == '/home';
          final isActive = isHomeTab 
              ? currentRoute.startsWith('/home') 
              : currentRoute == tab['route'];
          
          // Determine label for Tasks tab based on user type
          String label = tab['label'];
          if (tab['route'] == '/tasks' && isDoctor) {
            label = 'Notes';
          }

          return GestureDetector(
            onTap: () {
              context.go(tab['route']);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? tab['activeIcon'] : tab['icon'],
                    size: 24,
                    color: isActive ? const Color(0xFF4338CA) : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      color: isActive ? const Color(0xFF4338CA) : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
