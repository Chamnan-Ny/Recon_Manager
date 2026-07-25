// Simple constants used across the app.

// The 5 severity levels a finding can have.
enum Severity { critical, high, medium, low, informational }

// The 2 statuses a project can have right now.
// More statuses (like "approved") will be added later
// when the Manager feature is built.
enum ProjectStatus { draft, pendingReview }

class Constants {
  // Firestore collection names.
  static String usersCollection = 'users';
  static String projectsCollection = 'projects';
  static String findingsCollection = 'findings';
  static String evidenceCollection = 'evidence';
}
