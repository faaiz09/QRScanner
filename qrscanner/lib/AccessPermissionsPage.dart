import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AccessPermissionsPage extends HookWidget {
  const AccessPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isLoading = useState(false);
    final selectedRole = useState('Administrator');
    final permissions = useState<Map<String, bool>>({
      'View Content': true,
      'Edit Content': false,
      'Delete Content': false,
      'Manage Users': false,
      'Access Settings': false,
    });
    final additionalSettings = useState<Map<String, bool>>({
      'Two-Factor Authentication': true,
      'API Access': false,
      'Email Notifications': true,
      'Audit Logging': false,
    });

    Future<void> handleSave() async {
      if (formKey.currentState?.validate() ?? false) {
        isLoading.value = true;
        try {
          // Simulate API call
          await Future.delayed(const Duration(seconds: 2));
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Permissions saved successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.pop(context);
          }
        } catch (e) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Failed to save permissions'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        } finally {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Permissions',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: isLoading.value ? null : handleSave,
            icon: isLoading.value
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save, color: Colors.white),
            label: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildSection(
              title: 'Basic Information',
              icon: Icons.info_outline,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Role Name',
                    hintText: 'Enter role name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Role name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter role description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: 'Role Type',
              icon: Icons.people_outline,
              children: [
                Card(
                  elevation: 0,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: ['Administrator', 'Manager', 'User', 'Guest']
                        .map((type) => RadioListTile(
                              value: type,
                              groupValue: selectedRole.value,
                              onChanged: (value) {
                                selectedRole.value = value.toString();
                              },
                              title: Text(type),
                              subtitle: Text(_getRoleDescription(type)),
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: 'Access Permissions',
              icon: Icons.security_outlined,
              children: [
                Card(
                  elevation: 0,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: permissions.value.entries.map((entry) {
                      return SwitchListTile(
                        value: entry.value,
                        onChanged: (value) {
                          final newPermissions =
                              Map<String, bool>.from(permissions.value);
                          newPermissions[entry.key] = value;
                          permissions.value = newPermissions;
                        },
                        title: Text(entry.key),
                        subtitle: Text(_getPermissionDescription(entry.key)),
                        activeColor: Theme.of(context).primaryColor,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: 'Additional Settings',
              icon: Icons.settings_outlined,
              children: [
                Card(
                  elevation: 0,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: additionalSettings.value.entries.map((entry) {
                      return SwitchListTile(
                        value: entry.value,
                        onChanged: (value) {
                          final newSettings =
                              Map<String, bool>.from(additionalSettings.value);
                          newSettings[entry.key] = value;
                          additionalSettings.value = newSettings;
                        },
                        title: Text(entry.key),
                        subtitle: Text(_getSettingDescription(entry.key)),
                        activeColor: Theme.of(context).primaryColor,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: isLoading.value ? null : handleSave,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...children,
      ],
    );
  }

  String _getRoleDescription(String type) {
    switch (type) {
      case 'Administrator':
        return 'Full access to all features and settings';
      case 'Manager':
        return 'Can manage users and content';
      case 'User':
        return 'Basic access to features';
      case 'Guest':
        return 'Limited access to public features';
      default:
        return '';
    }
  }

  String _getPermissionDescription(String permission) {
    switch (permission) {
      case 'View Content':
        return 'Access to view all content in the system';
      case 'Edit Content':
        return 'Ability to modify existing content';
      case 'Delete Content':
        return 'Permission to remove content from the system';
      case 'Manage Users':
        return 'Add, edit, and remove user accounts';
      case 'Access Settings':
        return 'Configure system-wide settings';
      default:
        return '';
    }
  }

  String _getSettingDescription(String setting) {
    switch (setting) {
      case 'Two-Factor Authentication':
        return 'Require two-factor authentication for this role';
      case 'API Access':
        return 'Allow access to system APIs';
      case 'Email Notifications':
        return 'Receive email notifications for important events';
      case 'Audit Logging':
        return 'Track all actions performed by users with this role';
      default:
        return '';
    }
  }
}
