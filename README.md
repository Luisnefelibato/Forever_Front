# 💕 ForeverUsInLove - Frontend

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.16.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)
![AWS](https://img.shields.io/badge/AWS-Enabled-FF9900?logo=amazon-aws)
![License](https://img.shields.io/badge/License-Proprietary-red)

**Dating & Marketplace Application - Mobile Frontend**

*Connecting hearts through authentic relationships and verified identities*

</div>

---

## 📋 Table of Contents

- [About](#-about)
- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Docker Setup](#-docker-setup)
- [AWS Configuration](#-aws-configuration)
- [Project Structure](#-project-structure)
- [Development Guidelines](#-development-guidelines)
- [User Stories](#-user-stories)
- [Contributing](#-contributing)

---

## 🎯 About

**ForeverUsInLove** is a premium dating and marketplace application designed to create meaningful connections through verified identities and personality-driven matching. The application emphasizes user safety, authentic profiles, and a seamless user experience.

### Key Principles

- ✅ **Identity Verification**: Face ID and document verification for authentic profiles
- ✅ **User Safety**: Comprehensive verification process and secure data handling
- ✅ **Clean Architecture**: Separation of concerns with BLoC pattern
- ✅ **AWS Integration**: Scalable cloud infrastructure
- ✅ **Mobile-First**: Optimized for iOS and Android platforms

---

## ✨ Features

### Authentication Module (Current Focus)

#### 1. 🎨 App Identification Elements
- Custom splash screen with brand logo
- Smooth transitions from splash to welcome screen
- Portrait-only orientation
- Permission requests (Notifications, Camera, Location)

#### 2. 📝 Account Creation (Multi-Step Process)
- **Step 1**: Personal Information
  - Full name (max 25 chars)
  - Phone number (10 digits, Colombian format)
  - Email (max 100 chars)
  - Date of birth (18+ validation)
  - Gender selection (Man, Woman, No Binari)
  - Interests (Man, Woman, Man and Woman)
  - Password creation with validation
  - Terms & conditions acceptance

- **Step 2**: OTP Verification
  - 4-digit code sent via SMS/Email
  - 10-minute expiration time
  - 30-second resend cooldown
  - Code validation

- **Step 3**: Face ID Verification (Optional)
  - Live facial capture
  - Biometric validation
  - Skip option with warning

- **Step 4**: Document Verification (Optional)
  - ID document capture (front & back)
  - Automatic validation
  - Legibility checks
  - Skip option with warning

- **Step 5**: Profile Images
  - Upload 2-6 images
  - Formats: JPG, JPEG, PNG, WEBP
  - Max size: 5 MB per image
  - Face verification match
  - Drag & drop reordering

- **Step 6**: Personality Onboarding
  - Multi-question survey
  - Various input types (text, number, multiple choice, dropdown)
  - Progress tracking
  - Skip option with warning

#### 3. 🔐 Login
- Phone number or email login
- Password authentication
- Google Sign-In integration
- Facebook Login integration
- "Remember me" functionality
- Forgot password link

#### 4. 🔑 Password Recovery
- Phone/email identification
- OTP verification (4 digits)
- New password creation
- Password confirmation
- Success redirect to login

### Upcoming Features
- 🏠 Home/Dashboard
- 👤 User Profile Management
- 💬 Chat & Messaging
- 🔍 Search & Filters
- ❤️ Matching System
- 🛍️ Marketplace
- 💳 Payments & Subscriptions
- 🔔 Push Notifications

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** state management:

```
lib/
├── core/                   # Core functionality
│   ├── config/            # App configuration
│   ├── constants/         # Constants & enums
│   ├── di/               # Dependency injection
│   ├── errors/           # Error handling
│   ├── network/          # API client
│   ├── theme/            # App theme
│   ├── utils/            # Utilities
│   └── widgets/          # Reusable widgets
├── features/              # Feature modules
│   └── auth/             # Authentication feature
│       ├── data/         # Data layer
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/       # Domain layer
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/ # Presentation layer
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── shared/               # Shared across features
```

### Architecture Layers

1. **Presentation Layer**: UI, BLoC, Pages, Widgets
2. **Domain Layer**: Entities, Use Cases, Repository Interfaces
3. **Data Layer**: Models, Data Sources, Repository Implementations

---

## 🛠️ Tech Stack

### Core
- **Flutter**: 3.16.0
- **Dart**: 3.0+

### State Management
- **flutter_bloc**: 8.1.3
- **equatable**: 2.0.5

### Dependency Injection
- **get_it**: 7.6.4
- **injectable**: 2.3.2

### Networking
- **dio**: 5.3.3
- **retrofit**: 4.0.3
- **pretty_dio_logger**: 1.3.1

### Local Storage
- **shared_preferences**: 2.2.2
- **flutter_secure_storage**: 9.0.0

### Environment Configuration
- **flutter_dotenv**: 5.1.0

### Routing
- **go_router**: 12.0.0

### UI Components
- **flutter_svg**: 2.0.9
- **cached_network_image**: 3.3.0
- **shimmer**: 3.0.0

### Forms & Validation
- **formz**: 0.6.1

### Permissions
- **permission_handler**: 11.0.1

### Camera & Images
- **image_picker**: 1.0.4
- **camera**: 0.10.5+5

### Location
- **geolocator**: 10.1.0

### Firebase
- **firebase_core**: 2.21.0
- **firebase_messaging**: 14.7.3
- **firebase_auth**: 4.14.0

### Authentication
- **google_sign_in**: 6.1.5

### Utilities
- **intl**: 0.18.1
- **logger**: 2.0.2+1
- **connectivity_plus**: 5.0.1

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.16.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development on macOS)
- Docker (optional, for containerized development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ForeverUsInLove_Frontend.git
   cd ForeverUsInLove_Frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your actual credentials
   ```

4. **Run code generation** (when needed)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific device
   flutter run -d <device_id>
   
   # For web
   flutter run -d chrome
   ```

---

## 🐳 Docker Setup

### Development Environment

```bash
# Start development server
docker-compose up flutter-dev

# Access at http://localhost:8080
```

### Production Web Build

```bash
# Build and serve production web app
docker-compose up flutter-web

# Access at http://localhost
```

### Docker Commands

```bash
# Build specific service
docker-compose build flutter-dev

# View logs
docker-compose logs -f flutter-dev

# Stop services
docker-compose down

# Remove volumes
docker-compose down -v

# Rebuild without cache
docker-compose build --no-cache
```

---

## ☁️ AWS Configuration

### Required AWS Services

1. **AWS S3**: Image and file storage
2. **AWS Cognito**: User authentication and management
3. **AWS Lambda** (Optional): Serverless functions for image processing
4. **AWS CloudFront** (Optional): CDN for faster content delivery

### Setup Steps

#### 1. AWS S3 Bucket Setup

```bash
# Create S3 bucket
aws s3 mb s3://forever-us-in-love-bucket --region us-east-1

# Configure CORS
aws s3api put-bucket-cors --bucket forever-us-in-love-bucket \
  --cors-configuration file://cors-config.json

# Set bucket permissions (private with signed URLs)
aws s3api put-public-access-block \
  --bucket forever-us-in-love-bucket \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

#### 2. AWS Cognito Setup

```bash
# Create user pool
aws cognito-idp create-user-pool \
  --pool-name ForeverUsInLove \
  --policies "PasswordPolicy={MinimumLength=8,RequireUppercase=true,RequireLowercase=true,RequireNumbers=true}" \
  --mfa-configuration OPTIONAL \
  --region us-east-1

# Create app client
aws cognito-idp create-user-pool-client \
  --user-pool-id <USER_POOL_ID> \
  --client-name ForeverUsInLoveMobile \
  --explicit-auth-flows ALLOW_USER_PASSWORD_AUTH ALLOW_REFRESH_TOKEN_AUTH
```

#### 3. AWS IAM Setup

Create IAM user with policies:
- AmazonS3FullAccess (or custom policy for specific bucket)
- AmazonCognitoPowerUser

Generate Access Key ID and Secret Access Key.

#### 4. Environment Variables

Update `.env` file:

```env
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_S3_BUCKET_NAME=forever-us-in-love-bucket
AWS_COGNITO_USER_POOL_ID=us-east-1_xxxxxxxxx
AWS_COGNITO_CLIENT_ID=your-client-id
```

---

## 📁 Project Structure

```
ForeverUsInLove_Frontend/
├── .github/                    # GitHub workflows and templates
├── android/                    # Android native code
├── assets/                     # Static assets
│   ├── images/                # Images
│   ├── icons/                 # Icons
│   └── fonts/                 # Custom fonts
├── ios/                        # iOS native code
├── lib/                        # Dart source code
│   ├── core/                  # Core functionality
│   │   ├── config/           # Configuration
│   │   │   └── app_config.dart
│   │   ├── constants/        # Constants
│   │   │   └── app_constants.dart
│   │   ├── di/              # Dependency injection
│   │   │   └── injection.dart
│   │   ├── errors/          # Error handling
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/         # Networking
│   │   │   └── api_client.dart
│   │   ├── theme/           # Theming
│   │   │   └── app_theme.dart
│   │   ├── utils/           # Utilities
│   │   │   └── validators.dart
│   │   └── widgets/         # Shared widgets
│   ├── features/             # Feature modules
│   │   └── auth/            # Authentication
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── shared/              # Shared code
│   └── main.dart            # App entry point
├── test/                     # Unit and widget tests
├── .dockerignore            # Docker ignore file
├── .env.example             # Example environment variables
├── .gitignore               # Git ignore file
├── analysis_options.yaml    # Dart analyzer options
├── docker-compose.yml       # Docker compose configuration
├── Dockerfile               # Docker configuration
├── nginx.conf               # Nginx configuration (for web)
├── pubspec.yaml             # Flutter dependencies
└── README.md                # This file
```

---

## 👨‍💻 Development Guidelines

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `analysis_options.yaml` for linting
- Run `flutter analyze` before committing
- Format code with `flutter format .`

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/auth-login

# Make changes and commit
git add .
git commit -m "feat: implement login screen"

# Push to remote
git push origin feature/auth-login

# Create pull request on GitHub
```

### Commit Message Convention

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Example**:
```
feat(auth): implement OTP verification

- Add OTP input screen
- Implement countdown timer
- Add resend code functionality

Closes #123
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/auth/login_test.dart

# Run with coverage
flutter test --coverage
```

---

## 📖 User Stories

### HU_001: App Identification Elements

**As a user**, I want to identify the ForeverUsInLove app among my applications.

**Acceptance Criteria**:
- Custom logo displayed on launch
- App name visible with capital letter
- Smooth splash screen transition
- Permission requests (Notifications, Camera, Location)
- No screen rotation
- Connection error handling

### HU_002: Create Account

**As a user**, I want to register on the platform to access all marketplace functionalities.

**Acceptance Criteria**:
- Multi-step registration process with progress bar
- Personal information form validation
- Phone/email OTP verification
- Password strength validation
- Terms & conditions acceptance
- Account activation confirmation

### HU_003: Identity Verification

**As a user**, I want to verify my identity through Face ID and document verification for account authenticity.

**Acceptance Criteria**:
- Live facial capture with guidance
- Document upload (front & back)
- Automatic validation checks
- Skip option with warning
- Error handling for poor quality images

### HU_004: Upload Images

**As a user**, I want to upload profile images validated by the identity verification system.

**Acceptance Criteria**:
- Upload 2-6 images
- Supported formats: JPG, JPEG, PNG, WEBP
- Max 5 MB per image
- Face verification match
- Preview and reorder functionality

### HU_005: Personality Onboarding

**As a user**, I want to answer personality questionnaires to receive personalized matches.

**Acceptance Criteria**:
- Multi-question survey
- Various input types
- Progress tracking
- Skip option
- Summary review before submission

### HU_006: Login

**As a registered user**, I want to log in easily and securely to access my account.

**Acceptance Criteria**:
- Phone/email login
- Password authentication
- Google/Facebook Sign-In
- "Remember me" option
- Forgot password link

### HU_007: Password Recovery

**As a registered user**, I want to recover my password if forgotten.

**Acceptance Criteria**:
- Phone/email identification
- OTP verification
- New password creation
- Password confirmation
- Success message and redirect

---

## 📝 Environment Variables Reference

See `.env.example` for all available configuration options.

### Critical Variables

```env
# API Configuration
API_BASE_URL=https://api.example.com/v1
API_KEY=your-api-key

# AWS Configuration
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_S3_BUCKET_NAME=your-bucket-name
AWS_COGNITO_USER_POOL_ID=your-pool-id
AWS_COGNITO_CLIENT_ID=your-client-id

# OAuth
GOOGLE_CLIENT_ID=your-google-client-id
FACEBOOK_APP_ID=your-facebook-app-id

# Environment
ENVIRONMENT=development
ENABLE_LOGGING=true
```

---

## 🤝 Contributing

This is a proprietary project. Contributions are limited to authorized team members.

### For Authorized Contributors

1. Create a feature branch
2. Make your changes
3. Write tests
4. Submit a pull request
5. Wait for code review

---

## 📄 License

This project is proprietary and confidential. Unauthorized copying, distribution, or use is strictly prohibited.

© 2025 ForeverUsInLove. All rights reserved.

---

## 📞 Support

For technical support or questions, contact the development team:
- **Email**: luis.gomez@imagineapps.co


---

## 📅 Project Status

- **Current Version**: 1.0.0
- **Status**: 🚧 In Development (Architecture Setup Phase)
- **Last Updated**: 2025
- **Next Milestone**: UI/UX Approval & Implementation

---

## 🗺️ Roadmap

### Phase 1: Architecture & Setup ✅
- [x] Project structure setup
- [x] Clean architecture implementation
- [x] Docker configuration
- [x] AWS integration setup
- [x] Environment configuration

### Phase 2: Authentication Module (Current) 🚧
- [ ] Splash screen
- [ ] Welcome screen
- [ ] Registration flow (6 steps)
- [ ] Login screen
- [ ] Password recovery
- [ ] OAuth integration (Google/Facebook)

### Phase 3: Core Features 📋
- [ ] Home/Dashboard
- [ ] User profile
- [ ] Matching system
- [ ] Chat functionality

### Phase 4: Marketplace 📋
- [ ] Product listings
- [ ] Search & filters
- [ ] Shopping cart
- [ ] Payment integration

### Phase 5: Polish & Launch 📋
- [ ] Performance optimization
- [ ] Security audit
- [ ] Beta testing
- [ ] App store submission

---

<div align="center">

**Made with ❤️ by the ForeverUsInLove Team**

</div>
