
# ibl_test_app

`ibl_test_app` is a Flutter application designed to interact with the Python-based backend provided by the `UR-langflow` project. The app allows users to connect to the backend via WebSockets, enabling real-time communication with a locally deployed, finetuned Large Language Model (LLM) and custom tools provided by Langflow.

## Features

- **WebSocket Communication**: Seamlessly connects with the Python backend using WebSockets.
- **JWT Authentication**: Secure communication using token-based authentication.
- **Cross-Platform**: Runs on both Android and iOS.
- **State Management with GetX**: Efficient state management and navigation using the GetX package.
- **Modular Structure**: Organized codebase with clear separation of concerns.

## Getting Started

### Prerequisites

- **Flutter**: Ensure Flutter is installed on your machine. Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **Backend Setup**: Ensure the `UR-langflow` backend is running and accessible.

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/Nkurayijahubert/ibl_test_app.git
   cd ibl_test_app
   ```

2. **Install Dependencies**

   Run the following command to install the required dependencies:

   ```bash
   flutter pub get
   ```

3. **Configure the App**

   Update the backend API endpoint and WebSocket URL in the configuration files to match your setup, typically in the `services` or `utils` directory.

4. **Run the App**

   Connect your device or start an emulator, then run:

   ```bash
   flutter run
   ```

### Building for Production

To build the app for release, use the following commands:

- **Android**:

  ```bash
  flutter build apk --release
  ```

- **iOS**:

  ```bash
  flutter build ios --release
  ```

## Project Structure

```
lib/
├── main.dart               # Application entry point
|   └── app.dart            # Main application widget
├── controllers/            # State management and business logic using GetX
├── models/                 # Data models
├── services/               # API and WebSocket services
├── utils/                  # Utility classes and helper functions
└── views/                  # UI screens and widgets
```

## Usage

### Authentication

1. **Register a User**

   Use the app to register a new user by providing a username and password.

2. **Obtain a JWT Token**

   After registration, log in to obtain a JWT token, which will be used for authenticating WebSocket connections.

3. **Connect to WebSocket**

   Once authenticated, the app will connect to the WebSocket provided by the `UR-langflow` backend to start real-time communication.

### Interacting with the Backend

Use the app to send messages to the backend, which will be processed by the Langflow agent and the underlying LLM. The response will be displayed in the app.

## Contributing

Contributions are welcome! If you find any bugs or want to add new features, feel free to fork the repository and create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any inquiries or support, please reach out to [Nkurayijah Hubert](mailto:nkurayijah@gmail.com).
