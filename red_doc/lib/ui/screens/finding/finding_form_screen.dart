import 'package:flutter/material.dart';
import 'package:red_doc/data/models/finding_model.dart';
import 'package:red_doc/ui/widgets/custom_button.dart';
import 'package:red_doc/ui/widgets/custom_textfield.dart';
import 'package:red_doc/data/repositories/finding_repository.dart';
import 'package:red_doc/theme/app_theme.dart';
import 'package:red_doc/utils/constants.dart';

class FindingFormScreen extends StatefulWidget {
  final String? projectId;
  final Map<String, dynamic>? existingFinding;

  const FindingFormScreen({super.key, this.projectId, this.existingFinding});

  @override
  State<FindingFormScreen> createState() => _FindingFormScreenState();
}

class _FindingFormScreenState extends State<FindingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final FindingRepository _findingRepository = FindingRepository();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _recommendationController;
  late String _selectedSeverity;
  late String _selectedStatus;
  bool _isLoading = false;

  final List<String> _severityOptions = [
    'Critical',
    'High',
    'Medium',
    'Low',
    'Informational',
  ];

  final List<String> _statusOptions = [
    'Open',
    'In Progress',
    'Fixed',
    'Verified',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.existingFinding != null) {
      _titleController = TextEditingController(
        text: widget.existingFinding!['title'],
      );
      _descriptionController = TextEditingController(
        text: widget.existingFinding!['description'],
      );
      _recommendationController = TextEditingController(
        text: widget.existingFinding!['recommendation'],
      );
      _selectedSeverity = widget.existingFinding!['severity'];
      _selectedStatus = widget.existingFinding!['status'];
    } else {
      _titleController = TextEditingController(text: '');
      _descriptionController = TextEditingController(text: '');
      _recommendationController = TextEditingController(text: '');
      _selectedSeverity = 'Medium';
      _selectedStatus = 'Open';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _recommendationController.dispose();
    super.dispose();
  }

  Severity _getSeverityEnum(String severity) {
    if (severity == 'Critical') {
      return Severity.critical;
    } else if (severity == 'High') {
      return Severity.high;
    } else if (severity == 'Medium') {
      return Severity.medium;
    } else if (severity == 'Low') {
      return Severity.low;
    } else if (severity == 'Informational') {
      return Severity.informational;
    } else {
      return Severity.medium;
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (widget.existingFinding != null) {
          // ✅ UPDATE existing finding
          final updatedFinding = FindingModel(
            findingId: widget.existingFinding!['findingId'],
            projectId: widget.existingFinding!['projectId'],
            title: _titleController.text.trim(),
            severity: _getSeverityEnum(_selectedSeverity),
            description: _descriptionController.text.trim(),
            recommendation: _recommendationController.text.trim(),
            status: _selectedStatus,
            createdAt: DateTime.now(),
          );
          await _findingRepository.updateFinding(updatedFinding);

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Finding updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // ✅ Return updated data
          Navigator.pop(context, {
            'title': _titleController.text.trim(),
            'severity': _selectedSeverity,
            'description': _descriptionController.text.trim(),
            'recommendation': _recommendationController.text.trim(),
            'status': _selectedStatus,
          });
        } else {
          // ✅ CREATE new finding
          await _findingRepository.createFinding(
            projectId: widget.projectId!,
            title: _titleController.text.trim(),
            severity: _selectedSeverity,
            description: _descriptionController.text.trim(),
            recommendation: _recommendationController.text.trim(),
            status: _selectedStatus,
          );

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Finding added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String screenTitle;
    String buttonText;
    if (widget.existingFinding != null) {
      screenTitle = 'Edit Finding';
      buttonText = 'Update Finding';
    } else {
      screenTitle = 'Add Finding';
      buttonText = 'Save Finding';
    }

    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Finding Title',
                hint: 'e.g., SQL Injection',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a finding title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Severity',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSeverity,
                        isExpanded: true,
                        items: _severityOptions.map((severity) {
                          return DropdownMenuItem<String>(
                            value: severity,
                            child: Text(severity),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSeverity = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description',
                hint: 'Describe the vulnerability',
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Recommendation',
                hint: 'How to fix this vulnerability',
                controller: _recommendationController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        isExpanded: true,
                        items: _statusOptions.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: buttonText,
                onPressed: _handleSubmit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
