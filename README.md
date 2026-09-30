<p align="center">
  <img src="docs/images/readme-banner.svg" alt="Watch It — Pick a video. Press play. A Flutter video player project." width="100%" />
</p>

<h1 align="center">🎬 Watch It — Flutter Video Player</h1>

<p align="center">
  A little video library. One tap to start watching.<br />
  Built during the <strong>Flutter Training Bootcamp at CS Academy</strong>.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Built_with-Flutter-02569B?logo=flutter&amp;logoColor=white" alt="Built with Flutter" />
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?logo=dart&amp;logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Playback-YouTube-FF0000?logo=youtube&amp;logoColor=white" alt="YouTube playback" />
  <img src="https://img.shields.io/badge/CS_Academy-Training_Project-008577" alt="CS Academy training project" />
</p>

<p align="center">
  <a href="#about">About</a> ·
  <a href="#screenshots">Screenshots</a> ·
  <a href="#features">Features</a> ·
  <a href="#learning">Learning Experience</a> ·
  <a href="#tech-stack">Tech Stack</a> ·
  <a href="#getting-started">Getting Started</a>
</p>

---

<a id="about"></a>

## 🍿 About the App

**Watch It** is a small Flutter project for browsing a video library and watching YouTube videos inside the app. Choose a video, open its own player screen, and control playback without leaving the experience.

Created as a practical exercise during the **Flutter Training Bootcamp at CS Academy**, the project explores video playback, controller lifecycle, navigation, and simple Material interfaces.

The training exercise covered **`video_player`**, which remains in the project dependencies. The current player screen uses **`youtube_player_flutter`** to embed YouTube videos.

<a id="screenshots"></a>

## 📱 A Look Inside

From choosing a video to pressing play:

<table>
  <tr>
    <th align="center" width="50%">🎞️ Your Video Library</th>
    <th align="center" width="50%">▶️ Time to Watch</th>
  </tr>
  <tr>
    <td align="center">
      <a href="docs/screenshots/video-library.jpeg"><img src="docs/screenshots/video-library.jpeg" alt="Video library with three video cards and mint-colored play buttons" width="260" /></a>
    </td>
    <td align="center">
      <a href="docs/screenshots/video-player.jpeg"><img src="docs/screenshots/video-player.jpeg" alt="Selected video with embedded playback controls and a fullscreen button" width="260" /></a>
    </td>
  </tr>
  <tr>
    <td align="center">Browse the list and choose what to watch.</td>
    <td align="center">Play, pause, seek, and switch to fullscreen.</td>
  </tr>
</table>

<a id="features"></a>

## ✨ Key Features

- 🎬 **Video Library** — A simple list of videos with a dedicated play action on each card.
- ▶️ **In-App Playback** — Open a YouTube video on its own screen with its title and player controls.
- ⏯️ **Playback Controls** — Play, pause, and seek through the video.
- ⛶ **Fullscreen Viewing** — Expand the video using the player's fullscreen control.
- 🧭 **Easy Navigation** — Move from the library to a selected video and back again.
- 💬 **Helpful Feedback** — Show a message when playback fails or the platform cannot use the player.
- 📐 **Flexible Layout** — Scrollable screens with constrained content widths for small and larger displays.

<a id="learning"></a>

## 📚 Learning Experience

This project turned a video playback lesson into hands-on practice with:

- Integrating video player packages into a Flutter application.
- Creating a player controller and releasing its resources when the screen closes.
- Passing a typed **`VideoItem`** between screens using named routes.
- Separating video data, views, routing, and shared theme configuration.
- Using clean YouTube video IDs without extra playlist or URL parameters.
- Handling playback errors and providing a fallback for unsupported platforms.
- Writing widget tests for navigation, large text, and missing route arguments.

<a id="tech-stack"></a>

## 🛠️ Tech Stack

| Purpose | Technology |
| :--- | :--- |
| UI & Language | Flutter, Dart |
| Interface | Material widgets and a shared app theme |
| YouTube Playback | `youtube_player_flutter` |
| Training Package | `video_player` — included as part of the playback exercise |
| Navigation | Flutter Navigator with named routes |
| Testing | `flutter_test` |

Package versions are listed in [pubspec.yaml](pubspec.yaml).

<a id="getting-started"></a>

## 🚀 Getting Started

### Prerequisites

- Flutter with Dart `>=3.10.4 <4.0.0`.
- A configured device, emulator, or Chrome browser.
- An internet connection to install dependencies and load YouTube videos.

### Run Locally

From the project folder:

```bash
flutter pub get
flutter devices
flutter run -d <device-id>
```

Replace `<device-id>` with an ID shown by `flutter devices`. Use `flutter doctor` to check your Flutter setup.

To run in Chrome:

```bash
flutter run -d chrome
```

The current screen enables the player on **Android, iOS, macOS, and web**. On **Windows and Linux**, it displays a platform guidance message instead of creating the player. Actual playback requires an internet connection and a video that allows embedding.

## 🎞️ Make the Library Yours

Add or update entries in [data_list.dart](lib/features/videos/data/data_list.dart):

```dart
VideoItem(
  name: 'Video 1',
  id: 'QvP9kZs3MJI',
),
```

For `https://www.youtube.com/watch?v=QvP9kZs3MJI`, use only **`QvP9kZs3MJI`** as the ID. Leave out parameters such as `&list=...` and `&index=...`.

## 🗂️ Project Structure

The video feature keeps its data and presentation code together, while `core` contains shared app configuration.

```text
lib/
├── main.dart                         # Application entry point
├── e_learning.dart                   # App configuration
├── core/
│   ├── constants/                    # Shared strings and constants
│   ├── dependency_injection/         # Dependency setup
│   ├── routing/                      # Routes and navigation
│   └── themes/                       # Colors and theme
└── features/
    └── videos/
        ├── data/                     # Video model and library entries
        └── presentation/
            ├── view_model/
            └── views/                # Library and player screens

docs/screenshots/                     # App screenshots
test/                                # Widget tests
```

## 🧪 Testing

```bash
flutter test
```

The widget tests cover opening the selected video and returning to the library, scrolling on a small screen with large text, and handling a video route without its required data. Live video playback needs a separate check on a supported device or browser.

---

<p align="center">
  <img src="assets/splash/splash.png" alt="CS Academy — Empowering your learning journey" width="240" />
</p>

<p align="center">
  <strong>Built with Flutter. Made for learning.</strong><br />
  A training project by <a href="https://github.com/ReemMohsn">ReemMohsn</a><br />
  Flutter Training Bootcamp · CS Academy
</p>
