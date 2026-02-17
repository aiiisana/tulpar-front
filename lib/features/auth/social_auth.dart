import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuth {
  static final GoogleSignIn _google = GoogleSignIn(scopes: ['email', 'profile']);

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    return await _google.signIn();
  }

  static Future<AuthorizationCredentialAppleID> signInWithApple() async {
    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
  }

  static Future<void> signOutGoogle() async {
    await _google.signOut();
  }
}
