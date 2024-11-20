# Vision AI Multiplatform App

A cross-platform application for image analysis and processing using AI capabilities.

## Overview

Vision AI is a multiplatform application that allows users to:
- Upload images (via file or URL)
- Analyze images using AI
- Track image processing status
- Search and manage their image history

## Features

### Authentication
- User registration with UUID
- Secure login system
- JWT token-based authentication
- Persistent login state

### Image Management
- Upload images from device storage
- Upload images via URL
- View processing status
- Search images by:
  - Source type (URL/File)
  - Date range
  - Processing status
  - Image digest (unique SHA256 hash identifier for container images)
- Delete images
- View detailed image analysis results

## Technical Details

### API Endpoints

#### Authentication
- `POST /api/user/register` - Create new user account
- `POST /api/user/login` - Authenticate user and get JWT token
- `GET /api/user/profile` - Get user profile information

#### Image Operations
- `POST /api/user/images/upload` - Upload image file
- `POST /api/user/images/upload` - Upload image via URL
- `GET /api/user/images` - List all user images
- `GET /api/user/images/{id}` - Get specific image details
- `GET /api/user/images/search` - Search images with filters
- `DELETE /api/user/images/{id}` - Delete an image
- `GET /api/user/images/{id}/status` - Check image processing status

### Security
- JWT token-based authentication
- Secure token storage using Flutter Secure Storage
- Protected API endpoints
- Input validation

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- iOS development setup (for iOS)
- Android development setup (for Android)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/vision_ai_multiplatform.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure the API endpoint:
Edit `lib/src/services/api_service.dart` and set your API URL:
```dart
static const String baseUrl = 'http://your-api-url/api';
```

4. Run the app:
```bash
flutter run
```

## Development

### Project Structure
```
lib/
├── src/
│   ├── models/         # Data models
│   ├── providers/      # State management
│   ├── screens/        # UI screens
│   ├── services/       # API services
│   ├── utils/          # Utilities
│   └── widgets/        # Reusable widgets
└── main.dart          # App entry point
```

### State Management
- Uses Riverpod for state management
- AuthProvider handles authentication state
- Secure token storage for persistent login

### Testing
- Unit tests for services and providers
- Widget tests for UI components
- Integration tests for full user flows

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Postman for API documentation tools
- Contributors and maintainers
