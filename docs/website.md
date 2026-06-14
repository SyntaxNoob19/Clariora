# Clariora Landing Website Documentation

Clariora features a professional, responsive landing website deployed at [https://clariora.netlify.app/](https://clariora.netlify.app/). The website serves as the primary marketing, demonstration, and distribution portal for the Clariora mobile application.

---

## Website Architecture & File Layout

The source code for the landing page is hosted inside the [website/](../website/) folder of this repository:

*   **`index.html`**: The main page. Houses the Hero header section, dynamic screenshot carousel showcase, product features grid, demo video player, and a footer listing emergency contact helplines.
*   **`ABOUT.html`**: A secondary page detailing the development team, mission objectives, and the learning motivation behind the project.
*   **`style.css`**: The main style sheet. Configures the responsive grid layout, typography, navigation behavior, and color schemes.
*   **`ABOUT.css`**: Custom styling for team profile cards and info sections inside the About page.
*   **`fea.css`**: Specific style declarations for the 6-column features grid display.
*   **`script.js`**: Contains a clean JavaScript helper to toggle the header menu on mobile viewport breaks.
*   **`Clariora.apk`**: Host file placeholder for users to download and install the compiled Android application package directly from their browser.

---

## Core Features Displayed

The site maps out the six central modules of the mobile application in a clean responsive grid layout:
1.  **Meditation**: Details mindfulness breathing GIFs and relaxation music players.
2.  **AI Chatbot**: Highlights Clariora's empathetic dialogue capabilities.
3.  **Diary**: Showcases journal logs, emotion classification, and Gemini insights.
4.  **Discover Yourself**: Explains self-discovery quizzes (Mood and Personality).
5.  **Community**: Outlines category-based real-time peer chatrooms.
6.  **Recommendation**: Mentions recommendations for books, movies, and quotes.

---

## Mobile Application Integration

*   **App Distribution (APK)**: The hero call-to-action button and footer navigation link directly reference `Clariora.apk`. This allows users to download the compiled Android binary and side-load the application.
*   **Promotional Media**: The video container on the website loads `video_cLari.mp4` (stored locally in the repository as [assets/demo/Clariora.mp4](../assets/demo/Clariora.mp4)), showcasing screen recordings of user registration, journaling, mood analytics, and real-time chat.
*   **Branding & Style Uniformity**: The web pages adopt identical branding logos, asset images, and color schemes (lavender gradients, deep violet accents) used in the Flutter application UI to project a unified visual identity.
