import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const availableColors = {
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
    'Red': Colors.red,
    'Teal': Colors.teal,
  };

  static const availableFonts = [
    'Roboto',
    'Courier',
    'Georgia',
    'Lobster',
    'Arial',
    'Montserrat',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);

    String currentColorKey = availableColors.entries
        .firstWhere(
          (e) => e.value == theme.primaryColor,
          orElse: () => const MapEntry('Blue', Colors.blue),
        )
        .key;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: theme.mode == ThemeMode.dark,
            onChanged: notifier.toggleTheme,
          ),
          const SizedBox(height: 16),
          Text('Primary Color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: currentColorKey,
            items: availableColors.keys
                .map(
                  (label) => DropdownMenuItem(
                    value: label,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: availableColors[label],
                          radius: 10,
                        ),
                        const SizedBox(width: 10),
                        Text(label),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                notifier.updatePrimaryColor(availableColors[value]!);
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 24),
          Text('Font Family', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: theme.fontFamily,
            items: availableFonts
                .map(
                  (font) => DropdownMenuItem(
                    value: font,
                    child: Text(font, style: TextStyle(fontFamily: font)),
                  ),
                )
                .toList(),
            onChanged: (font) {
              if (font != null) {
                notifier.updateFontFamily(font);
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
