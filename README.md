# 💬 Flutter Chat App

A full-featured, real-time chat application built with **Flutter** and **Firebase** — designed from scratch with a focus on clean architecture, performance, and a polished user experience.

> Built as a hands-on university project to deeply understand mobile app development, real-time systems, and scalable architecture — not a tutorial clone.

---

## ✨ Features

### 💬 Core Messaging
- Real-time messaging powered by **Cloud Firestore**
- **Optimistic UI** — messages appear instantly before server confirmation
- Message delivery status: `Sending → Sent → Delivered → Read`

### 🔁 Failed Message Retry
- Failed messages are **persisted locally with Hive** so they're never lost
- Users can retry with a single tap — no re-typing, no frustration
- Powered by a custom `HiveFailedMessageModel` per chat room

### 🟢 Online & Offline Presence
- Live **online/offline status** for every user via **Firebase Realtime Database**
- **Last seen** timestamp updates automatically when a user goes offline
- Efficient listeners that clean up on disconnect

### ✍️ Typing Indicators
- Real-time typing bubbles powered by **Firebase Realtime Database**
- No polling — pure event-driven listeners
- Automatically clears when the user stops typing or leaves the chat

### 🔔 Push Notifications
- Custom **Node.js / Express** backend hosted on **Railway**
- Uses **FCM v1 API** with **OAuth2 Service Account** authentication
- Notifications delivered even when the app is fully closed
- Handles `onMessageOpenedApp` to navigate directly to the relevant chat

### 👥 Friend & Request System
- Send, receive, and accept **friend requests** in real time
- Requests streamed with `asyncMap` for name enrichment
- Clean `RequestModel` with Firestore factory constructors

### 🗑️ Per-User Soft Chat Deletion
- Deleting a chat only removes it for **you** — the other user's history is untouched
- Implemented via per-user deletion flags in Firestore

### ⚡ Offline-First with Hive Caching
- Messages cached **per chat room** using **Hive**
- Conversations load instantly from local cache, then sync with Firestore
- Custom `HiveMessageModel` with full serialization support

### 🖼️ Image Sharing
- Images uploaded and served via **Cloudinary**
- Efficient URL-based storage — no base64 blobs in Firestore

---

## 🏗️ Architecture & Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Material 3) |
| **State Management** | Provider + `ChangeNotifierProxyProvider` |
| **Authentication** | Firebase Auth |
| **Database** | Cloud Firestore + Firebase Realtime Database |
| **Local Cache** | Hive |
| **Push Notifications** | FCM v1 API + custom Node.js backend |
| **Image Storage** | Cloudinary |
| **Backend** | Node.js / Express on Railway |

### State Management Design
- `ChatProvider` manages per-chat message streams and state
- `HomeProvider` manages chat list and global user state
- `ChangeNotifierProxyProvider` chains providers cleanly
- `_isDisposed` flag with `_safeNotify()` prevents "deactivated widget ancestor" crashes

### Stream Lifecycle
- Streams are carefully subscribed and cancelled with `dispose()`
- Race conditions handled explicitly during navigation and screen teardown
- No dangling listeners or memory leaks

---

## 🎨 Design System

| Token | Value |
|---|---|
| **Font** | Poppins |
| **Design Language** | Material 3 |
| **Primary Color** | `#1CBBB0` (Teal) |
| **Accent Color** | `#C7FA00` (Lime Green) |
| **Received Bubble** | `#EDE5D8` (Warm Beige) |

---

## 📁 Project Structure

```
lib/
├── models/
│   ├── chat_model.dart
│   ├── message_model.dart
│   └── request_model.dart
├── providers/
│   ├── chat_provider.dart
│   └── home_provider.dart
├── services/
│   ├── chat_services.dart
│   └── request_services.dart
├── cache/
│   ├── hive_message_model.dart
│   └── hive_failed_message_model.dart
├── screens/
│   ├── home_screen.dart
│   ├── chat_screen.dart
│   └── ...
└── main.dart

backend/          ← Node.js / Express (deployed on Railway)
├── index.js
└── ...
```

---

## 🔐 Security

- **Firestore Security Rules** — users can only read/write their own data
- **FCM credentials** stored as environment variables on Railway (never hardcoded)
- **OAuth2 Service Account** flow for FCM v1 API — no legacy server keys

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x+)
- Firebase project with Firestore, Realtime Database, Auth, and FCM enabled
- Node.js (for the notification backend)
- Cloudinary account

### Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/flutter-chat-app.git
   cd flutter-chat-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platform folders
   - Enable Firestore, Realtime Database, Authentication (Email/Password), and FCM in the Firebase Console

4. **Configure Cloudinary**
   - Add your Cloudinary cloud name and upload preset to your environment config

5. **Set up the backend**
   ```bash
   cd backend
   npm install
   ```
   - Add your FCM service account JSON as an environment variable
   - Deploy to Railway or run locally with `node index.js`

6. **Run the app**
   ```bash
   flutter run
   ```

---

## 📸 Screenshots

> *(Add your screenshots here)*

---

## 🧠 What I Learned

This project pushed me to deeply understand:

- Real-time stream management and lifecycle in Flutter
- Hive local caching strategies for chat apps
- FCM v1 API with OAuth2 — no more deprecated server keys
- Firestore security rules that actually protect user data
- Debugging race conditions, memory leaks, and widget lifecycle crashes
- Building and deploying a production Node.js backend on Railway

---

## 📦 Key Dependencies

```yaml
dependencies:
  firebase_core:
  firebase_auth:
  cloud_firestore:
  firebase_database:
  firebase_messaging:
  provider:
  hive:
  hive_flutter:
  cloudinary_public:
  http:
```

---

## 🙋 About

Built by **Mamoon** — a CS student and Flutter developer passionate about building things from first principles.

- 💼 [LinkedIn](https://linkedin.com/in/your-profile)
- 🐙 [GitHub](https://github.com/your-username)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
