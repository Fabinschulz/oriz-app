import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/core/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final NumberFormat formatter;
  final IconData? icon;
  final bool isMain;

  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.formatter,
    this.icon,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMain ? 18 : 16),
      decoration: BoxDecoration(
        color: isMain ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isMain ? Colors.transparent : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: (isMain ? AppColors.primary : Colors.black).withValues(
              alpha: 0.08,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isMain ? Colors.white : color).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isMain ? Colors.white : color, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isMain
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatter.format(value),
                    style: TextStyle(
                      fontSize: isMain ? 20 : 14,
                      fontWeight: FontWeight.w900,
                      color: isMain ? Colors.white : color,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
