import 'package:flutter/material.dart';
import 'package:red_doc/data/models/evidence_model.dart';
import 'package:red_doc/data/models/finding_model.dart';
import 'package:red_doc/theme/app_theme.dart';
import 'package:red_doc/ui/widgets/evidence_card.dart';
import 'package:red_doc/ui/widgets/empty_widget.dart';
import 'package:red_doc/data/repositories/finding_repository.dart';
import 'package:red_doc/data/repositories/storage_repository.dart';
import 'package:red_doc/utils/constants.dart';

class FindingDetailScreen extends StatefulWidget {
  final String findingId;

  const FindingDetailScreen({super.key, required this.findingId});

  @override
  State<FindingDetailScreen> createState() => _FindingDetailScreenState();
}

class _FindingDetailScreenState extends State<FindingDetailScreen> {
  final FindingRepository _findingRepository = FindingRepository();
  final StorageRepository _storageRepository = StorageRepository();
  late Future<FindingModel?> _findingFuture;

  @override
  void initState() {
    super.initState();
    _findingFuture = _findingRepository.getFinding(widget.findingId);
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

  Color _getSeverityColor(Severity severity) {
    if (severity == Severity.critical) {
      return AppTheme.severityCritical;
    } else if (severity == Severity.high) {
      return AppTheme.severityHigh;
    } else if (severity == Severity.medium) {
      return AppTheme.severityMedium;
    } else if (severity == Severity.low) {
      return AppTheme.severityLow;
    } else if (severity == Severity.informational) {
      return AppTheme.severityInfo;
    } else {
      return AppTheme.textLight;
    }
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

  void _showDeleteDialog(FindingModel finding) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Finding'),
        content: const Text('Are you sure you want to delete this finding?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _findingRepository.deleteFinding(finding.findingId);
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Finding deleted successfully!'),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FindingModel?>(
      future: _findingFuture,
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
            appBar: AppBar(title: const Text('Finding Detail')),
            body: Center(
              child: Text('Error loading finding', style: AppTheme.bodyMedium),
            ),
          );
        }

        final finding = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(finding.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog(finding);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(
                          finding.severity,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getSeverityDisplay(finding.severity),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getSeverityColor(finding.severity),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        finding.status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description', style: AppTheme.heading3),
                        const SizedBox(height: 8),
                        Text(finding.description, style: AppTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (finding.recommendation.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recommendation', style: AppTheme.heading3),
                          const SizedBox(height: 8),
                          Text(
                            finding.recommendation,
                            style: AppTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Evidence', style: AppTheme.heading3)],
                ),
                const SizedBox(height: 8),
                StreamBuilder<List<EvidenceModel>>(
                  stream: _storageRepository.getEvidenceByFinding(
                    widget.findingId,
                  ),
                  builder: (context, evidenceSnapshot) {
                    if (evidenceSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox(
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      );
                    }

                    final evidenceList = evidenceSnapshot.data ?? [];

                    if (evidenceList.isEmpty) {
                      return const EmptyWidget(
                        message: 'No evidence uploaded yet.',
                      );
                    }

                    return SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: evidenceList.length,
                        itemBuilder: (context, index) {
                          final evidence = evidenceList[index];
                          return EvidenceCard(
                            imageUrl: evidence.imageUrl,
                            note: evidence.note,
                            onTap: () {
                              // View full image
                            },
                            onDelete: () async {
                              try {
                                await _storageRepository.deleteEvidence(
                                  evidence.evidenceId,
                                  evidence.imageUrl,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Evidence deleted successfully!',
                                    ),
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
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Status', finding.status),
                        _buildInfoRow(
                          'Created',
                          _formatDate(finding.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: AppTheme.bodyMedium)),
          Expanded(child: Text(value, style: AppTheme.bodyLarge)),
        ],
      ),
    );
  }
}
