import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_text.dart';

// Enhancement 3: Settings Page dedicated to toggling Dark/Light Mode
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Settings', fontSize: 20),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const CustomText(text: 'Dark Mode', fontSize: 16),
            subtitle: const CustomText(
              text: 'Toggle theme across the application',
              fontSize: 12,
            ),
            value: themeProvider.isDark,
            onChanged: (bool value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}