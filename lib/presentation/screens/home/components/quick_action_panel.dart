import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oriz_app/core/theme/app_colors.dart';

class QuickActionPanel extends StatelessWidget {
  final VoidCallback onScrollToTop;
  final VoidCallback onSortPressed;
  final VoidCallback onAddPressed;

  const QuickActionPanel({
    super.key,
    required this.onScrollToTop,
    required this.onSortPressed,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    return Container(
      margin: EdgeInsets.fromLTRB(24, 0, 24, isIOS ? 40 : 30),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isIOS ? 0.7 : 0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: isIOS
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: CupertinoIcons.slider_horizontal_3,
                onPressed: onSortPressed,
              ),
              _AddButton(
                icon: CupertinoIcons.add_circled,
                onPressed: onAddPressed,
              ),
              _ActionButton(
                icon: CupertinoIcons.arrow_up_to_line,
                onPressed: onScrollToTop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.textSecondary, size: 26),
      onPressed: onPressed,
    );
  }
}

class _AddButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AddButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: AppColors.textSecondary, size: 30),
      ),
    );
  }
}
