# Loan Service App

A complete loan service application with real backend connectivity and authentication built with Flutter.

## Features

### User (Borrower) Features:
- Google Sign-In Authentication
- Profile Setup with contact details (phone, address)
- KYC Verification with document upload (Aadhar/PAN)
- Loan Dashboard:
  - View borrowed amounts
  - Check interest rates
  - Monitor EMI due dates
  - Make payments via UPI
- Apply for new loans with customizable amount and tenure

### Admin (Lender) Features:
- Admin Dashboard with overview of all loans
- User management and KYC approval
- Loan request approval/rejection system
- Configure loan terms (amount, interest, due dates)
- Mark payments as paid/unpaid

## Tech Stack

- **Flutter** for cross-platform mobile development
- **Firebase Authentication** for user authentication
- **Firebase Firestore** for database
- **Firebase Storage** for file storage
- **Cloudinary** for KYC document storage
- **GetX** for state management, routing, and dependency injection
- **UPI Intent** for payment integration

## Project Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Firebase account
- Cloudinary account

### Firebase Setup
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add an Android app to the Firebase project (use `com.loanservice.loan_app` as package name)
3. Download the `google-services.json` file and place it in the `android/app` directory
4. Enable Authentication (Google Sign-In method)
5. Create Firestore Database
6. Set up Storage

### Cloudinary Setup
1. Create a Cloudinary account
2. Get your Cloud name, API Key and API Secret

### Environment Variables
Create a `.env` file in the root of your project with the following variables:
```
# Firebase Configuration
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_auth_domain.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_storage_bucket.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_APP_ID=your_app_id

# Cloudinary Configuration
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

### Running the Project
1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Set up the required configuration files as described above
4. Run `flutter run` to start the application

## Firebase Security Rules

### Firestore Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User profiles
    match /users/{userId} {
      allow read: if request.auth != null && (request.auth.uid == userId || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Loans
    match /loans/{loanId} {
      allow read: if request.auth != null && (resource.data.userId == request.auth.uid || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
      
      // Loan payments
      match /payments/{paymentId} {
        allow read: if request.auth != null && (get(/databases/$(database)/documents/loans/$(loanId)).data.userId == request.auth.uid || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
      }
    }
  }
}
```

### Storage Rules
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /kyc/{userId}/{filename} {
      allow read: if request.auth != null && (request.auth.uid == userId || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## App Architecture

The project follows the GetX pattern with a clean architecture approach:

- **app/data/models**: Data models
- **app/data/services**: Services for API interaction
- **app/modules**: Feature modules with MVC pattern
- **app/routes**: App routing
- **app/utils**: Utility functions and helpers
- **app/widgets**: Reusable UI components

## Setting Up Admin Account

To create an admin account:
1. Create a regular user account with Google Sign-In
2. In Firebase Firestore, locate the user document
3. Add the field `isAdmin: true` to the user document

## License

This project is licensed under the MIT License.
