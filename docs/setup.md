# Clariora Installation & Setup Guide

Follow this guide to set up the development environment, configure databases, secure APIs, and run the Clariora Flutter project.

---

## Prerequisites

Before getting started, make sure you have the following installed on your machine:

1.  **Flutter SDK**: Version `^3.6.0` (Dart SDK `^3.6.0`). Run `flutter doctor` to verify setup.
2.  **IDE**: VS Code (recommended) or Android Studio with Flutter extensions.
3.  **Firebase CLI**: Necessary for generating platform options if you need to configure your own databases.
4.  **Google AI Studio Account**: Required to retrieve a personal Gemini API Key.

---

## Step 1: Clone and Install Dependencies

1.  Clone the repository:
    ```bash
    git clone <your-repository-url>
    cd clariora/mentalhealthapp/app
    ```
2.  Fetch packages:
    ```bash
    flutter pub get
    ```

---

## Step 2: Assets Verification

The application relies on several static assets loaded from the local filesystem. Confirm that the following directory structure is populated inside `mentalhealthapp/app/assets/`:

*   **`app/assets/images/`**:
    *   `logo.png`: Main brand asset.
    *   `login_image.png`: Displayed on the login interface.
    *   `splash_image.jpg`: Fullscreen splash background.
*   **`app/assets/gifs/`**:
    *   Must contain the `.gif` assets used for breathing, yoga, and meditation exercises (e.g. `breathing1.gif`, `meditation1.gif`, `yoga1.gif`).
*   **`app/assets/music/`**:
    *   Must contain meditation audio files (e.g., `meditation1.mp3`, `meditation2.mp3`, `meditation3.mp3`).
*   **`app/assets/fonts/`**:
    *   `Poppins.ttf`: Primary typographic styling.

---

## Step 3: Firebase Configuration

Clariora utilizes Firebase Authentication for authentication and Cloud Firestore for databases.

1.  Create a Firebase project at the [Firebase Console](https://console.firebase.google.com/).
2.  Enable **Email/Password authentication** in your Firebase project.
3.  Enable **Cloud Firestore** and set your security rules.
4.  Configure your apps using the FlutterFire CLI inside the `app/` directory:
    ```bash
    cd app
    npm install -g firebase-tools
    firebase login
    flutterfire configure
    ```
5.  This will automatically generate the config files:
    *   **Android**: `app/android/app/google-services.json`
    *   **iOS**: `app/ios/Runner/GoogleService-Info.plist`
    *   **Shared Dart Configurations**: `app/lib/firebase_options.dart`

---

## Step 4: Run the Application

Connect an emulator or physical testing device, navigate to the `app/` folder, then execute:

```bash
cd app
flutter run
```

---

## Security: API Key Configurations

To prevent security risks, all sensitive API keys have been removed from this repository. The application is configured to load parameters dynamically:

### 1. Google Gemini API Key
The API key is retrieved at build-time using Dart environment defines in [chat_service.dart](../app/lib/services/chat_service.dart):
```dart
static const String apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'YOUR_GEMINI_API_KEY');
```

To run the application with your personal API key, supply the argument through your terminal run command:
```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE
```

Or configure your VS Code launch configurations (`app/.vscode/launch.json`) to automatically inject it:
```json
"args": [
  "--dart-define",
  "GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE"
]
```

### 2. Firebase API Keys
The Firebase web configurations are declared inside [firebase_options.dart](../app/lib/firebase_options.dart) with dummy placeholders. If you configure your own Firebase endpoints, you must regenerate this configuration locally by running:
```bash
flutterfire configure
```
This will automatically generate and configure the local keys without checking them into Git.

