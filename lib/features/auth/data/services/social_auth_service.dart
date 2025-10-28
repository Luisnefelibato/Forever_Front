import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Social Authentication Service
/// 
/// Handles Google and Facebook authentication flows
class SocialAuthService {
  final AuthRepository _authRepository;
  
  // Google Sign In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  SocialAuthService({required AuthRepository authRepository}) 
      : _authRepository = authRepository;

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return const Left(ServerFailure(message: 'Google sign-in cancelled'));
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        return const Left(ServerFailure(message: 'Failed to get Google ID token'));
      }

      // Login with backend using the ID token
      final result = await _authRepository.googleLogin(googleAuth.idToken!);
      
      return result;
    } catch (e) {
      return Left(ServerFailure(message: 'Google sign-in error: $e'));
    }
  }

  /// Sign in with Facebook
  Future<Either<Failure, User>> signInWithFacebook() async {
    try {
      // Sign in with Facebook
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        
        // Get user data for additional information
        final userData = await FacebookAuth.instance.getUserData();
        
        // Login with backend using the access token
        final loginResult = await _authRepository.facebookLogin(accessToken.token);
        
        return loginResult;
      } else if (result.status == LoginStatus.cancelled) {
        return const Left(ServerFailure(message: 'Facebook sign-in cancelled'));
      } else {
        return Left(ServerFailure(message: 'Facebook sign-in failed: ${result.message}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Facebook sign-in error: $e'));
    }
  }

  /// Sign out from Google
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  /// Sign out from Facebook
  Future<void> signOutFromFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  /// Sign out from all social platforms
  Future<void> signOutFromAll() async {
    await Future.wait([
      signOutFromGoogle(),
      signOutFromFacebook(),
    ]);
  }

  /// Check if user is signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current Google user
  Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
    return await _googleSignIn.signInSilently();
  }
}
