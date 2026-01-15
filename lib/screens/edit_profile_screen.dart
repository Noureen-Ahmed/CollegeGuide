
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_session_provider.dart';
import '../providers/app_mode_provider.dart';
import '../models/user.dart';
import '../widgets/user_avatar.dart';
import '../services/data_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _gpaController;
  String? _avatarUrl;
  final ImagePicker _picker = ImagePicker();

  // Data for selections
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _programs = [];
  List<Map<String, dynamic>> _levels = [];

  String? _selectedDepartmentId;
  String? _selectedProgramId;
  int? _selectedLevel;
  bool _isProfessor = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;
    _nameController = TextEditingController(text: user?.name ?? '');
    _gpaController = TextEditingController(text: user?.gpa?.toString() ?? '');
    _avatarUrl = user?.avatar;
    _selectedLevel = user?.level;
    
    if (user != null) {
      _isProfessor = user.mode == AppMode.professor;
    }

    // Load static data and then map user values
    _loadDepartmentData(user);
  }

  Future<void> _loadDepartmentData(User? user) async {
    try {
      final data = await DataService.getDepartments();

      if (!mounted) return;

      setState(() {
        _departments = List<Map<String, dynamic>>.from(data['departments']);
        _levels = List<Map<String, dynamic>>.from(data['levels']);
      });

      // Try to match user strings to IDs
      if (user != null) {
        // Find Dept
        if (user.department?.isNotEmpty ?? false) {
          final dept = _departments.firstWhere(
            (d) => d['name'] == user.department,
            orElse: () => {},
          );
          if (dept.isNotEmpty) {
            _selectedDepartmentId = dept['id'];
            
            // Programs are inside the department object in JSON? 
            // Checking structure: "departments": [ { "programs": [...] } ]
            // Yes, based on CourseSelectionScreen:
            // _programs = List<Map<String, dynamic>>.from(department['programs']);
            
            if (dept['programs'] != null) {
               setState(() {
                 _programs = List<Map<String, dynamic>>.from(dept['programs']);
               });

               // Find Program
               if (user.major?.isNotEmpty ?? false) {
                 final prog = _programs.firstWhere(
                   (p) => p['name'] == user.major,
                   orElse: () => {},
                 );
                 if (prog.isNotEmpty) {
                   _selectedProgramId = prog['id'];
                 }
               }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading department data: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _onDepartmentChanged(String? val) {
    if (val == null) return;
    setState(() {
      _selectedDepartmentId = val;
      _selectedProgramId = null; // reset program
      final dept = _departments.firstWhere((d) => d['id'] == val, orElse: () => {});
      if (dept.isNotEmpty && dept['programs'] != null) {
        _programs = List<Map<String, dynamic>>.from(dept['programs']);
      } else {
        _programs = [];
      }
    });
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

        // Show loading indicator
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

        // Upload to backend (R2 storage)
        final imageBytes = await image.readAsBytes();
        final uploadedUrl = await DataService.uploadFile(imageBytes, image.name, type: 'profile');
        
        // Dismiss loading snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }

        if (uploadedUrl != null) {
          // Append timestamp to force cache refresh if the URL is reused
          final uniqueUrl = '$uploadedUrl?t=${DateTime.now().millisecondsSinceEpoch}';
          setState(() {
            _avatarUrl = uniqueUrl;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile picture uploaded!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload profile picture'),
                backgroundColor: Colors.red,
              ),
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
    
    // Resolve IDs to Names
    String deptName = '';
    if (_selectedDepartmentId != null) {
      final d = _departments.firstWhere((d) => d['id'] == _selectedDepartmentId, orElse: () => {});
      if (d.isNotEmpty) deptName = d['name'];
    }

    String programName = '';
    if (_selectedProgramId != null) {
       final p = _programs.firstWhere((p) => p['id'] == _selectedProgramId, orElse: () => {});
       if (p.isNotEmpty) programName = p['name'];
    }

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      name: _nameController.text,
      level: _selectedLevel,
      department: deptName,
      departmentId: _selectedDepartmentId,
      program: programName,
      programId: _selectedProgramId,
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
                        name: _nameController.text,
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
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, color: goldColor, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Name
              _buildTextField(
                controller: _nameController,
                label: 'Display Name',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),

              // Department Dropdown
              _buildDropdown(
                label: 'Department',
                icon: Icons.business_outlined,
                value: _selectedDepartmentId,
                items: _departments.map((d) {
                  return DropdownMenuItem<String>(
                    value: d['id'] as String,
                    child: Text(d['name']),
                  );
                }).toList(),
                onChanged: _onDepartmentChanged,
              ),
              const SizedBox(height: 20),

              // Program Dropdown (only visible if dept selected and Not Professor)
              if (!_isProfessor && _selectedDepartmentId != null) ...[
                _buildDropdown(
                  label: 'Program',
                  icon: Icons.school_outlined,
                  value: _selectedProgramId,
                  items: _programs.map((p) {
                     return DropdownMenuItem<String>(
                       value: p['id'] as String,
                       child: Text(p['name']),
                     );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedProgramId = val),
                ),
                const SizedBox(height: 20),
              ],

              if (!_isProfessor)
              Row(
                children: [
                   // Level Dropdown
                  Expanded(
                    child: _buildDropdown(
                      label: 'Level',
                      icon: Icons.grid_view,
                      value: _selectedLevel,
                      items: _levels.map((l) {
                        return DropdownMenuItem<int>(
                          value: l['id'] as int,
                          child: Text(l['name']),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedLevel = val),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // GPA
                  Expanded(
                    child: _buildTextField(
                      controller: _gpaController,
                      label: 'GPA',
                      icon: Icons.star_border,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    const navyColor = Color(0xFF002147);
    const goldColor = Color(0xFFFDC800);
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      style: const TextStyle(color: navyColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: navyColor.withValues(alpha: 0.6)),
        prefixIcon: Icon(icon, color: goldColor),
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
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    const navyColor = Color(0xFF002147);
    const goldColor = Color(0xFFFDC800);

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      style: const TextStyle(color: navyColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: navyColor.withValues(alpha: 0.6)),
        prefixIcon: Icon(icon, color: goldColor),
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
      ),
      validator: (val) => val == null ? 'Required' : null,
    );
  }
}
