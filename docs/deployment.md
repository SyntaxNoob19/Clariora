# Clariora Deployment Documentation

This document describes how to build, package, and deploy the Clariora mobile application, website landing page, and backend services.

---

## 1. Mobile Application Compilation

To distribute the Android application package (APK):

1.  **Preparation**: Make sure all asset declarations inside `pubspec.yaml` are verified and check that local properties point to the correct Android SDK directory.
2.  **Compile the Binary**: Run the following compilation command in your terminal:
    ```bash
    flutter build apk --release
    ```
3.  **Output Path**: The compiled Android executable is saved at:
    `build/app/outputs/flutter-apk/app-release.apk`
4.  **Distribution Rename**: For deployment, copy `app-release.apk` to the website folder, rename it to `Clariora.apk`, and push it to deployment to enable direct web downloads.

---

## 2. Website Hosting & Deployment

The landing page is hosted using **Netlify** and served at [https://clariora.netlify.app/](https://clariora.netlify.app/).

### Manual Deployment via Drag-and-Drop
1.  Compile the Flutter APK and copy it to [website/Clariora.apk](../website/Clariora.apk).
2.  Compress or gather the contents of the [website/](../website/) folder.
3.  Upload the folder directly to the Netlify Dashboard.

### Deploying via Netlify CLI
1.  Install the CLI tool globally:
    ```bash
    npm install -g netlify-cli
    ```
2.  Authenticate your session:
    ```bash
    netlify login
    ```
3.  Initiate deployment:
    ```bash
    netlify deploy --dir=mentalhealthapp/website --prod
    ```

---

## 3. Database & Authentication Setup

### Firebase Authentication
Enable **Email/Password sign-in** inside the Firebase Authentication console. This setup automatically handles token issuance and credentials validation.

### Cloud Firestore Rules
Configure your security rules to allow authenticated users to update their own journal logs and chat in the community channels while protecting admin configuration collections:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
  
    // Allow users to manage their own journal entries
    match /users/{userId}/journal_entries/{entry} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow reading discussion categories and quiz definitions
    match /categories/{category} {
      allow read: if true;
      allow write: if false; // Admin only seeding
      
      match /chatrooms/{chatroom} {
        allow read: if true;
        allow write: if false; // Admin only seeding
        
        // Allow sending and receiving messages in community forums
        match /messages/{message} {
          allow read: if request.auth != null;
          allow write: if request.auth != null && request.resource.data.senderId == request.auth.uid;
        }
      }
    }
    
    match /quizzes/{quiz} {
      allow read: if true;
      allow write: if false;
      
      match /questions/{question} {
        allow read: if true;
        allow write: if false;
      }
    }
  }
}
```
