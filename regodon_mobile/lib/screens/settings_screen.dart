import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';
import '../widgets/custom_text.dart';

// Enhancement 3: Settings Page — dark/light toggle + user profile + logout
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _userData = {};
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await UserService().getUserData();
    if (mounted) setState(() { _userData = data; _loadingUser = false; });
  }

  Future<void> _logout() async {
    await UserService().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;
    final cs = Theme.of(context).colorScheme;

    const primary = Color(0xFF655A7C);
    const secondary = Color(0xFFAB92BF);
    const linen = Color(0xFFFDF1E2);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Settings',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: _loadingUser
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              children: [
                // ── Avatar + name card ────────────────────────────────────
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 34.r,
                        backgroundColor: secondary.withAlpha(51),
                        backgroundImage: (_userData['image'] ?? '').isNotEmpty
                            ? NetworkImage(_userData['image'])
                            : null,
                        child: (_userData['image'] ?? '').isEmpty
                            ? Icon(Icons.person,
                                size: 32.sp, color: secondary)
                            : null,
                      ),
                      SizedBox(width: 16.w),

                      // Name + email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text:
                                  '${_userData['firstName'] ?? ''} ${_userData['lastName'] ?? ''}'
                                      .trim(),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: '@${_userData['username'] ?? ''}',
                              fontSize: 13.sp,
                              fontColor: secondary,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: _userData['email'] ?? '',
                              fontSize: 12.sp,
                              fontColor: cs.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // ── Section: Appearance ───────────────────────────────────
                _sectionHeader('Appearance', cs),
                SizedBox(height: 8.h),

                _settingsTile(
                  context: context,
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,
                  iconColor: isDark ? secondary : primary,
                  title: 'Dark Mode',
                  subtitle: isDark ? 'Currently: Dark' : 'Currently: Light',
                  trailing: Switch(
                    value: isDark,
                    activeThumbColor: secondary,
                    inactiveThumbColor: primary,
                    inactiveTrackColor: linen,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                ),

                SizedBox(height: 24.h),

                // ── Section: Account ──────────────────────────────────────
                _sectionHeader('Account', cs),
                SizedBox(height: 8.h),

                _settingsTile(
                  context: context,
                  icon: Icons.logout_rounded,
                  iconColor: Colors.redAccent,
                  title: 'Log Out',
                  subtitle: 'Sign out of your account',
                  trailing: Icon(Icons.chevron_right,
                      color: cs.onSurfaceVariant, size: 20.sp),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Log Out'),
                        content:
                            const Text('Are you sure you want to log out?'),
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
                    if (confirm == true) _logout();
                  },
                ),

                SizedBox(height: 32.h),

                // Version tag
                Center(
                  child: CustomText(
                    text: 'NUBdExchange v0.1.0',
                    fontSize: 11.sp,
                    fontColor: cs.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionHeader(String label, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: CustomText(
        text: label.toUpperCase(),
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        fontColor: cs.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _settingsTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(26),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        title: CustomText(
          text: title,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        subtitle: CustomText(
          text: subtitle,
          fontSize: 12.sp,
          fontColor: cs.onSurfaceVariant,
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}