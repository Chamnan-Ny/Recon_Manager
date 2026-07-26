import 'package:flutter/material.dart';
import 'package:red_doc/ui/widgets/custom_button.dart';
import 'package:red_doc/ui/screens/auth/login_screen.dart';
import 'package:red_doc/data/repositories/auth_repository.dart';
import 'package:red_doc/data/repositories/project_repository.dart';
import 'package:red_doc/data/repositories/finding_repository.dart';
import 'package:red_doc/data/models/user_model.dart';
import 'package:red_doc/theme/app_theme.dart';
import 'package:red_doc/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final ProjectRepository _projectRepository = ProjectRepository();
  final FindingRepository _findingRepository = FindingRepository();

  UserModel? _user;
  bool _isLoading = true;
  int _projectCount = 0;
  int _findingCount = 0;
  int _reportCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _isLoading = true;
    });

    final user = _authRepository.getCurrentUser();

    if (user != null) {
      _user = user;

      // ✅ Get project count
      _projectRepository.getProjects(user.uid).listen((projects) {
        if (mounted) {
          setState(() {
            _projectCount = projects.length;
          });
        }
      });

      // ✅ Get finding count from all projects
      _projectRepository.getProjects(user.uid).listen((projects) {
        int totalFindings = 0;
        int totalReports = 0;

        for (var project in projects) {
          // Count findings for each project
          _findingRepository.getFindingsByProject(project.projectId).listen((
            findings,
          ) {
            if (mounted) {
              // This will update each time findings change
              _updateCounts();
            }
          });

          // Count approved reports
          if (project.status == ProjectStatus.approved) {
            totalReports++;
          }
        }

        if (mounted) {
          setState(() {
            _reportCount = totalReports;
          });
        }
      });

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateCounts() async {
    if (_user == null) return;

    final projects = await _projectRepository.getProjects(_user!.uid).first;
    int totalFindings = 0;

    for (var project in projects) {
      final findings = await _findingRepository
          .getFindingsByProject(project.projectId)
          .first;
      totalFindings += findings.length;
    }

    if (mounted) {
      setState(() {
        _findingCount = totalFindings;
      });
    }
  }

  void _handleLogout() async {
    try {
      await _authRepository.logout();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              )
            : _user == null
            ? Center(
                child: Text('No user logged in', style: AppTheme.bodyMedium),
              )
            : Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      _user!.name.isNotEmpty
                          ? _user!.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_user!.name, style: AppTheme.heading2),
                  const SizedBox(height: 4),
                  Text(_user!.email, style: AppTheme.bodyMedium),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  // ✅ Stats with real counts
                  Row(
                    children: [
                      _buildStatItem('Projects', _projectCount.toString()),
                      _buildStatItem('Findings', _findingCount.toString()),
                      _buildStatItem('Reports', _reportCount.toString()),
                    ],
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Logout',
                    onPressed: () {
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
