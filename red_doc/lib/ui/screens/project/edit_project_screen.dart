import 'package:flutter/material.dart';
import 'package:red_doc/ui/widgets/custom_button.dart';
import 'package:red_doc/ui/widgets/custom_textfield.dart';
import 'package:red_doc/data/repositories/project_repository.dart';
import 'package:red_doc/data/repositories/auth_repository.dart';
import 'package:red_doc/data/models/project_model.dart';
import 'package:red_doc/utils/constants.dart';
import 'package:red_doc/theme/app_theme.dart';

class EditProjectScreen extends StatefulWidget {
  final String projectId;
  final String title;
  final String target;
  final String scope;
  final String description;
  final String status;

  const EditProjectScreen({
    super.key,
    required this.projectId,
    required this.title,
    required this.target,
    required this.scope,
    required this.description,
    required this.status,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProjectRepository _projectRepository = ProjectRepository();
  final AuthRepository _authRepository = AuthRepository();
  late TextEditingController _titleController;
  late TextEditingController _targetController;
  late TextEditingController _scopeController;
  late TextEditingController _descriptionController;
  late String _selectedStatus;
  bool _isLoading = false;

  final List<String> _statusOptions = [
    'Draft',
    'Pending Review',
    'Revision Required',
    'Approved',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _targetController = TextEditingController(text: widget.target);
    _scopeController = TextEditingController(text: widget.scope);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedStatus = widget.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _scopeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  ProjectStatus _getStatusEnum(String status) {
    if (status == 'Draft') {
      return ProjectStatus.draft;
    } else if (status == 'Pending Review') {
      return ProjectStatus.pendingReview;
    } else if (status == 'Revision Required') {
      return ProjectStatus.revisionRequired;
    } else if (status == 'Approved') {
      return ProjectStatus.approved;
    } else {
      return ProjectStatus.draft;
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        //  Get current user ID
        final user = _authRepository.getCurrentUser();
        if (user == null) {
          throw 'User not logged in';
        }

        final project = ProjectModel(
          projectId: widget.projectId,
          title: _titleController.text.trim(),
          target: _targetController.text.trim(),
          scope: _scopeController.text.trim(),
          description: _descriptionController.text.trim(),
          userId: user.uid, // ✅ ADD THIS
          status: _getStatusEnum(_selectedStatus),
          createdAt: DateTime.now(),
        );

        await _projectRepository.updateProject(project);

        if (!mounted) return;

        Navigator.pop(context, {
          'title': _titleController.text.trim(),
          'target': _targetController.text.trim(),
          'scope': _scopeController.text.trim(),
          'description': _descriptionController.text.trim(),
          'status': _selectedStatus,
        });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Project Title',
                hint: 'e.g., Web Application Assessment',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Target',
                hint: 'e.g., example.com',
                controller: _targetController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Scope',
                hint: 'Describe the testing scope',
                controller: _scopeController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a scope';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description',
                hint: 'Describe the project',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status', style: AppTheme.bodyMedium),
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
                      text: 'Update Project',
                      onPressed: _handleSubmit,
                      isLoading: _isLoading,
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
