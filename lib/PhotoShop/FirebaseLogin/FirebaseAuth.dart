import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/CustomToast/CustomToast.dart';

class FirebaseAuthentication {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google Sign-In cancelled by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      // Log detailed PlatformException information for debugging
      print('PlatformException during Google Sign-In:');
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      print('Details: ${e.details}'); // This often contains nested API error details

      if (e.code == 'sign_in_failed') {
        // Specifically handle the sign_in_failed error.
        // The message "com.google.android.gms.common.api.ApiException: 10:"
        // points to configuration issues (e.g., incorrect SHA fingerprints in Firebase Console)
        // or problems with Google Play Services on the device.
        if (e.message != null && e.message!.contains('ApiException: 10')) {
          throw Exception(
            'Google Sign-In failed due to an API configuration error or a problem with Google Play Services on your device. '
                'Please ensure your app\'s SHA fingerprints are correctly registered in Firebase Console and '
                'Google Play Services is updated on your device. Error details: ${e.message}',
          );
        } else {
          // Other sign_in_failed reasons
          throw Exception('Google Sign-In failed unexpectedly: ${e.message}');
        }
      } else if (e.code == 'network_request_failed') {
        throw Exception('Network error during Google Sign-In. Please check your internet connection.');
      } else if (e.code == 'user_cancelled') {
        // This is typically handled by `googleUser == null` check, but good to have
        print('Google Sign-In flow was cancelled by the user.');
        return null;
      }
      // Re-throw any unhandled PlatformExceptions
      rethrow;
    } catch (e) {
      // Catch any other general exceptions not covered by PlatformException
      print('An unexpected error occurred during Google Sign-In: $e');
      rethrow;
    }
  }

  //Sign Out
  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   "/gmailAuth",
      //       (route) => false,
      // );
      showSuccessToast("Successfully Sign Out ");
    } catch (err) {
      showErrorToast("Error Occurred in Sign out");
      throw FirebaseAuthException(
        code: 'Sign out Error',
        message: 'Error Occurred in Sign out',
      );
    }
  }
}