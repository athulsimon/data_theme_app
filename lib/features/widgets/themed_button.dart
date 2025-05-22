import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_controller.dart';

class ThemedButton extends ConsumerWidget {
  final Icon icon;
  final String text;
  final VoidCallback onPressed;
  final bool isCustom;

  const ThemedButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.isCustom,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    final defaultTheme = Theme.of(context);

    return ElevatedButton.icon(
      icon: icon,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: isCustom
            ? theme.primaryColor
            : defaultTheme.colorScheme.secondary,
        textStyle: TextStyle(fontFamily: theme.fontFamily, fontSize: 16),
        foregroundColor: defaultTheme.colorScheme.onSecondary,
      ),
      label: Text(text),
    );
  }
}
