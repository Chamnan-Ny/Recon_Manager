// Temporary shared fake data.
// Both the dashboard and the detail screens read from this same list,
// so tapping a project/finding actually shows that project/finding
// instead of always showing the first hardcoded one.
//
// This whole file goes away once project_repository.dart and
// finding_repository.dart are wired up to real Firestore data.

final List<Map<String, dynamic>> fakeProjects = [
  {
    'id': '1',
    'title': 'Web Application Assessment',
    'target': 'example.com',
    'scope': 'Full security audit of e-commerce platform',
    'description': 'Testing all web applications for security vulnerabilities',
    'status': 'Pending Review',
    'createdAt': '09 Jul 2025, 10:30 AM',
    'findingCount': 12,
  },
  {
    'id': '2',
    'title': 'API Security Assessment',
    'target': 'api.example.com',
    'scope': 'REST API endpoints',
    'description': 'Testing API authentication and authorization',
    'status': 'Draft',
    'createdAt': '10 Jul 2025, 09:00 AM',
    'findingCount': 5,
  },
  {
    'id': '3',
    'title': 'Mobile App Penetration Test',
    'target': 'app.example.com',
    'scope': 'iOS and Android client apps',
    'description': 'Testing mobile app for insecure storage and network calls',
    'status': 'Revision Required',
    'createdAt': '11 Jul 2025, 02:15 PM',
    'findingCount': 8,
  },
];

final List<Map<String, dynamic>> fakeFindings = [
  {
    'id': 'f1',
    'projectId': '1',
    'title': 'SQL Injection',
    'severity': 'Critical',
    'description':
        'SQL injection vulnerability found in the login page parameter "username".',
    'recommendation': 'Use parameterized queries with prepared statements.',
    'status': 'Open',
    'createdAt': '09 Jul 2025, 10:30 AM',
  },
  {
    'id': 'f2',
    'projectId': '1',
    'title': 'Cross-Site Scripting (XSS)',
    'severity': 'High',
    'description': 'Reflected XSS in search parameter.',
    'recommendation': 'Sanitize and encode all user input.',
    'status': 'Open',
    'createdAt': '09 Jul 2025, 11:00 AM',
  },
  {
    'id': 'f3',
    'projectId': '1',
    'title': 'IDOR Vulnerability',
    'severity': 'Medium',
    'description': 'Insecure direct object reference in profile.',
    'recommendation': 'Check ownership before returning data.',
    'status': 'Open',
    'createdAt': '09 Jul 2025, 11:30 AM',
  },
  {
    'id': 'f4',
    'projectId': '1',
    'title': 'Missing Security Headers',
    'severity': 'Low',
    'description': 'Missing Content-Security-Policy header.',
    'recommendation': 'Add appropriate security headers.',
    'status': 'Open',
    'createdAt': '09 Jul 2025, 12:00 PM',
  },
];
