import 'package:flutter/material.dart';
import 'package:red_doc/theme/app_theme.dart';


class ProjectCard extends StatelessWidget {
  final String title;
  final String target;
  final String status;
  final int findingCount;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.title,
    required this.target,
    required this.status,
    required this.findingCount,
    required this.onTap,
  });

  Color getStatusColor() {
    if (status == 'Draft') {
      return AppTheme.statusDraft;
    } else if (status == 'Pending Review') {
      return AppTheme.statusPending;
    } else if (status == 'Revision Required') {
      return AppTheme.statusRevision;
    } else if (status == 'Approved') {
      return AppTheme.statusApproved;
    } else {
      return AppTheme.textLight;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Target: $target',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.bug_report,
                    size: 16,
                    color: AppTheme.textLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$findingCount Findings',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
