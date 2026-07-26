import 'package:flutter/material.dart';
import 'package:red_doc/theme/app_theme.dart';

class FindingCard extends StatelessWidget {
  final String title;
  final String severity;
  final String description;
  final VoidCallback onTap;

  const FindingCard({
    super.key,
    required this.title,
    required this.severity,
    required this.description,
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: getSeverityColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getSeverityColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  severity,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: getSeverityColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
