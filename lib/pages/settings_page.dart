import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          leading: isDark
              ? const Icon(Icons.dark_mode)
              : const Icon(Icons.light_mode),
          title: const Text('Dark Mode'),
          trailing: CupertinoSwitch(
            value: isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
          ),
        ),
      ),
    );
  }
}
