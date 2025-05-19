# League Better Client

## Overview
League Better Client is a Flutter-based application designed to enhance the League of Legends client experience. It provides a modern, user-friendly interface for managing game-related data, including champion information and matchmaking details. Currently, the application allows users to join someone's lobby and start a game, from lobby to champion select.

## Project Structure
- **lib/models/**: Contains Dart model classes that represent various data structures used in the application. Each model class includes a `fromJson` factory constructor for deserialization and a `toJson` method for serialization.
- **lib/api/**: Houses API-related code, including the `BetterClientApi` class and extensions for image services. This section also includes the use of the LCU API and WebSockets for real-time communication with the League of Legends client.
- **lib/screens/**: Contains the UI screens of the application.
- **lib/widgets/**: Reusable UI components used across the application.

## Key Features
- **Lobby Management**: Join someone's lobby and start a game, from lobby to champion select.
- **Champion Management**: View and manage champion details, including spells and tactical information.
- **User Interface**: A modern and intuitive UI built with Flutter.

## Getting Started
1. **Prerequisites**: Ensure you have Flutter installed on your machine.
2. **Installation**: Clone the repository and run `flutter pub get` to install dependencies.
3. **Running the App**: Use `flutter run` to start the application on your preferred device or emulator.
4. **Note**: The League of Legends client must be open for the application to function properly. Efforts are ongoing to find a way to eliminate this dependency.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
