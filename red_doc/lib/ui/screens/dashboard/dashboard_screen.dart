import 'package:flutter/material.dart';
import 'package:red_doc/ui/widgets/project_card.dart';
import 'package:red_doc/ui/widgets/empty_widget.dart';
import 'package:red_doc/ui/screens/project/create_project_screen.dart';
import 'package:red_doc/ui/screens/project/project_detail_screen.dart';
import 'package:red_doc/ui/screens/profile/profile_screen.dart';
import 'package:red_doc/data/repositories/project_repository.dart';
import 'package:red_doc/data/repositories/finding_repository.dart';
import 'package:red_doc/data/repositories/auth_repository.dart';
import 'package:red_doc/data/models/project_model.dart';
import 'package:red_doc/data/models/finding_model.dart';
import 'package:red_doc/theme/app_theme.dart';
import 'package:red_doc/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProjectRepository _projectRepository = ProjectRepository();
  final FindingRepository _findingRepository = FindingRepository();
  final AuthRepository _authRepository = AuthRepository();

  String? _currentUserId;
  int _totalProjects = 0;
  int _pendingProjects = 0;
  int _approvedProjects = 0;
  int _totalFindings = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      _currentUserId = user.uid;
    }
  }

  int _getPendingCount(List<ProjectModel> projects) {
    int count = 0;
    for (var project in projects) {
      if (project.status == ProjectStatus.pendingReview) {
        count++;
      }
    }
    return count;
  }

  int _getApprovedCount(List<ProjectModel> projects) {
    int count = 0;
    for (var project in projects) {
      if (project.status == ProjectStatus.approved) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('RedDoc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ProjectModel>>(
        stream: _projectRepository.getProjects(_currentUserId!),
        builder: (context, projectSnapshot) {
          if (projectSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            );
          }

          if (projectSnapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${projectSnapshot.error}',
                style: AppTheme.bodyMedium,
              ),
            );
          }

          final projects = projectSnapshot.data ?? [];

          // ✅ Update stats
          _totalProjects = projects.length;
          _pendingProjects = _getPendingCount(projects);
          _approvedProjects = _getApprovedCount(projects);

          if (projects.isEmpty) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStatCard('Projects', 0, Icons.folder),
                      _buildStatCard('Pending', 0, Icons.pending_actions),
                      _buildStatCard('Approved', 0, Icons.check_circle),
                    ],
                  ),
                ),
                const Expanded(
                  child: EmptyWidget(
                    message: 'No projects yet. Create your first project!',
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildStatCard('Projects', _totalProjects, Icons.folder),
                    _buildStatCard(
                      'Pending',
                      _pendingProjects,
                      Icons.pending_actions,
                    ),
                    _buildStatCard(
                      'Approved',
                      _approvedProjects,
                      Icons.check_circle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('My Projects', style: AppTheme.heading3),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];

                          return StreamBuilder<List<FindingModel>>(
                            stream: _findingRepository.getFindingsByProject(
                              project.projectId,
                            ),
                            builder: (context, findingSnapshot) {
                              int findingCount = 0;
                              if (findingSnapshot.hasData) {
                                findingCount = findingSnapshot.data!.length;
                              }

                              return ProjectCard(
                                title: project.title,
                                target: project.target,
                                status: _getStatusDisplay(project.status),
                                findingCount: findingCount,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProjectDetailScreen(
                                        projectId: project.projectId,
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProjectScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
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

  Widget _buildStatCard(String label, int count, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 28),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: AppTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
