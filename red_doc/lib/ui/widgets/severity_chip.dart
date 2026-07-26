import 'package:flutter/material.dart';
import 'package:red_doc/theme/app_theme.dart';

class SeverityChip extends StatelessWidget {
  final String severity;
  final bool isSelected;
  final VoidCallback onTap;

  const SeverityChip({
    super.key,
    required this.severity,
    this.isSelected = false,
    required this.onTap,
  });

  Color getSeverityColor() {
    if (severity == 'Critical') {
      return AppTheme.severityCritical;
    } else if (severity == 'High') {
      return AppTheme.severityHigh;
    } else if (severity == 'Medium') {
      return AppTheme.severityMedium;
    } else if (severity == 'Low') {
      return AppTheme.severityLow;
    } else {
      return AppTheme.severityInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getSeverityColor();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          severity,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
