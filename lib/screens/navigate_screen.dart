import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NavigateScreen extends ConsumerWidget {
  final bool isGuest;
  
  const NavigateScreen({super.key, this.isGuest = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (isGuest) {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/welcome');
                        }
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      }
                    },
                  ),
                  const Text(
                    'Navigate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Icon with gradient background
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE0E7FF), // indigo-100
                            Color(0xFFF3E8FF), // purple-100
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.navigation,
                        size: 48,
                        color: Color(0xFF312E81), // indigo-900
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Title
                    const Text(
                      'AR Indoor Navigation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Description
                    const Text(
                      'AR indoor navigation feature will be available soon. Navigate through campus buildings with augmented reality technology.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Features Preview
                    const Column(
                      children: [
                        _FeatureCard(
                          icon: Icons.location_on,
                          iconColor: Color(0xFF3B82F6), // blue-600
                          iconBgColor: Color(0xFFEFF6FF), // blue-50
                          title: 'Find Locations',
                          description: 'Locate classrooms, labs, and facilities',
                        ),
                        SizedBox(height: 12),
                        _FeatureCard(
                          icon: Icons.explore,
                          iconColor: Color(0xFF9333EA), // purple-600
                          iconBgColor: Color(0xFFF3E8FF), // purple-50
                          title: 'AR Directions',
                          description: 'Get real-time AR guided navigation',
                        ),
                        SizedBox(height: 12),
                        _FeatureCard(
                          icon: Icons.navigation,
                          iconColor: Color(0xFF10B981), // green-600
                          iconBgColor: Color(0xFFF0FDF4), // green-50
                          title: 'Quick Routes',
                          description: 'Find fastest path to your destination',
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Coming Soon Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF312E81), // indigo-900
                            Color(0xFF581C87), // purple-900
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}