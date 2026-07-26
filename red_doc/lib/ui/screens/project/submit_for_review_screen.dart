import 'package:flutter/material.dart';
import 'package:red_doc/ui/widgets/custom_button.dart';
import 'package:red_doc/ui/screens/dashboard/dashboard_screen.dart';
import 'package:red_doc/data/repositories/project_repository.dart';
import 'package:red_doc/data/repositories/finding_repository.dart';
import 'package:red_doc/data/repositories/auth_repository.dart';
import 'package:red_doc/data/models/project_model.dart';
import 'package:red_doc/utils/constants.dart';
import 'package:red_doc/theme/app_theme.dart';

class SubmitForReviewScreen extends StatefulWidget {
  final String projectId;

  const SubmitForReviewScreen({super.key, required this.projectId});

  @override
  State<SubmitForReviewScreen> createState() => _SubmitForReviewScreenState();
}

class _SubmitForReviewScreenState extends State<SubmitForReviewScreen> {
  final ProjectRepository _projectRepository = ProjectRepository();
  final FindingRepository _findingRepository = FindingRepository();
  final AuthRepository _authRepository = AuthRepository();
  bool _isSubmitting = false;
  int _totalFindings = 0;
  int _criticalCount = 0;
  int _highCount = 0;
  int _mediumCount = 0;
  int _lowCount = 0;
  String _projectTitle = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final project = await _projectRepository.getProject(widget.projectId);
    if (project != null) {
      setState(() {
        _projectTitle = project.title;
      });
    }

    _findingRepository.getFindingsByProject(widget.projectId).listen((
      findings,
    ) {
      setState(() {
        _totalFindings = findings.length;
        _criticalCount = 0;
        _highCount = 0;
        _mediumCount = 0;
        _lowCount = 0;

        for (var finding in findings) {
          if (finding.severity == Severity.critical) {
            _criticalCount++;
          } else if (finding.severity == Severity.high) {
            _highCount++;
          } else if (finding.severity == Severity.medium) {
            _mediumCount++;
          } else if (finding.severity == Severity.low) {
            _lowCount++;
          }
        }
      });
    });
  }

  void _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final project = await _projectRepository.getProject(widget.projectId);
      if (project != null) {
        // ✅ Get current user ID
        final user = _authRepository.getCurrentUser();
        if (user == null) {
          throw 'User not logged in';
        }

        final updatedProject = ProjectModel(
          projectId: project.projectId,
          title: project.title,
          target: project.target,
          scope: project.scope,
          description: project.description,
          userId: user.uid, // ✅ ADD THIS
          status: ProjectStatus.pendingReview,
          createdAt: project.createdAt,
        );
        await _projectRepository.updateProject(updatedProject);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted for review successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit For Review')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Review Summary', style: AppTheme.heading3),
                    const SizedBox(height: 12),
                    _buildInfoRow('Project', _projectTitle),
                    _buildInfoRow('Total Findings', _totalFindings.toString()),
                    const Divider(),
                    _buildSeverityRow(
                      'Critical',
                      _criticalCount,
                      AppTheme.severityCritical,
                    ),
                    _buildSeverityRow(
                      'High',
                      _highCount,
                      AppTheme.severityHigh,
                    ),
                    _buildSeverityRow(
                      'Medium',
                      _mediumCount,
                      AppTheme.severityMedium,
                    ),
                    _buildSeverityRow('Low', _lowCount, AppTheme.severityLow),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.amber[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Make sure all findings are complete before submitting',
                      style: TextStyle(color: Colors.amber[700], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Submit Review',
                    onPressed: _handleSubmit,
                    isLoading: _isSubmitting,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTheme.bodyMedium)),
          Expanded(child: Text(value, style: AppTheme.bodyLarge)),
        ],
      ),
    );
  }

  Widget _buildSeverityRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 100, child: Text(label, style: AppTheme.bodyMedium)),
          Expanded(child: Text(count.toString(), style: AppTheme.bodyLarge)),
        ],
      ),
    );
  }
}
