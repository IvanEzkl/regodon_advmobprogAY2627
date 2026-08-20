import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/user_service.dart';
import '../widgets/custom_text.dart';

/// Profile tab — shown as page index 2 inside HomeScreen's PageView.
/// Loads user data from SharedPreferences and displays a logout button.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _userData = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await UserService().getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await UserService().logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    const primary = Color(0xFF655A7C);   // Dolphin
    const secondary = Color(0xFFAB92BF); // Amethyst
    const gold = Color(0xFFC8962A);      // Gold — matches splash loader

    final firstName = _userData['firstName'] ?? '';
    final lastName = _userData['lastName'] ?? '';
    final username = _userData['username'] ?? '';
    final email = _userData['email'] ?? '';
    final gender = _userData['gender'] ?? '';
    final userId = _userData['id']?.toString() ?? '';
    final image = _userData['image'] ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          // ── Avatar card ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 28.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 44.r,
                  backgroundColor: secondary.withAlpha(40),
                  backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                  child: image.isEmpty
                      ? Icon(Icons.person, size: 40.sp, color: secondary)
                      : null,
                ),
                SizedBox(height: 14.h),

                // Full name
                CustomText(
                  text: '$firstName $lastName',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 4.h),

                // @username in gold
                CustomText(
                  text: '@$username',
                  fontSize: 14.sp,
                  fontColor: gold,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ── Info tiles ───────────────────────────────────────────────────
          _InfoTile(
            icon: Icons.email_outlined,
            iconColor: primary,
            label: 'Email',
            value: email,
          ),
          _InfoTile(
            icon: Icons.people_outline,
            iconColor: primary,
            label: 'Gender',
            value: gender,
          ),
          _InfoTile(
            icon: Icons.badge_outlined,
            iconColor: primary,
            label: 'User ID',
            value: '#$userId',
          ),

          SizedBox(height: 28.h),

          // ── Log Out button — red, full-width, matches sample ──────────────
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout_rounded, size: 20.sp),
              label: Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05252),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
            ),
          ),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

/// A single row tile showing an icon, label and value — used in the profile.
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: cs.onSurface,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.sp,
              color: cs.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
