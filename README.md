# Dormitory Management App

An iOS application for dormitory residents and administrators built with SwiftUI and Firebase. This app streamlines communication and request management in university dormitories.

## Features

### For Residents
- **User Authentication** - Secure login and registration with Firebase Auth
- **Profile Management** - View personal information and dormitory details
- **Announcements** - Stay updated with important dormitory notifications
- **Request System** - Submit maintenance requests and track their status
- **Password Reset** - Secure password recovery via email

### For Administrators  
- **User Management** - Oversee resident accounts and information
- **Announcement Creation** - Post important notifications to residents
- **Request Management** - Review and manage resident requests
- **Multi-Dormitory Support** - Manage multiple dormitory buildings

## Technology Stack

- **Frontend**: SwiftUI
- **Backend**: Firebase (Firestore, Authentication)
- **Architecture**: MVVM with Combine
- **Language**: Swift 5.0+
- **Minimum iOS**: 15.0

## Screenshots

### Authentication Flow
- Clean login interface with email/password authentication
- Comprehensive registration form with dormitory selection
- Error handling and validation

### Main Features
- **Announcements**: Real-time notifications from administration
- **User Profile**: Personal information and dormitory details  
- **Request System**: Submit and track maintenance requests
- **Settings**: Account management and security options

## Architecture

### MVVM Pattern
- **Models**: Data structures for User, Notification, Request, and Dormitory
- **Views**: SwiftUI views for each feature area
- **ViewModels**: Business logic and state management with Combine
- **Managers**: Firebase service layer for data operations

### Key Components
- `AuthManager` - Handles Firebase Authentication
- `UserManager` - User profile and account management
- `NotificationManager` - Announcement system
- `RequestManager` - Maintenance request handling
- `BaseViewModel` - Shared functionality across ViewModels
