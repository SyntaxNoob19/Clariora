# Clariora Architecture Documentation

This document describes the design and technical architecture of the Clariora student mental well-being application. The project is designed with a lightweight, multi-layered architecture suitable for a mobile application utilizing Firebase and AI services.

---

## Architectural Overview

Clariora is structured using a multi-layer decoupling pattern that isolates the User Interface from state variables, logic layers, and third-party API endpoints.

### Systems Architecture Diagram

```mermaid
graph LR
    User([User]) <--> UI[Flutter UI Layer]
    UI <--> Prov[Provider State Management]
    UI --> Serv[Services Layer]
    Serv <--> API[Firebase / Gemini / External APIs]
    API -->|Response| UI
```

1. **UI Layer (`lib/screens/`, `lib/widgets/`)**: Declarative Flutter widgets that render the application UI. They consume state from `Provider` components or listen directly to Firestore streams.
2. **Controllers Layer (`lib/controllers/`)**: Dedicated controllers for managing user inputs and validation during specific workflows like Sign In and Sign Up.
3. **State Management (`lib/provider/`)**: Uses Flutter's `Provider` package (ChangeNotifier) to share global states (user data, active theme) down the widget tree.
4. **Services Layer (`lib/services/`)**: Static helper classes that isolate interactions with Firebase, HTTP web APIs, and device features (audio players, local settings).
5. **Data Layer (Firebase / External APIs)**: Secure cloud data hosting and AI processing.

---

## Use Case Diagram

The following diagram maps out the primary use cases of the application, representing how a student user interacts with Clariora's features:

```mermaid
graph LR
    User([Student User]) --- UC1(Register & Login)
    User --- UC2(Write Daily Journal)
    User --- UC3(View AI Journal Insights)
    User --- UC4(Chat with AI Companion)
    User --- UC5(Take Mood & Personality Quizzes)
    User --- UC6(Join Discussion Chatrooms)
    User --- UC7(View Wellness Resources & Articles)
    User --- UC8(Manage Profile & Soothing Themes)
```


---

## State Management Approach

Clariora uses the **Provider** package for dependency injection and state propagation. The application root registers these providers globally inside `lib/main.dart` using a `MultiProvider`:

*   **`UserProvider` (`lib/provider/user_provider.dart`)**:
    *   Tracks the current user's profile information (Username, Email).
    *   Exposes a method `getUserData()` that fetches user records from Firestore and updates the UI reactively when the user logs in.
*   **`ThemeProvider` (`lib/provider/theme_provider.dart`)**:
    *   Stores the current visual theme state (Light Mode vs. Dark Mode).
    *   Reads and writes preferences to persistent local storage using `shared_preferences` so themes persist between app restarts.

---

## Services & Integrations

The service layer forms the core logic bridge. There are six main service modules:

| Service | File Path | Responsibility | Integrations |
| :--- | :--- | :--- | :--- |
| **`ChatService`** | [chat_service.dart](../app/lib/services/chat_service.dart) | Connects directly to Google Gemini REST endpoints. Houses system prompts for the Chatbot, Journal Analyzer, and Quiz recommendations. | Google Gemini API (gemini-2.5-flash) via HTTP |
| **`JournalService`** | [journal_service.dart](../app/lib/services/journal_service.dart) | Saves and deletes user journal entries, requesting sentiment insights from the Gemini API and writing responses to Firestore. | Cloud Firestore & `ChatService` |
| **`FirestoreService`** | [firestore_service.dart](../app/lib/services/firestore_service.dart) | Pre-seeds chatroom categories and forums into Cloud Firestore collections if they don't already exist. | Cloud Firestore |
| **`QuizService`** | [quiz_service.dart](../app/lib/services/quiz_service.dart) | Uploads static quiz questions (Mood Quiz & Personality Quiz) to Firestore on initialization. | Cloud Firestore |
| **`QuoteService`** | [quote_service.dart](../app/lib/services/quote_service.dart) | Fetches a random motivational quote to display on the dashboard screen, falling back to a static quote if offline. | HTTP (api.quotable.io) |
| **`ArticleService`**| [article_service.dart](../app/lib/services/article_service.dart) | Fetches educational articles related to mental wellness from Firestore. | Cloud Firestore |


---

## Core Data Flows

### AI-Powered Journaling Workflow
When a user writes in their journal, the application triggers a sequential flow to predict emotion and fetch comforting insights.

```mermaid
sequenceDiagram
    autonumber
    actor User as User App UI
    participant JS as JournalService
    participant CS as ChatService
    participant Gemini as Gemini API
    participant DB as Cloud Firestore

    User->>JS: saveJournalEntry(text)
    activate JS
    JS->>CS: sendMessage(text, "diary")
    activate CS
    Note over CS: Appends specialized system prompt<br/>requesting MOOD|INSIGHT format.
    CS->>Gemini: POST /gemini-2.5-flash:generateContent?key=API_KEY
    Gemini-->>CS: Returns AI analysis response
    CS-->>JS: Returns raw text response
    deactivate CS
    
    Note over JS: Parses response using split('|')<br/>and runs normalizeMood() helper.
    
    JS->>DB: Write document to users/{uid}/journal_entries
    Note over DB: Stores: text, mood, date, and insights
    DB-->>JS: Success acknowledgment
    JS-->>User: Update Journal stream list
    deactivate JS
```

### Personality & Mood Quiz Workflow
1.  **Quiz Seeding**: On setup, the administrator triggers `QuizService.addQuizQuestions()` which populates `/quizzes/{quizType}/questions` in Firestore.
2.  **Taking the Quiz**: The `QuizQuestionPage` pulls the questions from Firestore, presenting them as a multi-step form to the user.
3.  **Insights Generation**: When the user answers the final question, the app sends a request to `ChatService` with the instructions: *"Analyze the user's quiz responses to provide personalized insights... Offer supportive advice..."* and the category parameter `"quiz"`.
4.  **Results Render**: The generated response is passed down to `QuizResultsPage` alongside the user's responses, rendering them dynamically on the screen.
