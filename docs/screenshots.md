# Clariora Screenshots Documentation

All primary screenshots for Clariora are organized and stored in the repository under the [assets/screenshots/](../assets/screenshots/) folder. These captures represent the actual user interface and features implemented in the Flutter application.

---

## Folder Structure

```text
mentalhealthapp/
└── assets/
    └── screenshots/
        ├── splash_screen.png        # Initial loading splash screen
        ├── login_screen.png         # Credentials entry form
        ├── signup_screen.png        # User registration form
        ├── home_dashboard.png       # Main hub showing weekly analytics & quotes
        ├── journal_screen.png       # Emotion-coded daily journals & AI insights
        ├── discover_screen.png      # Mood & Personality quiz selector page
        ├── chatbot_screen.png       # Conversational chatbot companion thread
        ├── community_chatroom.png   # Group forum message threads
        ├── profile_screen.png       # Profile choices screen (Light Mode)
        └── profile_dark_mode.png    # Profile options screen (Dark Mode Bottom Sheet)
```

---

## Showcase & Descriptions

### 1. Splash Screen
*   **Filename**: `splash_screen.png`
*   **Path**: [assets/screenshots/splash_screen.png](../assets/screenshots/splash_screen.png)
*   **Description**: The landing view with the central lotus branding icon and Clariora's signature subtitle: *"Clarity that shines, an aura that inspires"*.

---

### 2. Authentication Portal
*   **Filenames**: `login_screen.png` and `signup_screen.png`
*   **Paths**: [assets/screenshots/login_screen.png](../assets/screenshots/login_screen.png) | [assets/screenshots/signup_screen.png](../assets/screenshots/signup_screen.png)
*   **Description**: Clean, customized text inputs for Email, Password, and Username overlaid on a gradient, linking directly to Firebase Auth.

---

### 3. Home Dashboard
*   **Filename**: `home_dashboard.png`
*   **Path**: [assets/screenshots/home_dashboard.png](../assets/screenshots/home_dashboard.png)
*   **Description**: The primary feed page. Features a randomized quote card, Weekly Mood Analysis (rendered dynamically via a donut chart based on logs), and links to wellness assets.

---

### 4. AI Journal logs
*   **Filename**: `journal_screen.png`
*   **Path**: [assets/screenshots/journal_screen.png](../assets/screenshots/journal_screen.png)
*   **Description**: Shows historical logs sorted by date. Each entry card highlights the text, an AI-classified sentiment tag (e.g. *Sad*, *Happy*), and a parsed paragraph of comfort advice from Gemini.

---

### 5. Discover Quizzes Page
*   **Filename**: `discover_screen.png`
*   **Path**: [assets/screenshots/discover_screen.png](../assets/screenshots/discover_screen.png)
*   **Description**: Presents two evaluation cards: **Mood Quiz** and **Personality Quiz**. Each has description notes and initiates question pipelines streamed from Firestore.

---

### 6. AI Chatbot Thread
*   **Filename**: `chatbot_screen.png`
*   **Path**: [assets/screenshots/chatbot_screen.png](../assets/screenshots/chatbot_screen.png)
*   **Description**: Active conversation with Clariora AI. Demonstrates Hinglish responses designed to respond empathetically.

---

### 7. Community Discussion Board
*   **Filename**: `community_chatroom.png`
*   **Path**: [assets/screenshots/community_chatroom.png](../assets/screenshots/community_chatroom.png)
*   **Description**: Displays a real-time chat room (*Time Management & Focus*). Message bubbles show active student chats synced live via Cloud Firestore.

---

### 8. User Profile & Settings
*   **Filenames**: `profile_screen.png` and `profile_dark_mode.png`
*   **Paths**: [assets/screenshots/profile_screen.png](../assets/screenshots/profile_screen.png) | [assets/screenshots/profile_dark_mode.png](../assets/screenshots/profile_dark_mode.png)
*   **Description**: Displays list tiles for customizing details, logging out, deleting profiles, and toggling dark mode configurations.
