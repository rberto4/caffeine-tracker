import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomStandardButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final IconData? icon;
  final Color? textColor;
  final Color? backgroundColor;
  const CustomStandardButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ??
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
          foregroundColor: textColor ?? Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        icon: Icon(icon ?? LucideIcons.plus, size: 20),
        label: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor ?? Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
