# RedDoc

## A Penetration Testing Report Management Application

RedDoc is a Flutter-based penetration testing report management application designed to help penetration testers organize, document, and manage vulnerability findings during security assessments. The application provides a centralized platform for creating penetration testing projects, recording vulnerabilities, attaching evidence screenshots, and managing reports in the cloud.

RedDoc uses Firebase Authentication for secure user registration and login, Cloud Firestore for cloud-based data storage, and Firebase Storage for storing vulnerability evidence. The application follows a layered architecture using models, repositories, services, and UI components to demonstrate clean software engineering practices.

This project is developed as an educational cybersecurity mobile application for the **Mobile Development in Cybersecurity** course. It demonstrates Flutter development, Firebase integration, CRUD operations, image upload, repository architecture, and cloud-based penetration testing report management.

**Note:** The current version focuses on the **Report Designer** module. The **Manager review workflow** will be implemented in a future version.

---

# Project Direction

**Cybersecurity Application – Penetration Testing Report Management**

RedDoc assists penetration testers in documenting and organizing vulnerability findings throughout the penetration testing process. Instead of creating traditional PDF reports, the application provides a centralized cloud workspace where users can create projects, manage findings, upload evidence, and organize penetration testing reports efficiently.

---

# Key Features

## Authentication

- Register with email and password
- Login using Firebase Authentication
- Secure logout

## Project Management

Users can:

- Create penetration testing projects
- View project information
- Edit project details
- Delete projects
- Search projects

## Vulnerability Findings Management

Users can:

- Add vulnerability findings
- Edit findings
- Delete findings
- Assign severity levels
- Write vulnerability descriptions
- Add remediation recommendations

## Evidence Upload

Users can upload supporting evidence such as:

- Burp Suite screenshots
- Browser screenshots
- Request/Response captures
- Proof-of-concept screenshots

Evidence is stored securely using Firebase Storage.

## Cloud Database

Project information and vulnerability findings are synchronized using Cloud Firestore.

## Search, Filter, and Sort

Users can:

- Search projects
- Search findings
- Filter findings by severity
- Sort findings alphabetically
- Sort findings by creation date

## Layered Architecture

The project follows a layered architecture using:

- models
- data
- repositories
- services
- ui/screens
- ui/widgets

---

# Data Managed in RedDoc

The application manages:

- Penetration testing projects
- Vulnerability findings
- Severity levels
- Recommendations
- Evidence screenshots
- Project metadata

---

# Technology Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Mobile application framework |
| Dart | Programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| Firebase Storage | Evidence image storage |
| image_picker | Upload screenshots |
| Stateful Widgets | State management |
| Repository Pattern | Data access layer |

---

# Current User Role

## Report Designer

The current version of RedDoc focuses on the Report Designer role.

Responsibilities:

- Create penetration testing projects
- Manage project information
- Add vulnerability findings
- Edit vulnerability findings
- Delete vulnerability findings
- Upload evidence screenshots

---

# App Screens

## 1. Splash Screen

Checks the authentication state and redirects users to the appropriate screen.

## 2. Login Screen

Allows existing users to log in using Firebase Authentication.

## 3. Register Screen

Allows new users to create an account.

## 4. Dashboard Screen

Displays project statistics and recently created projects.

## 5. Create Project Screen

Allows users to create a new penetration testing project.

## 6. Project Detail Screen

Displays project information and a list of vulnerability findings.

## 7. Finding Form Screen

Allows users to create or edit vulnerability findings.

## 8. Finding Detail Screen

Displays complete vulnerability information including:

- Severity
- Description
- Recommendation
- Evidence screenshots

## 9. Profile Screen

Allows users to view profile information and log out.

---

# Basic User Flow

```text
Open App
    ↓
Splash Screen
    ↓
Login / Register
    ↓
Firebase Authentication
    ↓
Dashboard
    ↓
Create Project
    ↓
Project Detail
    ↓
Add Finding
    ↓
Upload Evidence
    ↓
Save Finding
```

---

# Project Structure

```text
lib/
│
├── models/
│   ├── user_model.dart
│   ├── project_model.dart
│   ├── finding_model.dart
│   └── evidence_model.dart
│
├── data/
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── project_repository.dart
│   │   ├── finding_repository.dart
│   │   └── storage_repository.dart
│   │
│   └── services/
│       ├── firebase_auth_service.dart
│       ├── firestore_service.dart
│       ├── storage_service.dart
│       └── image_picker_service.dart
│
├── ui/
│   ├── screens/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── project/
│   │   ├── finding/
│   │   └── profile/
│   │
│   ├── widgets/
│   └── theme/
│       └── app_theme.dart
│
├── firebase_options.dart
└── main.dart
```

---

# Model Classes

## UserModel

Represents the authenticated user.

Fields:

- uid
- name
- email

## ProjectModel

Represents a penetration testing project.

Fields:

- projectId
- title
- target
- scope
- createdAt
- status
- description

## FindingModel

Represents a vulnerability finding.

Fields:

- findingId
- projectId
- title
- severity
- description
- recommendation
- createdAt
- status

## EvidenceModel

Represents uploaded vulnerability evidence.

Fields:

- evidenceId
- findingId
- imageUrl
- note

---

# Cloud Firestore Collections

## users

Stores authenticated user information.

## projects

Stores penetration testing projects.

## findings

Stores vulnerability findings.

## evidence

Stores uploaded evidence metadata.

---

# Severity Levels

- Critical
- High
- Medium
- Low
- Informational

---

# Security Notes

RedDoc is designed to securely manage penetration testing reports.

Security principles include:

- Firebase Authentication securely manages user accounts.
- Cloud Firestore stores project and finding data.
- Firebase Storage stores uploaded evidence.
- Authentication is required before users can access project data.

---

# Project Setup

## Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Firebase Project
- FlutterFire CLI

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/Chamnan-Ny/RedDoc.git
cd reddoc
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Enable the following Firebase services:

- Authentication (Email & Password)
- Cloud Firestore
- Firebase Storage

Run:

```bash
flutterfire configure
```

### 4. Verify Flutter setup

```bash
flutter doctor
```

### 5. Run the application

```bash
flutter run
```

---

# Required Packages

Main packages:

- firebase_core
- firebase_auth
- cloud_firestore
- firebase_storage
- image_picker
- intl
- uuid

Development packages:

- flutter_lints

---

# Future Improvements

## Manager Module

- Manager authentication
- Manager dashboard
- Review penetration testing reports
- Approve or reject reports
- Request report revisions
- Review comments
- Report status workflow
- Role-Based Access Control (RBAC)

## Additional Features

- PDF report export
- CVSS score calculator
- Push notifications
- Email notifications
- Activity history
- Team collaboration
- Report templates
- Dark mode
- Multi-language support

---

# Contributors

**Prepared By:**

- Ny Chamnan
- Song Saknora

**Course:** Mobile Development in Cybersecurity

**Lecturer:** Mr. Ronan Ogor

**Department:** Telecom and Networking, Cyber Security

**Institution:** Cambodia Academy of Digital Technology (CADT)

---

# License

This project is developed for educational purposes as part of the **Mobile Development in Cybersecurity** course at the Cambodia Academy of Digital Technology (CADT).
