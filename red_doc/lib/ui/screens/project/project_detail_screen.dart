import 'package:flutter/material.dart';
import 'package:red_doc/ui/widgets/finding_card.dart';
import 'package:red_doc/ui/widgets/empty_widget.dart';
import 'package:red_doc/ui/screens/finding/finding_form_screen.dart';
import 'package:red_doc/ui/screens/finding/finding_detail_screen.dart';
import 'package:red_doc/ui/screens/project/submit_for_review_screen.dart';
import 'package:red_doc/ui/screens/project/edit_project_screen.dart';
import 'package:red_doc/data/repositories/project_repository.dart';
import 'package:red_doc/data/repositories/finding_repository.dart';
import 'package:red_doc/data/models/project_model.dart';
import 'package:red_doc/data/models/finding_model.dart';
import 'package:red_doc/theme/app_theme.dart';
import 'package:red_doc/utils/constants.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final ProjectRepository _projectRepository = ProjectRepository();
  final FindingRepository _findingRepository = FindingRepository();
  late Future<ProjectModel?> _projectFuture;

  @override
  void initState() {
    super.initState();
    _projectFuture = _projectRepository.getProject(widget.projectId);
  }

  String _getStatusDisplay(ProjectStatus status) {
    if (status == ProjectStatus.draft) {
      return 'Draft';
    } else if (status == ProjectStatus.pendingReview) {
      return 'Pending Review';
    } else if (status == ProjectStatus.revisionRequired) {
      return 'Revision Required';
    } else if (status == ProjectStatus.approved) {
      return 'Approved';
    } else {
      return '';
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    if (status == ProjectStatus.draft) {
      return AppTheme.statusDraft;
    } else if (status == ProjectStatus.pendingReview) {
      return AppTheme.statusPending;
    } else if (status == ProjectStatus.revisionRequired) {
      return AppTheme.statusRevision;
    } else if (status == ProjectStatus.approved) {
      return AppTheme.statusApproved;
    } else {
      return AppTheme.textLight;
    }
  }

  String _getSeverityDisplay(Severity severity) {
    if (severity == Severity.critical) {
      return 'Critical';
    } else if (severity == Severity.high) {
      return 'High';
    } else if (severity == Severity.medium) {
      return 'Medium';
    } else if (severity == Severity.low) {
      return 'Low';
    } else if (severity == Severity.informational) {
      return 'Informational';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProjectModel?>(
      future: _projectFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Project Detail')),
            body: Center(
              child: Text('Error loading project', style: AppTheme.bodyMedium),
            ),
          );
        }

        final project = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(project.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _navigateToEditProject(project);
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SubmitForReviewScreen(projectId: widget.projectId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog(project.projectId);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Project Information', style: AppTheme.heading3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                project.status,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusDisplay(project.status),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(project.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Target', project.target),
                      _buildInfoRow('Scope', project.scope),
                      if (project.description.isNotEmpty)
                        _buildInfoRow('Description', project.description),
                      _buildInfoRow('Created', _formatDate(project.createdAt)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Findings', style: AppTheme.heading3),
                          StreamBuilder<List<FindingModel>>(
                            stream: _findingRepository.getFindingsByProject(
                              widget.projectId,
                            ),
                            builder: (context, findingSnapshot) {
                              final count = findingSnapshot.data?.length ?? 0;
                              return Text(
                                '$count items',
                                style: AppTheme.bodySmall,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<FindingModel>>(
                        stream: _findingRepository.getFindingsByProject(
                          widget.projectId,
                        ),
                        builder: (context, findingSnapshot) {
                          if (findingSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            );
                          }

                          if (findingSnapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${findingSnapshot.error}',
                                style: AppTheme.bodyMedium,
                              ),
                            );
                          }

                          final findings = findingSnapshot.data ?? [];

                          if (findings.isEmpty) {
                            return const EmptyWidget(
                              message:
                                  'No findings yet. Add your first finding!',
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: findings.length,
                            itemBuilder: (context, index) {
                              final finding = findings[index];
                              return FindingCard(
                                title: finding.title,
                                severity: _getSeverityDisplay(finding.severity),
                                description: finding.description,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FindingDetailScreen(
                                        findingId: finding.findingId,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FindingFormScreen(projectId: widget.projectId),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: AppTheme.bodyMedium)),
          Expanded(child: Text(value, style: AppTheme.bodyLarge)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}, ${_padNumber(date.hour)}:${_padNumber(date.minute)} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _padNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  void _navigateToEditProject(ProjectModel project) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProjectScreen(
          projectId: project.projectId,
          title: project.title,
          target: project.target,
          scope: project.scope,
          description: project.description,
          status: _getStatusDisplay(project.status),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _projectFuture = _projectRepository.getProject(widget.projectId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showDeleteDialog(String projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _projectRepository.deleteProject(projectId);
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Project deleted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
