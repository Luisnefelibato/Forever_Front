import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/pages/splash_page.dart';
import 'features/onboarding/presentation/pages/intro_page_1.dart';
import 'features/onboarding/presentation/pages/intro_page_2.dart';
import 'features/onboarding/presentation/pages/intro_page_3.dart';
import 'features/onboarding/presentation/pages/permissions_page.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_email_page.dart';
import 'features/auth/presentation/pages/register_phone_page.dart';
import 'features/auth/presentation/pages/create_password_page.dart';
import 'features/auth/presentation/pages/forgot_password_email_page.dart';
import 'features/auth/presentation/pages/forgot_password_code_page.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';
import 'features/auth/presentation/pages/password_changed_page.dart';
import 'features/auth/presentation/pages/account_created_page.dart';
import 'features/auth/presentation/pages/about_you_name_page.dart';
import 'features/auth/presentation/pages/about_you_birthdate_page.dart';
import 'features/auth/presentation/pages/about_you_gender_page.dart';
import 'features/auth/presentation/pages/about_you_interests_page.dart';
import 'features/auth/presentation/pages/about_you_looking_for_page.dart';
import 'features/auth/presentation/pages/about_you_location_page.dart';
import 'features/auth/presentation/pages/verification_prompt_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load().catchError((_) {
    // If .env doesn't exist, continue without it
    debugPrint('Warning: .env file not found, using default values');
  });
  
  // Configure dependency injection
  await configureDependencies();
  
  // Lock screen orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Firebase (when implemented)
  // await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'ForeverUsInLove',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Start with Splash Screen
      home: const SplashPage(),
      // Define routes
      routes: {
        '/splash': (context) => const SplashPage(),
        '/onboarding-intro-1': (context) => const IntroPage1(),
        '/onboarding-intro-2': (context) => const IntroPage2(),
        '/onboarding-intro-3': (context) => const IntroPage3(),
        '/permissions': (context) => const PermissionsPage(),
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register-email': (context) => const RegisterEmailPage(),
        '/register-phone': (context) => const RegisterPhonePage(),
        '/forgot-password': (context) => const ForgotPasswordEmailPage(),
        '/password-changed': (context) => const PasswordChangedPage(),
        '/account-created': (context) => const AccountCreatedPage(),
        '/about-you': (context) => const PlaceholderScreen(), // TODO: Replace with actual AboutYouPage
        '/home': (context) => const PlaceholderScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle routes with arguments
        if (settings.name == '/create-password') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => CreatePasswordPage(
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
              registrationType: args?['registrationType'] as String?,
            ),
          );
        }
        if (settings.name == '/forgot-password-code') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => ForgotPasswordCodePage(
              email: args?['email'] ?? '',
            ),
          );
        }
        if (settings.name == '/reset-password') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => ResetPasswordPage(
              resetToken: args?['resetToken'] as String?,
            ),
          );
        }
        if (settings.name == '/about-you-name') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AboutYouNamePage(
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
            ),
          );
        }
        if (settings.name == '/about-you-birthdate') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AboutYouBirthdatePage(
              firstName: args?['firstName'] as String?,
              lastName: args?['lastName'] as String?,
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
            ),
          );
        }
        if (settings.name == '/about-you-gender') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AboutYouGenderPage(
              firstName: args?['firstName'] as String?,
              lastName: args?['lastName'] as String?,
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
              birthDay: args?['birthDay'] as int?,
              birthMonth: args?['birthMonth'] as int?,
              birthYear: args?['birthYear'] as int?,
            ),
          );
        }
        if (settings.name == '/about-you-interests') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AboutYouInterestsPage(
              firstName: args?['firstName'] as String?,
              lastName: args?['lastName'] as String?,
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
              birthDay: args?['birthDay'] as int?,
              birthMonth: args?['birthMonth'] as int?,
              birthYear: args?['birthYear'] as int?,
              gender: args?['gender'] as String?,
            ),
          );
        }
        if (settings.name == '/about-you-looking-for') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AboutYouLookingForPage(
              firstName: args?['firstName'] as String?,
              lastName: args?['lastName'] as String?,
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
              birthDay: args?['birthDay'] as int?,
              birthMonth: args?['birthMonth'] as int?,
              birthYear: args?['birthYear'] as int?,
              gender: args?['gender'] as String?,
              interests: args?['interests'] as String?,
            ),
          );
        }
        if (settings.name == '/about-you-location') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AboutYouLocationPage(
              firstName: args?['firstName'] as String?,
              lastName: args?['lastName'] as String?,
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
              birthDay: args?['birthDay'] as int?,
              birthMonth: args?['birthMonth'] as int?,
              birthYear: args?['birthYear'] as int?,
              gender: args?['gender'] as String?,
              interests: args?['interests'] as String?,
              lookingFor: args?['lookingFor'] as String?,
            ),
          );
        }
        if (settings.name == '/verification-prompt') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => VerificationPromptPage(
              firstName: args?['firstName'] as String?,
              lastName: args?['lastName'] as String?,
              email: args?['email'] as String?,
              phone: args?['phone'] as String?,
              countryCode: args?['countryCode'] as String?,
              birthDay: args?['birthDay'] as int?,
              birthMonth: args?['birthMonth'] as int?,
              birthYear: args?['birthYear'] as int?,
              gender: args?['gender'] as String?,
              interests: args?['interests'] as String?,
              lookingFor: args?['lookingFor'] as String?,
              location: args?['location'] as String?,
            ),
          );
        }
        return null;
      },
    );
}

/// Placeholder screen until UI/UX is approved
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'ForeverUsInLove',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Awaiting UI/UX Approval',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
          ],
        ),
      ),
    );
}
