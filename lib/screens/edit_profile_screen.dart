import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_session_provider.dart';
import '../widgets/user_avatar.dart';
import '../services/data_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _gpaController;
  String? _avatarUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;
    _gpaController = TextEditingController(text: user?.gpa?.toString() ?? '');
    _avatarUrl = user?.avatar;
  }

  @override
  void dispose() {
    _gpaController.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.length();
        const maxSizeBytes = 5 * 1024 * 1024;

        if (bytes > maxSizeBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size exceeds 5MB limit. Please choose a smaller image.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                  SizedBox(width: 12),
                  Text('Uploading profile picture...'),
                ],
              ),
              duration: Duration(seconds: 30),
            ),
          );
        }

        final imageBytes = await image.readAsBytes();
        final uploadedUrl = await DataService.uploadFile(imageBytes, image.name, type: 'profile');

        if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (uploadedUrl != null) {
          final uniqueUrl = '$uploadedUrl?t=${DateTime.now().millisecondsSinceEpoch}';
          setState(() => _avatarUrl = uniqueUrl);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile picture uploaded!'), backgroundColor: Colors.green),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload profile picture'), backgroundColor: Colors.red),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      gpa: double.tryParse(_gpaController.text),
      avatar: _avatarUrl ?? currentUser.avatar,
    );

    final success = await ref.read(appSessionControllerProvider.notifier).updateUser(updatedUser);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF002147);
    const goldColor = Color(0xFFFDC800);
    const bgColor = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: navyColor, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: navyColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: navyColor)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar with camera button
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: navyColor.withValues(alpha: 0.1), width: 4),
                      ),
                      child: UserAvatar(
                        avatarUrl: _avatarUrl ?? '',
                        name: ref.read(currentUserProvider).value?.name ?? '',
                        size: 100,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changePhoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: navyColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: const Icon(Icons.camera_alt, color: goldColor, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the camera icon to change your photo',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(height: 32),

              // Info card about UMS data
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Name, faculty, department, and level are synced from UMS and cannot be edited here.',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // GPA field
              TextFormField(
                controller: _gpaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: navyColor),
                decoration: InputDecoration(
                  labelText: 'GPA',
                  labelStyle: TextStyle(color: navyColor.withValues(alpha: 0.6)),
                  prefixIcon: const Icon(Icons.star_border, color: goldColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: navyColor.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: navyColor.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: navyColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  helperText: 'Enter your cumulative GPA (e.g. 3.5)',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return null; // optional
                  final gpa = double.tryParse(v);
                  if (gpa == null || gpa < 0 || gpa > 4) return 'Enter a valid GPA (0-4)';
                  return null;
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
