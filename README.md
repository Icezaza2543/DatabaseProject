# CPE Year 3 Database Project

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

This repository contains the Database System mini-project developed for the Computer Engineering (CPE) 3rd Year Database course. The application demonstrates core CRUD logic, state management, and clear architecture.

## 🚀 Features
- **Student Database Management**: Add, view, and delete student records based on major and GPA.
- **State Management**: Clean state updates using `Provider` ensuring decoupled logic from UI.
- **Clean Architecture**: Separated into Models, Views (Pages), and Services.
- **Responsive UI**: Built with standard Flutter widgets and Material Design.

## 📁 Project Structure
The codebase has been refactored and organized into proper directories to maintain readability and modularity:
- `lib/models/` - Contains data schemas and JSON serialization (e.g., `student.dart`).
- `lib/services/` - Contains the database logic and state management mock services (e.g., `database_service.dart`).
- `lib/pages/` - Contains the UI screens.
- `lib/main.dart` - Application entry point utilizing `MultiProvider`.

## 🛠️ Refactoring & Improvements Applied
1. **Organized File Structure**: Rebuilt the Flutter standard `lib/` directory structure.
2. **Improved Logic Code**: Implemented the Service/Repository pattern using `Provider` for state management, making database operations scalable.
3. **Clean Code**: Eliminated unused imports, missing packages, and spaghetti structure from initial states.

## 🏃 Getting Started
1. Ensure you have Flutter SDK installed.
2. Clone the repository to your local machine.
3. Run `flutter pub get` to fetch required dependencies.
4. Run the application using `flutter run` on your preferred emulator or device.
