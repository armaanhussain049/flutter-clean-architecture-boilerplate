# 🚀 Flutter Clean Architecture Boilerplate

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green)
![State Management](https://img.shields.io/badge/State-BLoC-orange)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📌 Overview

A production-ready Flutter boilerplate implementing **Clean Architecture + BLoC**, designed for scalability, maintainability, and testability.

This project is structured to help developers build large-scale applications with clear separation of concerns and industry best practices.

---

## 🧠 Architecture

The project follows **Clean Architecture**:

```
Presentation → Domain → Data
```

### 🔹 Layers

* **Presentation**: UI + BLoC (state management)
* **Domain**: Business logic (pure Dart)
* **Data**: API, models, repository implementations

### 🏗️ Architecture Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │     Domain      │    │      Data       │
│                 │    │                 │    │                 │
│ • UI Components │◄──►│ • Entities      │◄──►│ • Models        │
│ • BLoC          │    │ • Use Cases     │    │ • Repositories  │
│ • State Mgmt    │    │ • Repositories  │    │ • Data Sources  │
│                 │    │   Interfaces    │    │ • API Clients   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
       ▲                       ▲                       ▲
       │                       │                       │
       └───────────────────────┼───────────────────────┘
                               ▼
                    ┌─────────────────┐
                    │   Core          │
                    │                 │
                    │ • Error Handling│
                    │ • Network Info  │
                    │ • Utils         │
                    │ • Use Cases     │
                    └─────────────────┘
```

---

## 📂 Project Structure

```
lib/
│
├── config/
│   ├── app_config.dart          # Environment configurations
│
├── core/
│   ├── error/
│   │   └── failure.dart         # Error handling classes
│   ├── network/
│   │   ├── network_info.dart    # Network connectivity interface
│   │   └── network_info_impl.dart # Network implementation
│   ├── utils/                   # Utility functions
│   └── usecases/
│       └── usecase.dart         # Base use case class
│
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── auth_remote_data_source.dart     # Remote API interface
│       │   │   ├── auth_remote_data_source_impl.dart # API implementation
│       │   │   └── auth_local_data_source.dart      # Local storage interface
│       │   ├── models/
│       │   │   └── user_model.dart                  # Data models
│       │   └── repositories/
│       │       └── auth_repository_impl.dart        # Repository implementation
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart                        # Domain entities
│       │   ├── repositories/
│       │   │   └── auth_repository.dart             # Repository interface
│       │   └── usecases/
│       │       ├── login.dart                       # Login use case
│       │       └── logout.dart                      # Logout use case
│       └── presentation/
│           ├── bloc/
│           │   ├── auth_bloc.dart                   # Authentication BLoC
│           │   ├── auth_event.dart                  # BLoC events
│           │   └── auth_state.dart                  # BLoC states
│           └── pages/
│               └── login_page.dart                  # Login UI
│
├── injection_container.dart     # Dependency injection setup
└── main.dart                    # App entry point
```

---

## 🔥 Features

✅ Clean Architecture (Scalable & Testable)

✅ BLoC State Management

✅ Dependency Injection (get_it)

✅ Error Handling (Failure pattern)

✅ Modular Feature-Based Structure

✅ API Integration with Dio

✅ Local Caching with SharedPreferences

✅ Network Connectivity Checking

✅ Environment Configuration (Dev/Prod)

✅ Token-based Authentication

✅ Comprehensive Error Handling

---

## 🛠 Tech Stack

* Flutter
* Dart
* flutter_bloc
* get_it
* equatable
* dio
* dartz (functional programming)
* shared_preferences
* internet_connection_checker
* mockito (testing)

---

## ⚙️ Getting Started

### 1. Clone the repository

```
git clone https://github.com/your-username/flutter-clean-architecture.git
```

### 2. Install dependencies

```
flutter pub get
```

### 3. Run the app

```
flutter run
```

### 4. Run tests

```
flutter test
```

---

## 🧩 Example Flow (Login Feature)

1. **UI triggers event** → `LoginRequested`
2. **BLoC handles event** → calls `LoginUseCase`
3. **UseCase calls Repository** → orchestrates data flow
4. **Repository checks network** → calls remote/local data sources
5. **Data source fetches data** → returns result or error
6. **Response flows back** → UI updates state

### 🔄 Data Flow Diagram

```
UI Event → BLoC → Use Case → Repository → Data Source → API/Cache
    ↓         ↓        ↓          ↓          ↓          ↓
   State   Emit State  Either     Either     Either     Result
    ↑         ↑        ↑          ↑          ↑          ↑
   UI      Rebuild    Handle     Handle     Handle     Parse
```

---

## 📱 Demo Flow

1. **Launch App** → Check for cached user (auto-login)
2. **Login Screen** → Enter credentials (test@example.com / password)
3. **Home Screen** → Welcome message with user info
4. **View Posts** → Infinite scroll paginated list
5. **Offline Support** → Cached data when offline
6. **Logout** → Clear cache and return to login

### 🎬 Screenshots (Conceptual)

```
Login Screen              Home Screen               Posts List
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│ Email: ________ │      │ Welcome, User!  │      │ ┌─────────────┐ │
│ Password: _____ │      │ Email: ...      │      │ │ Post Title   │ │
│ [Login]         │      │ Token: ...      │      │ │ Post body... │ │
└─────────────────┘      │                 │      │ └─────────────┘ │
                         │ [View Posts]    │      │ ┌─────────────┐ │
                         └─────────────────┘      │ │ Loading...   │ │
                                                  │ └─────────────┘ │
                                                  └─────────────────┘
```

---

The project includes comprehensive unit tests for all layers:

* **Domain Layer**: Use cases and entities
* **Data Layer**: Repositories and data sources
* **Presentation Layer**: BLoC state management

Run tests:

```
flutter test
```

Generate mocks for testing:

```
flutter pub run build_runner build
```

---

## 🌍 Environment Configuration

The app supports multiple environments:

```dart
// Switch environment
currentFlavor = Flavor.dev;  // or Flavor.prod

// Access config
final config = appConfig;
print(config.baseUrl);      // Different for dev/prod
print(config.enableLogging); // true for dev, false for prod
```

---

## 💾 Caching & Offline Support

User authentication state is cached locally using SharedPreferences:

- **Login**: User data cached after successful authentication
- **App Start**: Check for cached user to auto-login
- **Logout**: Clear cached data

---

## 🔐 Authentication Features

- **Login/Logout**: Complete auth flow with token management
- **Auto-login**: Persist user session across app restarts
- **Token Storage**: Secure token handling
- **Error Handling**: Comprehensive error states and messages

---

## 📦 Recommended Packages

* dio → Networking
* freezed → Immutable models
* go_router → Navigation
* hydrated_bloc → State persistence
* flutter_secure_storage → Secure token storage

---

## 🚀 Future Improvements

* Dark Mode Support
* Localization (i18n)
* CI/CD Integration
* Pagination & Caching Layer
* Push Notifications
* Biometric Authentication

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repo
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## ⭐ Show Your Support

If you found this useful, please ⭐ the repository and share it with others!
