import 'package:caffeine_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTileTitle extends StatelessWidget {
  final String tittle;
  final String subtitle;
  final IconData leadingIcon;
  Widget? trailingWidget;
  Function()? onTapTrailing;
  CustomTileTitle({
    super.key,
    required this.tittle,
    required this.subtitle,
    required this.leadingIcon,
    this.trailingWidget,
    this.onTapTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          leadingIcon,
          color: AppColors.primaryOrange,
          size: 20,
        ),
      ),
      title: Text(
        tittle,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: trailingWidget != null
          ? InkWell(
              onTap: onTapTrailing,
              child: trailingWidget,
            )
          : null,
      
    );
  }
}
