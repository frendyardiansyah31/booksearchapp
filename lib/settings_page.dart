import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const SettingsPage({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: isDark,
            onChanged: (_) => onToggleTheme(),
          ),
        ],
      ),
    );
  }
}
